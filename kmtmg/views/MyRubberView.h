//
//  MyRubberView.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/25.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyLayerView.h"

enum { RUBBER_NONE = 0, RUBBER_LINE, RUBBER_CIRCLE, RUBBER_RECT = 0x100, RUBBER_MAX = 0x110 };

@interface MyRubberView : MyCursorView
{
    
@private
    NSRect rect;
    NSPoint end;
    NSInteger type;
    NSFont *iFont;
    NSColor *iColor;
}

- (void)setRubberType:(NSInteger)newType;
- (void)setStartPosition:(NSPoint)pos;
- (void)setEndPosition:(NSPoint)pos;
- (void)setPosition:(NSPoint)pos;
- (void)cancel;
- (NSPoint)startPoint;

@end