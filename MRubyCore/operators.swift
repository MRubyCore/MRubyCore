//
//  operators.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

infix operator ⨝ { associativity none precedence 255 }

/// Create a MRBValue
/// from given mrb_value and MRBContext
func ⨝ (lhs: mrb_value, rhs: MRBContext) -> MRBValue {
    if MRBRangeElementValue.eligible(lhs, context: rhs) {
        return MRBRangeElementValue(value: lhs, context: rhs)
    }

    return MRBGeneralValue(value: lhs, context: rhs)
}
