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
