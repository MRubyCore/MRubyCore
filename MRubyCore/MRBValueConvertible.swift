//
//  MRBValueConvertible.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public protocol MRBValueConvertible {

}

public struct MRBValueUnknown: MRBValueConvertible {}

extension mrb_int: MRBValueConvertible {

}

extension mrb_float: MRBValueConvertible {
    
}

extension String: MRBValueConvertible {

}

extension Bool: MRBValueConvertible {

}
