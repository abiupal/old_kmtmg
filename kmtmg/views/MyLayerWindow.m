//
//  MyLayerWindow.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/22.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyLayerWindow.h"


@implementation MyLayerWindow

@synthesize view;
@synthesize split;
@synthesize addy;
@synthesize type;

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag 
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil)
    {
        [self setAcceptsMouseMovedEvents:NO];
        [self setIgnoresMouseEvents:YES];
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        view = nil;
    }
    return self;
}

- (void)windowSizeChanged:(NSNotification *)notification
{
    if( view == nil ) return;

    NSRect vf = [view frame];
    vf.origin = [[view window] convertBaseToScreen:vf.origin];
    vf.origin.y += addy ;
    
    SInt32 minor = 0;
    Gestalt( gestaltSystemVersionMinor, &minor );
    if( minor == 6 )
        vf.origin.y += [[view horizontalScroller] frame].size.height;
    
    vf.origin.y += [split dividerThickness];
    
    // NSLog(@"LayerWindow:%@", NSStringFromRect(vf));
    
    [self setFrame:vf display:YES];
}

@end






















