//
//  MRBValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public protocol MRBValue: CustomDebugStringConvertible, MRBValueConvertible {
    var rawValue: mrb_value { get }
    unowned var context: MRBContext { get }
}

// MARK - convertible conformance

public extension MRBValue {
    public var mrbValue: MRBValue {
        return self
    }
}

// MARK - default property & methods

public extension MRBValue {
    public var valueType: MRBValueType {
        return MRBValueType(type: MRBGetType(rawValue), value: rawValue)
    }

    public var debugDescription: String {
        return "{MRBValue <\(valueType)> \(inspection) }"
    }

    public var inspection: String {
        let inspection: mrb_value = self.send("inspect", parameters: [])
        return String(CString: mrb_string_value_ptr(context.state, inspection), encoding: NSUTF8StringEncoding)!
    }

    private func send(message: String, parameters: [MRBValue]) -> mrb_value {
        var params = parameters.map { $0.rawValue }
        return mrb_funcall_argv(context.state, rawValue, message.toSym(inContext: context), mrb_int(parameters.count), &params)
    }

    public func send(message: String, parameters: [MRBValueConvertible]) throws -> MRBValue {
        let returnValue: mrb_value = send(message, parameters: parameters.map { $0.mrbValue })
        try context.checkForRuntimeException()
        return returnValue ⨝ context
    }
}

// MARK - Hashable & Equatable conformance, see AnyMRBValue for more impormation

public extension MRBValue {
    public var hashValue: Int {
        return Int(MRBReadFixnum(send("hash", parameters: [])))
    }
}

public func == <T: MRBValue>(lhs: T, rhs: T) -> Bool {
    guard lhs.context == rhs.context else { return false }
    return mrb_equal(lhs.context.state, lhs.rawValue, rhs.rawValue) != 0
}

// MARK - values

public extension MRBValue {
    public var arrayValue: [MRBValue]? {
        guard valueType == MRBValueType.Array else { return nil }

        let length = mrb_ary_len(context.state, rawValue)
        return (0 ..< length).map {
            mrb_ary_entry(rawValue, $0)
        }.map {
            $0 ⨝ context
        }
    }

    public var dictionaryValue: [AnyMRBValue: MRBValue]? {
        guard valueType == MRBValueType.Hash else { return nil }

        guard let keys = (mrb_hash_keys(context.state, rawValue) ⨝ context).arrayValue else {
            return nil
        }

        return keys.map {
            ($0, mrb_hash_get(context.state, rawValue, $0.rawValue))
        }.map {
            (key: AnyMRBValue($0), value: $1 ⨝ context)
        }.reduce([:], combine: { m, v in
            var m = m!
            m[v.key] = v.value
            return m
        })
    }

    public var rangeValue: Range<MRBRangeElementValue>? {
        guard valueType == MRBValueType.Range else { return nil }

        let range = MRBReadRange(rawValue)
        let excl = range.memory.excl != 0

        guard let start = range.memory.edges.memory.beg ⨝ context as? MRBRangeElementValue,
                    end = range.memory.edges.memory.end ⨝ context as? MRBRangeElementValue else {
                return nil
        }

        return Range(start: start, end: excl ? end : end.successor())
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

    public var floatValue: mrb_float? {
        guard valueType == .Float else { return nil }

        return MRBReadFloat(rawValue)
    }

    public var integerValue: mrb_int? {
        guard valueType == .FixNum else { return nil }

        return MRBReadFixnum(rawValue)
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
