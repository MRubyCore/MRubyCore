//
//  MRBRangeElementValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

/// Holds mruby value of type:
/// mrb_int, string, and any value that respond_to :<=> and :succ
public struct MRBRangeElementValue: MRBValue {
    public let rawValue: mrb_value
    public unowned let context: MRBContext
    public let _mrbLocalVariableCounterWrapper = _MRBLocalVariableCounterWrapper()

    init(value: mrb_value, context: MRBContext) {
        self.rawValue = value
        self.context = context
    }
}

extension MRBRangeElementValue {
    static func eligible(value: mrb_value, context: MRBContext) -> Bool {
        return mrb_respond_to(context.state, value, "succ".toSym(inContext: context)) != 0 &&
               mrb_respond_to(context.state, value, "<=>".toSym(inContext: context)) != 0
    }
}

extension MRBRangeElementValue: ForwardIndexType {
    public func successor() -> MRBRangeElementValue {
        return try! send("succ", parameters: []) as! MRBRangeElementValue
    }
}
