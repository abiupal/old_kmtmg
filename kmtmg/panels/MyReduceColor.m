//
//  MyReduceColor.m
//  kmtmg
//
//  Created by 武村 健二 on 12/01/13.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MyReduceColor.h"
#import "../MyDefines.h"
#import "../menuTool/MyDrawButton.h"
#import "MyPanel.h"

@implementation MyReduceColor

static MyReduceColor *sharedMyReduceColorManager = NULL;

#pragma mark - Singleton

+ (MyReduceColor *)sharedManager
{
	@synchronized(self)
	{
		// MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyReduceColorManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyReduceColorManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyReduceColorManager == Nil )
		{
			sharedMyReduceColorManager = [super allocWithZone:zone];
			return sharedMyReduceColorManager;
		}
	}
	
	return Nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	MyLog( @"copyWithZone:%@ ",[self className] );
	
	return self;
}

- (id)retain
{
	MyLog( @"retain:%@ ",[self className] );
    
	return self;
}

- (NSUInteger)retainCount
{
	return UINT_MAX;
}

- (void)release
{
	MyLog( @"release:%@ ",[self className] );
}

- (id)autorelease
{
	MyLog( @"autorelease:%@ ",[self className] );
	
	return self;
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self)
    {
        [NSBundle loadNibNamed: @"ReduceColorPanel" owner:self];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controlTextDidChange:)
                                                     name: NSControlTextDidChangeNotification object:colNum];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

#pragma mark - Notification

- (void)controlTextDidChange:(NSNotification *)aNotification
{
}

#pragma mark - Open

- (NSInteger)openWithImage:(NSBitmapImageRep *)bitmap
{
    [imgView setImage:[bitmap CGImage] imageProperties:imgProperties];
    
    return [NSApp runModalForWindow:panel];
}

#pragma mark - Action

- (IBAction)doZoom: (id)sender
{
    
}

- (IBAction)switchToolMode: (id)sender
{
    NSInteger newTool;
    
    if ([sender isKindOfClass: [NSSegmentedControl class]])
        newTool = [sender selectedSegment];
    else
        newTool = [sender tag];
    
    switch (newTool)
    {
        case 0:
            [imgView setCurrentToolMode: IKToolModeMove];
            break;
        case 1:
            [imgView setCurrentToolMode: IKToolModeSelect];
            break;
        case 2:
            [imgView setCurrentToolMode: IKToolModeCrop];
            break;
        case 3:
            [imgView setCurrentToolMode: IKToolModeRotate];
            break;
        case 4:
            [imgView setCurrentToolMode: IKToolModeAnnotate];
            break;
    }
}

@end
