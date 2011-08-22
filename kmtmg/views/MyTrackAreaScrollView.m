//
//  MyTrackAreaScrollView.m
//  kmtmg
//
//  Created by 武村 健二 on 11/03/11.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyTrackAreaScrollView.h"


@implementation MyTrackAreaScrollView

@synthesize keyWindow;

- (id)init
{
    self = [super init];
    if (self) {
        trackingArea = nil;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
- (NSRect)trackingAreaFromFrame
{
    NSRect area = self.frame;
    area.origin.y += 1.0f;
    area.size.width -= 1.0f;
    area.size.height -= 1.0f;

    return area;
}
- (void)awakeFromNib
{
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self trackingAreaFromFrame]
                                                options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow )
                                                  owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    keyWindow = nil;
}

- (void)updateTrackingAreas
{
    [self removeTrackingArea:trackingArea];
    [trackingArea release];
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self trackingAreaFromFrame]
                                                options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow)
                                                  owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [[self window] setAlphaValue:1.0f];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [[self window] setAlphaValue:0.8f];
    if( keyWindow != nil )
    {
        [keyWindow makeKeyWindow];
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

@end
