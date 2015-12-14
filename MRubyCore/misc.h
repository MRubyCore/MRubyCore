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

static enum mrb_vtype MRBGetType(mrb_value value) {
    return mrb_type(value);
}

static mrb_int MRBReadFixnum(mrb_value value) {
    return mrb_fixnum(value);
}

static const char * MRBReadSymbol(mrb_state *state, mrb_value value) {
    mrb_sym sym = mrb_symbol(value);
    return mrb_sym2name(state, sym);
}

static mrb_float MRBReadFloat(mrb_value value) {
    return mrb_float(value);
}

static struct RProc * MRBReadProc(mrb_value value) {
    return mrb_proc_ptr(value);
}

static struct RRange * MRBReadRange(mrb_value value) {
    return mrb_range_ptr(value);
}

static uint32_t MRBGetNLocals(struct RProc *proc) {
    return proc->body.irep->nlocals;
}

#endif /* misc_h */
