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
    var mrbValue: MRBValue { get }
}
