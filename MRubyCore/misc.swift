//
//  misc.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/8.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

extension String {
    func toSym(inContext context: MRBContext) -> mrb_sym {
        var s = cStringUsingEncoding(NSUTF8StringEncoding)!
        return mrb_intern_cstr(context.state, &s)
    }
}

infix operator ⨝ { associativity left precedence 255 }

/// Create a MRBValue
/// from given mrb_value and MRBContext
func ⨝ (lhs: mrb_value, rhs: MRBContext) -> MRBValue {
    if MRBRangeElementValue.eligible(lhs, context: rhs) {
        return MRBRangeElementValue(value: lhs, context: rhs)
    }

    return MRBGeneralValue(value: lhs, context: rhs)
}
