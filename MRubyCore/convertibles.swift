//
//  convertibles.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

extension mrb_int: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBRangeElementValue(integerLiteral: self)
    }
}

extension mrb_float: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBGeneralValue(floatLiteral: self)
    }
}

extension String: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBRangeElementValue(stringLiteral: self)
    }
}

extension Bool: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return MRBGeneralValue(booleanLiteral: self)
    }
}
