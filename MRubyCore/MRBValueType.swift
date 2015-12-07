//
//  MRBValue.selfType.swift
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
            if MRBReadFixnum(value) != 0 {
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
        case .Free: return MRBValue.self
        case .True: return Bool.self
        case .FixNum: return mrb_int.self
        case .Symbol: return MRBSymbol.self
        case .Undef: return MRBValue.self
        case .Float: return mrb_float.self
        case .CPtr: return MRBValue.self
        case .Object: return MRBValue.self
        case .Class: return MRBValue.self
        case .Module: return MRBValue.self
        case .IClass: return MRBValue.self
        case .SClass: return MRBValue.self
        case .Proc: return MRBProc.self
        case .Array: return MRBValue.self
        case .Hash: return MRBValue.self
        case .String: return Swift.String.self
        case .Range: return MRBValue.self
        case .Exception: return MRBValue.self
        case .File: return MRBValue.self
        case .Env: return MRBValue.self
        case .Data: return MRBValue.self
        case .Fiber: return MRBValue.self
        case .Unknown: return MRBValue.self
        }
    }
}
