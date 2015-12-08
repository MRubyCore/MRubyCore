//
//  MRBContext.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public final class MRBContext {
    public enum Error: ErrorType {
        case ParseError(message: String)
        case RuntimeException(message: String)
    }

    private static let currentContextIdentifier = "MRBContext_" + NSUUID().UUIDString
    internal static func currentContext() -> MRBContext? {
        return NSThread.currentThread().threadDictionary.objectForKey(MRBContext.currentContextIdentifier) as? MRBContext
    }

    internal let state: UnsafeMutablePointer<mrb_state>
    internal let context: UnsafeMutablePointer<mrbc_context>

    public private (set) lazy var topSelf: MRBValue = {
        return MRBValue(value: mrb_top_self(self.state), context: self)
    }()

    public init() {
        state = mrb_open()
        if state.isNull {
            context = UnsafeMutablePointer<mrbc_context>.null
            fatalError("mrb_open() failed")
        }

        context = mrbc_context_new(state)
        if context.isNull {
            mrb_close(state)
            fatalError("mrbc_context_new() failed")
        }

        context.memory.capture_errors = 1
        context.memory.lineno = 1

        var filename = "(MRBContext) ".cStringUsingEncoding(NSUTF8StringEncoding)!
        mrbc_filename(state, context, &filename)

        NSThread.currentThread().threadDictionary.setObject(self, forKey: MRBContext.currentContextIdentifier)
    }

    deinit {
        mrbc_context_free(state, context)
        mrb_close(state)
    }

    public func evaluateScript(script: String, topSelf: MRBValue? = nil) throws -> MRBValue {
        let gc = mrb_gc_arena_save(state)
        defer {
            mrb_gc_arena_restore(state, gc)
        }

        let parser = try getParser(script)
        defer {
            mrb_parser_free(parser)
        }

        let proc = mrb_generate_code(state, parser)
        guard proc != proc.dynamicType.init() else {
            throw Error.ParseError(message: "failed to generate code")
        }

        let value = mrb_run(state, proc, (topSelf ?? self.topSelf).rawValue)

        try checkForRuntimeException()

        return MRBValue(value: value, context: self)
    }

    internal func checkForRuntimeException() throws {
        guard state.memory.exc.isNull else {
            let message: String = MRBValue(value: mrb_obj_value(state.memory.exc), context: self).inspection
            state.memory.exc.setNull()
            throw Error.RuntimeException(message: message)
        }
    }

    private func getParser(script: String) throws -> UnsafeMutablePointer<mrb_parser_state> {
        // inspired by mrbgems/mruby-bin-mirb/tools/mirb/mirb.c

        guard var s = script.cStringUsingEncoding(NSUTF8StringEncoding) else {
            throw Error.ParseError(message: "invalid input string")
        }

        let parser = mrb_parser_new(state)

        if parser.isNull {
            throw Error.ParseError(message: "failed to create parser")
        }

        withUnsafePointer(&s[0]) {
            parser.memory.s = $0
            parser.memory.send = $0.advancedBy(s.count)
        }

        parser.memory.lineno = parser.memory.lineno.dynamicType.init(context.memory.lineno)
        mrb_parser_parse(parser, context)

        // unterminated heredoc
        if !parser.memory.parsing_heredoc.isNull {
            throw Error.ParseError(message: "unterminated heredoc")
        }

        // unterminated string
        if !parser.memory.lex_strterm.isNull {
            throw Error.ParseError(message: "unterminated string")
        }

        // parser error
        if parser.memory.nerr != 0 {
            let message = parser.memory.error_buffer.0.message.flatMap {
                String(CString: $0, encoding: NSUTF8StringEncoding)
            }

            throw Error.ParseError(message: message ?? "syntax error")
        }

        switch parser.memory.lstate {
        case EXPR_DOT:
            throw Error.ParseError(message: "a message dot was the last token, there has to come more")
        case EXPR_CLASS:
            throw Error.ParseError(message: "a class keyword is not enough! we need also a name of the class")
        case EXPR_FNAME:
            throw Error.ParseError(message: "a method name is necessary")
        case EXPR_VALUE:
            throw Error.ParseError(message: "if, elsif, etc. without condition")
        default:
            break
        }

        return parser
    }
}

private extension UnsafeMutablePointer {
    static var null: UnsafeMutablePointer {
        return self.init()
    }

    var isNull: Bool {
        return self == self.dynamicType.null
    }

    mutating func setNull() {
        self = self.dynamicType.null
    }

    func flatMap<U>(f: (UnsafeMutablePointer) throws -> U?) rethrows -> U? {
        guard !isNull else { return nil }

        return try f(self)
    }
}
