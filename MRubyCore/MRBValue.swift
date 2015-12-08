//
//  MRBValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public struct MRBValue: CustomDebugStringConvertible {
    internal let rawValue: mrb_value
    internal unowned let context: MRBContext

    internal init(value: mrb_value, context: MRBContext) {
        self.rawValue = value
        self.context = context
    }

    public var valueType: MRBValueType {
        return MRBValueType(type: MRBGetType(rawValue), value: rawValue)
    }

    public var debugDescription: String {
        return "{MRBValue <\(valueType)> \(inspection) }"
    }
}

extension MRBValue {
    public func send(message: String, parameters: [MRBValue]) throws -> MRBValue {
        let returnValue: mrb_value = send(message, parameters: parameters)
        try context.checkForRuntimeException()
        return MRBValue(value: returnValue, context: context)
    }

    private func send(message: String, parameters: [MRBValue]) -> mrb_value {
        var params = parameters.map { $0.rawValue }
        return mrb_funcall_argv(context.state, rawValue, message.toSym(inContext: context), mrb_int(parameters.count), &params)
    }

    public var inspection: String {
        let inspection: mrb_value = self.send("inspect", parameters: [])
        return String(CString: mrb_string_value_ptr(context.state, inspection), encoding: NSUTF8StringEncoding)!
    }
}

extension MRBValue: IntegerLiteralConvertible {
    public init(integerLiteral value: mrb_int) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_fixnum_value(value), context: context)
    }
}

extension MRBValue: FloatLiteralConvertible {
    public init(floatLiteral value: mrb_float) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_float_value(context.state, value), context: context)
    }
}

extension MRBValue: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_nil_value(), context: context)
    }
}

extension MRBValue: StringLiteralConvertible, UnicodeScalarLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible {
    public init(stringLiteral value: String) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        let cstr = value.cStringUsingEncoding(NSUTF8StringEncoding)!
        self.init(value: mrb_str_new_cstr(context.state, cstr), context: context)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension MRBValue: BooleanLiteralConvertible {
    public init(booleanLiteral value: Bool) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_bool_value(value ? 1 : 0), context: context)
    }
}
