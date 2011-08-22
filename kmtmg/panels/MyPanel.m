//
//  MyPanel.m
//  kmtmg
//
//  Created by 武村 健二 on 11/08/04.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyPanel.h"
#import "../MyDefines.h"

@implementation MyPanel

- (id)init
{
    self = [super init];
    if (self) {
        tag = -1;
    }
    
    return self;
}

- (void)awakeFromNib
{	
	MyLog( @"");
    tag = -1;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector: @selector(windowWillClose:)
                                                 name: @"NSWindowWillCloseNotification"
                                               object: self];
    
    
	[self setAlphaValue:0.9];
}


- (void)center
{
    NSRect frame = [self frame];
    NSRect screen = [[self screen] visibleFrame];
    frame.origin.x = (screen.size.width - frame.size.width) / 2;
    frame.origin.y = (screen.size.height - frame.size.height) / 2;
    [self setFrameOrigin:frame.origin];
    
    MyLog( @"");

}

- (void)windowWillClose:(NSNotification *)aNotification
{
	[NSApp stopModalWithCode:tag];
	
	MyLog( @"" );
}

- (void)setTag:(NSInteger)n
{
    tag = n;
    [self close];
}


@end
