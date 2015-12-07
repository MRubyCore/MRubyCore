//
//  MRBSymbol.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

public struct MRBSymbol: MRBValueConvertible, StringLiteralConvertible, CustomDebugStringConvertible {
    internal let symbol: String

    internal init(symbol: String) {
        self.symbol = symbol
    }

    public init(stringLiteral value: String) {
        self.symbol = value
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.symbol = value
    }

    public init(unicodeScalarLiteral value: String) {
        self.symbol = value
    }

    public init!(value: MRBValue) {
        guard value.valueType == .Symbol else { return nil }

        let cstr = MRBReadSymbol(value.context.state, value.rawValue)
        self.init(symbol: String(CString: cstr, encoding: NSUTF8StringEncoding)!)
    }

    public var debugDescription: String {
        return ":\(symbol)"
    }
}
