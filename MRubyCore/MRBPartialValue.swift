//
//  MRBPartialValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/15.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public enum MRBPartialValue {
    case Integer(mrb_int)
    case Float(mrb_float)
    case Nil()
    case String(Swift.String)
    case Bool(Swift.Bool)
    indirect case Array([MRBValueConvertible])
    indirect case Dictionary([AnyMRBValue: MRBValueConvertible])
    indirect case Range(MRBValueConvertible, MRBValueConvertible)
}

extension MRBPartialValue: MRBValueConvertible {
    public func inContext(context: MRBContext) -> MRBValue {
        switch self {
        case .Integer(let v):
            return mrb_fixnum_value(v) ⨝ context
        case .Float(let v):
            return mrb_float_value(context.state, v) ⨝ context
        case .Nil():
            return mrb_nil_value() ⨝ context
        case .String(let v):
            let cstr = v.cStringUsingEncoding(NSUTF8StringEncoding)!
            return mrb_str_new_cstr(context.state, cstr) ⨝ context
        case .Bool(let v):
            return mrb_bool_value(v ? 1 : 0) ⨝ context
        case .Array(let v):
            let values = v.map {
                $0.inContext(context)
            }

            if values.isEmpty {
                return mrb_ary_new(context.state) ⨝ context
            }

            var rawValues = values.map { $0.rawValue }
            return mrb_ary_new_from_values(context.state, mrb_int(values.count), &rawValues) ⨝ context
        case .Dictionary(let v):
            let kv = v.map {
                (key: $0.inContext(context), value: $1.inContext(context))
            }

            let dict = mrb_hash_new_capa(context.state, Int32(kv.count))

            kv.forEach {
                mrb_hash_set(context.state, dict, $0.key.rawValue, $0.value.rawValue)
            }

            return dict ⨝ context
        case .Range(let start, let end):
            let range = mrb_range_new(context.state, start.inContext(context).rawValue, end.inContext(context).rawValue, 1)
            return range ⨝ context
        }
    }
}

extension MRBPartialValue: Hashable {
    private enum ValueType {
        case Integer
        case Float
        case Nil
        case String
        case Bool
        case Array
        case Dictionary
        case Range
    }

    private var valueType: ValueType {
        switch self {
        case .Integer:
            return .Integer
        case .Float:
            return .Float
        case .Nil:
            return .Nil
        case .String:
            return .String
        case .Bool:
            return .Bool
        case .Array:
            return .Array
        case .Dictionary:
            return .Dictionary
        case .Range:
            return .Range
        }
    }

    private var value: Any {
        switch self {
        case .Integer(let v):
            return v
        case .Float(let v):
            return v
        case .Nil:
            return ()
        case .String(let v):
            return v
        case .Bool(let v):
            return v
        case .Array(let v):
            return v
        case .Dictionary(let v):
            return v
        case .Range(let start, let end):
            return (start, end)
        }
    }

    public var hashValue: Int {
        switch self {
        case .Integer(let v):
            return v.hashValue
        case .Float(let v):
            return v.hashValue
        case .Nil:
            return 0
        case .String(let v):
            return v.hashValue
        case .Bool(let v):
            return v.hashValue
        case .Array(let v):
            return (v.map { AnyMRBValue($0).hashValue } as NSArray).hashValue
        case .Dictionary(let v):
            return (v.map { ($0.hashValue, AnyMRBValue($1).hashValue) }.reduce([:]) { (m: [Int: Int], kv) in
                var m = m
                m[kv.0] = kv.1
                return m
            } as NSDictionary).hashValue
        case .Range(let begin, let end):
            return ([begin, end].map { AnyMRBValue($0).hashValue } as NSArray).hashValue
        }
    }
}

public func == (lhs: MRBPartialValue, rhs: MRBPartialValue) -> Bool {
    guard lhs.valueType == rhs.valueType else { return false }

    switch lhs.valueType {
    case .Integer:
        return (lhs.value as! mrb_int) == (rhs.value as! mrb_int)
    case .Float:
        return (lhs.value as! mrb_float) == (rhs.value as! mrb_float)
    case .Nil:
        return true
    case .String:
        return (lhs.value as! String) == (rhs.value as! String)
    case .Bool:
        return (lhs.value as! Bool) == (rhs.value as! Bool)
    case .Array:
        return AnyMRBValue(lhs.value as! [MRBValueConvertible]) == AnyMRBValue(rhs.value as! [MRBValueConvertible])
    case .Dictionary:
        return AnyMRBValue(lhs.value as! [AnyMRBValue: MRBValueConvertible]) == AnyMRBValue(rhs.value as! [AnyMRBValue: MRBValueConvertible])
    case .Range:
        let a = lhs.value as! (MRBValueConvertible, MRBValueConvertible)
        let b = rhs.value as! (MRBValueConvertible, MRBValueConvertible)

        return AnyMRBValue(a.0) == AnyMRBValue(b.0) && AnyMRBValue(a.1) == AnyMRBValue(b.1)
    }
}
