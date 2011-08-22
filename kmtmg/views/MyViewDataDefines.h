//
//  MyViewDataDefines.h
//  kmtmg
//
//  Created by 武村 健二 on 11/08/19.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#ifndef kmtmg_MyViewDataDefines_h
#define kmtmg_MyViewDataDefines_h

enum { MVD_ORIGIN_LU =  0, MVD_ORIGIN_LD, MVD_ORIGIN_RU, MVD_ORIGIN_RD, MVD_ORIGIN_MAX };
enum { MVD_GRID_NODISP = 0, MVD_GRID_ALL, MVD_GRID_BOLD, MVD_GRID_MAX };
enum { MVD_NOSPACE_DEFAULT = 100 };
enum { MVD_EFFECTIGNORE_NONE = 0, MVD_EFFECT_SRC = 1, MVD_EFFECT_DST, MVD_EFFECT_MASK, MVD_IGNORE_SRC, MVD_IGNORE_DST = 8, MVD_IGNORE_MASK = 12 };

#endif
