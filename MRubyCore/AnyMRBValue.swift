//
//  AnyMRBValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

public struct AnyMRBValue: Hashable, MRBValueConvertible {
    enum AnyValue {
        case Partial(MRBPartialValue)
        case Complete(MRBValue)
    }

    private let __value: AnyValue

    init(_ value: MRBValueConvertible) {
        switch value {
        case let v as MRBPartialValue: __value = .Partial(v)
        case let v as MRBValue: __value = .Complete(v)
        case let v as AnyMRBValue: __value = v.__value
        case let v as MRBPartialConvertible: __value = .Partial(v.partialValue)
        default:
            print(value, value.dynamicType)
            fatalError("value is neither MRBPartialValue nor MRBValue nor AnyMRBValue, unsupported")
        }
    }

    public func apply(context context: MRBContext) -> MRBValue {
        switch __value {
        case .Partial(let v):
            return v.apply(context: context)
        case .Complete(let v):
            return v.apply(context: context)
        }
    }

    public var hashValue: Int {
        switch __value {
        case .Partial(let v): return v.hashValue
        case .Complete(let v): return v.hashValue
        }
    }
}

public func == (lhs: AnyMRBValue, rhs: AnyMRBValue) -> Bool {
    switch lhs.__value {
    case .Partial(let v0):
        switch rhs.__value {
        case .Partial(let v1): return v0 == v1
        default: return false
        }
    case .Complete(let v0):
        switch rhs.__value {
        case .Complete(let v1): return v0.equalsTo(v1)
        default: return false
        }
    }
}
