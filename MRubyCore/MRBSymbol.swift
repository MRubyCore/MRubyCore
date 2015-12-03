//
//  MRBSymbol.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

public struct MRBSymbol: MRBValueConvertible, StringLiteralConvertible, CustomStringConvertible {
    internal let text: String

    internal init(text: String) {
        self.text = text
    }

    public init(stringLiteral value: String) {
        self.text = value
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.text = value
    }

    public init(unicodeScalarLiteral value: String) {
        self.text = value
    }

    public var description: String {
        return ":\(text)"
    }
}
