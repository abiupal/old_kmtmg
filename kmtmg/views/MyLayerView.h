//
//  MyLayerView.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/23.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyViewData;

@interface MyCursorView : NSView
{
    MyViewData *mvd;
    NSPoint scrollStart;

    NSPoint cursorPos;
    BOOL flag;
}

- (NSPoint)viewPointFromImagePoint:(NSPoint)pos;
- (void)setPosition:(NSPoint)pos;

@property(assign) MyViewData *mvd;
@property NSPoint scrollStart;

@end

/*
@interface MyCAView : NSView
{
}

- (void)setInitLayer;

@end
*/