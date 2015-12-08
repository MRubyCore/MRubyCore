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
    public func send(message: String, parameters: [MRBValueConvertible]) throws -> MRBValue {
        let returnValue: mrb_value = send(message, parameters: parameters.map { $0.mrbValue })
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

extension MRBValue: Hashable, Equatable {
    public var hashValue: Int {
        return Int(MRBReadFixnum(send("hash", parameters: [])))
    }
}

public func == (lhs: MRBValue, rhs: MRBValue) -> Bool {
    guard lhs.context == rhs.context else { return false }
    return mrb_equal(lhs.context.state, lhs.rawValue, rhs.rawValue) != 0
}

extension MRBValue {
    public var arrayValue: [MRBValue]? {
        guard valueType == .Array else { return nil }

        let length = mrb_ary_len(context.state, rawValue)
        return (0 ..< length).map {
            mrb_ary_entry(rawValue, $0)
        }.map {
            MRBValue(value: $0, context: context)
        }
    }

    public var dictionaryValue: [MRBValue: MRBValue]? {
        guard valueType == .Hash else { return nil }

        guard let keys = MRBValue(value: mrb_hash_keys(context.state, rawValue), context: context).arrayValue else {
            return nil
        }

        return keys.map {
            ($0, mrb_hash_get(context.state, rawValue, $0.rawValue))
        }.map {
            (key: $0, value: MRBValue(value: $1, context: context))
        }.reduce([:], combine: { m, v in
            var m = m!
            m[v.key] = v.value
            return m
        })
    }

    public var stringValue: String? {
        switch valueType {
        case .String:
            let cstr = mrb_string_value_ptr(context.state, rawValue)
            return String(CString: cstr, encoding: NSUTF8StringEncoding)!
        case .Symbol:
            let cstr = MRBReadSymbol(context.state, rawValue)
            return String(CString: cstr, encoding: NSUTF8StringEncoding)!
        default:
            return nil
        }
    }

    public var floatValue: Double? {
        guard valueType == .Float else { return nil }

        return MRBReadFloat(rawValue)
    }

    public var integerValue: Int? {
        guard valueType == .FixNum else { return nil }

        return Int(MRBReadFixnum(rawValue))
    }

    public var boolValue: Bool? {
        switch valueType {
        case .True:
            return true
        case .False:
            return false
        default:
            return nil
        }
    }
}
