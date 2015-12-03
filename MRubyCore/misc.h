//
//  misc.h
//  MRubyCore
//
//  Created by Zhang Yi on 15/12/4.
//  Copyright © 2015年 rubyist.today. All rights reserved.
//

#ifndef misc_h
#define misc_h

@import MRuby;
@import Foundation;

static enum mrb_vtype MRB_Type(mrb_value value) {
    return mrb_type(value);
}

static mrb_int MRB_Fixnum(mrb_value value) {
    return mrb_fixnum(value);
}

static const char * MRB_Symname(mrb_state *state, mrb_value value) {
    mrb_sym sym = mrb_symbol(value);
    return mrb_sym2name(state, sym);
}

static mrb_float MRB_Float(mrb_value value) {
    return mrb_float(value);
}

#endif /* misc_h */
