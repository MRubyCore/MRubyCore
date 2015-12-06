//
//  MRBValueConvertible.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public protocol MRBValueConvertible {
    init!(value: MRBValue)
}

extension mrb_int: MRBValueConvertible {
    public init!(value: MRBValue) {
        guard value.valueType == .FixNum else { return nil }

        self = MRB_Fixnum(value.rawValue)
    }
}

extension mrb_float: MRBValueConvertible {
    public init!(value: MRBValue) {
        guard value.valueType == .Float else { return nil }

        self = MRB_Float(value.rawValue)
    }
}

extension String: MRBValueConvertible {
    public init!(value: MRBValue) {
        guard value.valueType == .String else { return nil }

        let cstr = mrb_string_value_ptr(value.context.state, value.rawValue)
        self = String(CString: cstr, encoding: NSUTF8StringEncoding)!
    }
}

extension Bool: MRBValueConvertible {
    public init!(value: MRBValue) {
        switch value.valueType {
        case .True:
            self = true
        case .False:
            self = false
        default:
            return nil
        }
    }
}
