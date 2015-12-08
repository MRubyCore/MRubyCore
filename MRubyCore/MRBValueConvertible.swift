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
    var mrbValue: MRBValue { get }
}

extension mrb_int: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBValue(integerLiteral: self)
    }
}

extension mrb_float: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBValue(floatLiteral: self)
    }
}

extension String: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBValue(stringLiteral: self)
    }
}

extension Bool: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBValue(booleanLiteral: self)
    }
}
