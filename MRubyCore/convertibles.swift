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

// MARK - danger zone

extension Int: MRBValueConvertible {
    public var mrbValue: MRBValue {
        return mrb_int(self).mrbValue
    }
}

extension Range: MRBValueConvertible {
    public var mrbValue: MRBValue {
        guard Element.self is MRBValueConvertible.Type else {
            fatalError("unsupported element type \(Element.self)")
        }

        guard let start = (startIndex as! MRBValueConvertible).mrbValue as? MRBRangeElementValue,
                    end = (endIndex as! MRBValueConvertible).mrbValue as? MRBRangeElementValue else {
            fatalError("\(Element.self) cannot be converted to MRBRangeElementValue")
        }

        assert(start.context == end.context)

        let context = start.context
        let range = mrb_range_new(context.state, start.rawValue, end.rawValue, 1)

        return range ⨝ context
    }
}

extension Array: MRBValueConvertible {
    public var mrbValue: MRBValue {
        guard Element.self is MRBValueConvertible.Type else {
            fatalError("unsupported element type \(Element.self)")
        }

        let values = map {
            ($0 as! MRBValueConvertible).mrbValue
        }

        guard let context = values.first?.context ?? MRBContext.currentContext() else {
            fatalError("invalid MRBContext")
        }

        let array: mrb_value

        if values.count == 0 {
            array = mrb_ary_new(context.state)
        }
        else {
            var rawValues = values.map { $0.rawValue }
            array = mrb_ary_new_from_values(context.state, mrb_int(values.count), &rawValues)
        }

        return array ⨝ context
    }
}
