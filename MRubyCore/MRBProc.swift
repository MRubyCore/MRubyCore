//
//  MRBProc.swift
//  MRubyCore
//
//  Created by Rox Dorentus on 2015-12-7.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

public struct MRBProc: MRBValueConvertible, CustomDebugStringConvertible {
    private let value: MRBValue

    public init!(value: MRBValue) {
        guard value.valueType == .Proc else { return nil }

        self.value = value
    }

    public var debugDescription: String {
        return value.inspection
    }
}
