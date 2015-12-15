//
//  MRBGeneralValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

/// Holds mruby value of type:
/// mrb_int, mrb_float, nil, string, bool
struct MRBGeneralValue: MRBValue, Hashable {
    let rawValue: mrb_value
    unowned let context: MRBContext
    let _mrbLocalVariableCounterWrapper = _MRBLocalVariableCounterWrapper()

    init(value: mrb_value, context: MRBContext) {
        self.rawValue = value
        self.context = context
    }
}
