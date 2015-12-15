//
//  MRBValueConvertible.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/15.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import MRuby

public protocol MRBValueConvertible {
    func inContext(context: MRBContext) -> MRBValue
}

public protocol MRBPartialConvertible: MRBValueConvertible {
    var partialValue: MRBPartialValue { get }
}

public extension MRBPartialConvertible {
    public func inContext(context: MRBContext) -> MRBValue {
        return partialValue.inContext(context)
    }
}

// MARK: extensions

extension mrb_int: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        return MRBPartialValue.Integer(self)
    }
}

extension mrb_float: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        return MRBPartialValue.Float(self)
    }
}

extension String: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        return MRBPartialValue.String(self)
    }
}

extension Bool: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        return MRBPartialValue.Bool(self)
    }
}

// MARK: danger zone

extension Int: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        return MRBPartialValue.Integer(mrb_int(self))
    }
}

extension Range: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        guard Element.self is MRBValueConvertible.Type else {
            fatalError("unsupported element type \(Element.self)")
        }

        return MRBPartialValue.Range(startIndex as! MRBValueConvertible, endIndex as! MRBValueConvertible)
    }
}

extension Array: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        guard Element.self is MRBValueConvertible.Type else {
            fatalError("unsupported element type \(Element.self)")
        }

        let values = map {
            ($0 as! MRBValueConvertible)
        }

        return MRBPartialValue.Array(values)
    }
}

extension Dictionary: MRBPartialConvertible {
    public var partialValue: MRBPartialValue {
        guard Key.self is MRBValueConvertible.Type else {
            fatalError("unsupported key type \(Key.self)")
        }

        guard Value.self is MRBValueConvertible.Type else {
            fatalError("unsupported value type \(Value.self)")
        }

        let kv = map { (AnyMRBValue($0 as! MRBValueConvertible), $1 as! MRBValueConvertible) }

        let dict: [AnyMRBValue: MRBValueConvertible] = kv.reduce([:]) { m, kv in
            var m = m
            m[kv.0] = kv.1
            return m
        }

        return MRBPartialValue.Dictionary(dict)
    }
}
