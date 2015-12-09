//
//  operators.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

infix operator ⨝ { associativity none precedence 255 }
prefix operator ↢ { }

/// Create a MRBValue
/// from given mrb_value and MRBContext
func ⨝ (lhs: mrb_value, rhs: MRBContext) -> MRBValue {
    if MRBRangeElementValue.eligible(lhs, context: rhs) {
        return MRBRangeElementValue(value: lhs, context: rhs)
    }

    return MRBGeneralValue(value: lhs, context: rhs)
}

// Create a MRBValue
// from given key values pairs
prefix func ↢(input: [(MRBValueConvertible, MRBValueConvertible)]) -> MRBValue {
    guard let context = input.first?.0.mrbValue.context ?? MRBContext.currentContext() else {
        fatalError("invalid MRBContext")
    }

    let kv = input.map {
        (key: AnyMRBValue($0.mrbValue), value: $1.mrbValue)
    }

    let dict = mrb_hash_new_capa(context.state, Int32(kv.count))

    kv.forEach {
        mrb_hash_set(context.state, dict, $0.key.rawValue, $0.value.rawValue)
    }

    return dict ⨝ context
}
