//
//  MyLayerWindow.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/22.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

enum { LAYER_CURSOR = 1, LAYER_RUBBER, LAYER_ADJUST_SIZE = 32, LAYER_MAX };

@interface MyLayerWindow : NSWindow
{
    NSScrollView *view;
    NSSplitView *split;
    CGFloat addy;
    int type;
}

- (void)windowSizeChanged:(NSNotification *)notification;

@property (assign) NSScrollView *view;
@property (assign) NSSplitView *split;
@property CGFloat addy;
@property int type;

@end
