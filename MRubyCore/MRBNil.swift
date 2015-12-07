//
//  MRBNil.swift
//  MRubyCore
//
//  Created by Rox Dorentus on 2015-12-6.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

public struct MRBNil: MRBValueConvertible, CustomDebugStringConvertible {
    public init!(value: MRBValue) {
        guard value.valueType == .Nil else { return nil }
    }

    public var debugDescription: String {
        return "nil"
    }
}