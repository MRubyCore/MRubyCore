//
//  literals.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import MRuby

extension MRBPartialValue: IntegerLiteralConvertible {
    public init(integerLiteral value: mrb_int) {
        self = .Integer(value)
    }
}

extension MRBPartialValue: FloatLiteralConvertible {
    public init(floatLiteral value: mrb_float) {
        self = .Float(value)
    }
}

extension MRBPartialValue: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self = .Nil()
    }
}

extension MRBPartialValue: StringLiteralConvertible, UnicodeScalarLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible {
    public init(stringLiteral value: Swift.String) {
        self = .String(value)
    }

    public init(unicodeScalarLiteral value: Swift.String) {
        self.init(stringLiteral: value)
    }

    public init(extendedGraphemeClusterLiteral value: Swift.String) {
        self.init(stringLiteral: value)
    }
}

extension MRBPartialValue: BooleanLiteralConvertible {
    public init(booleanLiteral value: Swift.Bool) {
        self = .Bool(value)
    }
}

extension MRBPartialValue: ArrayLiteralConvertible {
    public init(arrayLiteral elements: MRBValueConvertible...) {
        self = .Array(elements)
    }
}

extension MRBPartialValue: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (MRBValueConvertible, MRBValueConvertible)...) {
        self = .Dictionary(elements.reduce([:]) { m, kv in
            var m = m
            m[AnyMRBValue(kv.0)] = kv.1
            return m
        })
    }
}
