//
//  MyDefines.h
//  kmtmg
//
//  Created by 武村 健二 on 11/03/08.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//
#import <Foundation/Foundation.h>

#define VKEY_ESC 0x35
#define VKEY_SPACE 0x31
#define VKEY_RETURN 0x24
#define VKEY_ENTER 0x4c
#define VKEY_TAB 0x30
#define VKEY_DEL 0x33
#define VKEY_UP 0x7e
#define VKEY_DOWN 0x7d
#define VKEY_LEFT 0x7b
#define VKEY_RIGHT 0x7c
#define VKEY_PLUS 0x29
#define VKEY_MINUS 0x1b
#define VKEY_ZERO 0x1d

#define VIEW_MIN_W 465
#define VIEW_MIN_H 333
#define WINDOW_MIN_W 525
#define WINDOW_MIN_H 420

#define SPLITVIEW_FIXED_WIDTH 160

#ifdef DEBUG
#define MyLog(fmt, ...)  NSLog((@"<%s/%d> " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__ )
#else
#define MyLog(...)
#endif

#define MY_CMP( A, B ) ( !strncmp( A, B, strlen(B)) ? 1 : 0 )


typedef enum {
    PositionSelectedType_INVALID = 0,
    PositionSelectedType_LD2RU,
    PositionSelectedType_RU2LD,
    PositionSelectedType_LU2RD,
    PositionSelectedType_RD2LU,
    PositionSelectedType_MAX
} POSITION_SELECTED_TYPE;

static unsigned char bitMask[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };

