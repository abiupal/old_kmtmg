//
//  MyInfoView.h
//  kmtmg
//
//  Created by 武村 健二 on 11/12/08.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyViewData;
@class MyPaletteView;

@interface MyInfoView : NSView
{
    IBOutlet MyPaletteView *penView, *posView;
    IBOutlet NSTextField *posX, *posY, *scale;
    
    MyViewData *mvd;
    BOOL bEnabled; 
}

@property (assign) MyPaletteView *penView, *posView;
@property (assign) NSTextField *posX, *posY, *scale;

- (void)setMyViewData:(MyViewData *)data;
- (void)setDrawEnabled:(BOOL)b;

@end
