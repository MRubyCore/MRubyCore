//
//  misc.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/7.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

internal func MRBFunCall0<T: MRBValueConvertible>(context: MRBContext, object: mrb_value, methodName: String) -> T {
    guard var s = methodName.cStringUsingEncoding(NSUTF8StringEncoding) else {
        fatalError("invalid method name")
    }

    let returnValue = MRBFunCall0(context.state, object, &s)
    guard let result = T(value: returnValue, context: context) else {
        fatalError("unmatched result type")
    }

    return result
}

internal func MRBFunCall0<T: MRBValueConvertible>(context: MRBContext, object: MRBValue, methodName: String) -> T {
    return MRBFunCall0(context, object: object.rawValue, methodName: methodName)
}
