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
    private let rawValue: mrb_value
    private unowned let context: MRBContext

    internal init(value: mrb_value, context: MRBContext) {
        self.rawValue = value
        self.context = context
    }

    public var valueType: MRBValueType {
        return MRBValueType(type: MRB_Type(rawValue))
    }

    public var value: MRBValueConvertible {
        switch valueType {
        case .False:
            return false

        case .Free:
            return MRBValueUnknown()

        case .True:
            return true

        case .FixNum:
            return MRB_Fixnum(rawValue)

        case .Symbol:
            let cstr = MRB_Symname(context.state, rawValue)
            return MRBSymbol(text: String(CString: cstr, encoding: NSUTF8StringEncoding)!)

        case .Undef:
            return MRBValueUnknown()

        case .Float:
            return MRB_Float(rawValue)

        case .CPtr:
            return MRBValueUnknown()

        case .Object:
            return MRBValueUnknown()

        case .Class:
            return MRBValueUnknown()

        case .Module:
            return MRBValueUnknown()

        case .IClass:
            return MRBValueUnknown()

        case .SClass:
            return MRBValueUnknown()

        case .Proc:
            return MRBValueUnknown()

        case .Array:
            return MRBValueUnknown()

        case .Hash:
            return MRBValueUnknown()

        case .String:
            let cstr = mrb_string_value_ptr(context.state, rawValue)
            return String(CString: cstr, encoding: NSUTF8StringEncoding)!

        case .Range:
            return MRBValueUnknown()

        case .Exception:
            return MRBValueUnknown()

        case .File:
            return MRBValueUnknown()

        case .Env:
            return MRBValueUnknown()

        case .Data:
            return MRBValueUnknown()

        case .Fiber:
            return MRBValueUnknown()

        case .Unknown:
            return MRBValueUnknown()
        }
    }

    public var debugDescription: String {
        return "{MRBValue <\(valueType)> \(value) }"
    }
}
