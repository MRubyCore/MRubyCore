//
//  MRBValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public struct MRBValue: CustomDebugStringConvertible {
    internal let rawValue: mrb_value
    internal unowned let context: MRBContext

    internal init(value: mrb_value, context: MRBContext) {
        self.rawValue = value
        self.context = context
    }

    public var valueType: MRBValueType {
        return MRBValueType(type: MRBGetType(rawValue), value: rawValue)
    }

    public var value: MRBValueConvertible {
        return valueType.bridgeType.init(value: self)
    }

    public var debugDescription: String {
        return "{MRBValue <\(valueType)> \(value) }"
    }
}
