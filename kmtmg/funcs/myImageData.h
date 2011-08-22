//
//  myImageData.h
//  kmtmg
//
//  Created by 武村 健二 on 11/08/02.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#ifndef kmtmg_myImageData_h
#define kmtmg_myImageData_h

typedef enum {
    kImage_Unknown = 0,
	kImage_Source		= 1000,
    kImage_Destinate,
    kImage_Temp
} MyIdType;

typedef struct {
    unsigned char *d;
    unsigned int w, h;
    unsigned int sx, sy, ex, ey;
    char *allow, effectIgnoreType;
    OSType MyIdType;
} MYID;

typedef struct {
    MYID src, dst;
    char *cmd;
    unsigned int pen;
} MYDRAW;


#endif
