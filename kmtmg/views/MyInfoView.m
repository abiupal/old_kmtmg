//
//  MyInfoView.m
//  kmtmg
//
//  Created by 武村 健二 on 11/12/08.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyInfoView.h"
#import "MyViewData.h"
#import "../panels/MyPaletteImage.h"

@implementation MyInfoView

@synthesize penView, posView;
@synthesize posX, posY, scale;

#pragma mark - search Object from Tag

- (id)getObjectName:(char *)name tag:(int)n
{    
	NSArray *a = [self subviews];
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

#pragma mark - Init

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        bEnabled = NO;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor darkGrayColor] set];
    NSRectFill(dirtyRect);
    
    if( bEnabled == NO ) return;
    
    
}

- (void) setMyViewData:(MyViewData *)data
{
	mvd = data;
}

- (void)setDrawEnabled:(BOOL)b
{
    bEnabled = b;
    [self setHidden:(b ? NO : YES)];

    [self setNeedsDisplay:YES];
}

@end
