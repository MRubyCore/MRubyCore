//
//  MRBPlaceholder.swift
//  MRubyCore
//
//  Created by Rox Dorentus on 2015-12-6.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation
import MRuby

public struct MRBPlaceHolder: MRBValueConvertible {
    private let value: mrb_value

    public init!(value: MRBValue) {
        self.value = value.rawValue
    }
}
