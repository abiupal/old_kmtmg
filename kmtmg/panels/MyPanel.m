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

@synthesize tag;

- (id)init
{
    self = [super init];
    if (self) {
        tag = MYPANEL_INIT;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib
{	
	MyLog( @"");
    tag = MYPANEL_INIT;
	
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
}

- (void)windowWillClose:(NSNotification *)aNotification
{
	[NSApp stopModalWithCode:tag];
}

- (void)setTag:(NSInteger)n
{
    tag = n;
    [self close];
}

#pragma mark - search Object from Tag

- (id)getObjectFromTag:(int)n
{
    
	NSArray *a = [[self contentView] subviews];
	id obj;
	int i;
	for( i = 0; i < [a count]; ++i )
	{
        obj = [a objectAtIndex:i];
        if( [obj tag] == n ) return obj;
	}
	
	return Nil;
}

- (id)getObjectName:(char *)name tag:(int)n
{
	NSArray *a = [[self contentView] subviews];
	NSString *s;
	id obj;
	int i;
	for( i = 0; i < [a count]; ++i )
	{
		s = [[a objectAtIndex:i] className];
		if( !strncmp( [s UTF8String], name, strlen(name) ) )
		{
			obj = [a objectAtIndex:i];
			if( [obj tag] == n ) return obj;
		}
	}
	
	return Nil;
}

@end
