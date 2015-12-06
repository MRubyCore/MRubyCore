//
//  MRBValueType.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public enum MRBValueType: String {
    case Nil
    case False
    case Free
    case True
    case FixNum
    case Symbol
    case Undef
    case Float
    case CPtr
    case Object
    case Class
    case Module
    case IClass
    case SClass
    case Proc
    case Array
    case Hash
    case String
    case Range
    case Exception
    case File
    case Env
    case Data
    case Fiber
    case Unknown

    internal init(type: mrb_vtype, value: mrb_value) {
        switch type {
        case MRB_TT_FALSE:
            if MRB_Fixnum(value) != 0 {
                self = .False
            }
            else {
                self = .Nil
            }
        case MRB_TT_FREE: self = .Free
        case MRB_TT_TRUE: self = .True
        case MRB_TT_FIXNUM: self = .FixNum
        case MRB_TT_SYMBOL: self = .Symbol
        case MRB_TT_UNDEF: self = .Undef
        case MRB_TT_FLOAT: self = .Float
        case MRB_TT_CPTR: self = .CPtr
        case MRB_TT_OBJECT: self = .Object
        case MRB_TT_CLASS: self = .Class
        case MRB_TT_MODULE: self = .Module
        case MRB_TT_ICLASS: self = .IClass
        case MRB_TT_SCLASS: self = .SClass
        case MRB_TT_PROC: self = .Proc
        case MRB_TT_ARRAY: self = .Array
        case MRB_TT_HASH: self = .Hash
        case MRB_TT_STRING: self = .String
        case MRB_TT_RANGE: self = .Range
        case MRB_TT_EXCEPTION: self = .Exception
        case MRB_TT_FILE: self = .File
        case MRB_TT_ENV: self = .Env
        case MRB_TT_DATA: self = .Data
        case MRB_TT_FIBER: self = .Fiber
        default: self = .Unknown
        }
    }

    internal var bridgeType: MRBValueConvertible.Type {
        switch self {
        case .Nil: return MRBNil.self
        case .False: return Bool.self
        case .Free: return MRBPlaceHolder.self
        case .True: return Bool.self
        case .FixNum: return mrb_int.self
        case .Symbol: return MRBSymbol.self
        case .Undef: return MRBPlaceHolder.self
        case .Float: return mrb_float.self
        case .CPtr: return MRBPlaceHolder.self
        case .Object: return MRBPlaceHolder.self
        case .Class: return MRBPlaceHolder.self
        case .Module: return MRBPlaceHolder.self
        case .IClass: return MRBPlaceHolder.self
        case .SClass: return MRBPlaceHolder.self
        case .Proc: return MRBPlaceHolder.self
        case .Array: return MRBPlaceHolder.self
        case .Hash: return MRBPlaceHolder.self
        case .String: return Swift.String.self
        case .Range: return MRBPlaceHolder.self
        case .Exception: return MRBPlaceHolder.self
        case .File: return MRBPlaceHolder.self
        case .Env: return MRBPlaceHolder.self
        case .Data: return MRBPlaceHolder.self
        case .Fiber: return MRBPlaceHolder.self
        case .Unknown: return MRBPlaceHolder.self
        }
    }
}
