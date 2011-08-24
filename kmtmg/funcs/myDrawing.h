//
//  myDrawing.h
//  kmtmg
//
//  Created by 武村 健二 on 11/08/01.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#ifndef kmtmg_myDrawing_h
#define kmtmg_myDrawing_h

#include <ApplicationServices/ApplicationServices.h>
#include "myImageData.h"

typedef struct {
    long x, y;
} MYPOINT;

void myDraw_init();
void myDraw_dispatch( MYDRAW *md );
int myDraw_get( MYID *mi, long x, long y );
void myDraw_paint( MYID *mi, unsigned int pen );
int myDraw_dtoi( double dst );
void myDraw_sincos( int num );
void myDraw_xsagon( int num, int sx, int sy, int ex, int ey );
MYPOINT *myDraw_poolPoint();

#endif
