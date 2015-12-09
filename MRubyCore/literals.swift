//
//  literals.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

extension MRBRangeElementValue: IntegerLiteralConvertible {
    public init(integerLiteral value: mrb_int) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_fixnum_value(value), context: context)
    }
}

extension MRBGeneralValue: FloatLiteralConvertible {
    init(floatLiteral value: mrb_float) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_float_value(context.state, value), context: context)
    }
}

extension MRBGeneralValue: NilLiteralConvertible {
    init(nilLiteral: ()) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_nil_value(), context: context)
    }
}

extension MRBRangeElementValue: StringLiteralConvertible, UnicodeScalarLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible {
    public init(stringLiteral value: String) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        let cstr = value.cStringUsingEncoding(NSUTF8StringEncoding)!
        self.init(value: mrb_str_new_cstr(context.state, cstr), context: context)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension MRBGeneralValue: BooleanLiteralConvertible {
    init(booleanLiteral value: Bool) {
        guard let context = MRBContext.currentContext() else {
            fatalError("invalid context")
        }

        self.init(value: mrb_bool_value(value ? 1 : 0), context: context)
    }
}
