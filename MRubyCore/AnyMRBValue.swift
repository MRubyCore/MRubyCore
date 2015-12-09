//
//  AnyMRBValue.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/9.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import Foundation

/// Contains a MRBValue
///
/// Every `MRBValue` is supposed to be `Hashable`.
/// However, due to the lack of supports for
/// generic protocol types, We have to create
/// a container type to use `MRBValue` as `Dictionary.Key`
public struct AnyMRBValue: MRBValue, Hashable {
    private let __value: MRBValue

    init(_ value: MRBValue) {
        __value = value
    }

    public var rawValue: mrb_value {
        return __value.rawValue
    }

    public unowned var context: MRBContext {
        return __value.context
    }
}
