//
//  subscripts.swift
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/15.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

import MRuby

public final class Constants {
    let mrbValue: MRBValue

    init(of mrbValue: MRBValue) {
        self.mrbValue = mrbValue
    }

    public subscript(name: String) -> MRBValue? {
        switch mrbValue.valueType {
        case .Class: break
        case .Module: break
        case .IClass: break
        case .SClass: break
        default:
            return nil
        }

        let name = name.toSym(inContext: mrbValue.context)

        guard mrb_const_defined(mrbValue.context.state, mrbValue.rawValue, name) != 0 else {
            return nil
        }

        return mrb_const_get(mrbValue.context.state, mrbValue.rawValue, name) ⨝ mrbValue.context
    }
}

public final class LocalVariables {
    let mrbValue: MRBValue

    init(of mrbValue: MRBValue) {
        self.mrbValue = mrbValue
    }

    public subscript(name: String) -> MRBValue? {
        return try? mrbValue.evaluateScript(name)
    }
}
