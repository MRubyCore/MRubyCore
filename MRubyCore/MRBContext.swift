//
//  MRBContext.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public class MRBContext {
    internal let state: UnsafeMutablePointer<mrb_state>
    internal let context: UnsafeMutablePointer<mrbc_context>

    public init() {
        state = mrb_open()
        context = mrbc_context_new(state)
    }

    deinit {
        mrbc_context_free(state, context)
        mrb_close(state)
    }

    public func evaluateScript(script: String) -> MRBValue {
        var s = script.cStringUsingEncoding(NSUTF8StringEncoding)!
        let ps = mrb_parse_string(state, &s, context)
        let proc = mrb_generate_code(state, ps)
        let value = mrb_run(state, proc, mrb_top_self(state))
        return MRBValue(value: value, context: self)
    }
}
