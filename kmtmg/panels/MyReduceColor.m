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
#import "MyNumberInput.h"

#define ZOOM_IN_FACTOR  1.414214
#define ZOOM_OUT_FACTOR 0.7071068

enum { 
    RC_COLNUM = 200, RC_BWNUM, RC_REDUCE,
    RC_SELECTIMG = 301, RC_SELECTED,
    RC_ROUNDROTATE = 501, RC_ZOOM, RC_EDIT
};

static MyReduceColor *sharedMyReduceColorManager = NULL;

@implementation MyReduceColor

@synthesize colNum, bwNum;

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
    }
    
    return self;
}

- (void)dealloc
{    
    [super dealloc];
}

#pragma mark - Open

- (NSInteger)openWithImage:(NSBitmapImageRep *)bitmap
{
    [imgView setImage:[bitmap CGImage] imageProperties:imgProperties];
    
    [imgView setHasHorizontalScroller:YES];
    [imgView setHasVerticalScroller:YES];
    panel.tag = MYPANEL_INIT;
    
    return [NSApp runModalForWindow:panel];
}

#pragma mark - Action

- (IBAction)doZoom: (id)sender
{
    NSInteger zoom;
    CGFloat   zoomFactor;
        
    if ([sender isKindOfClass: [NSSegmentedControl class]])
        zoom = [sender selectedSegment];
    else
        zoom = [sender tag];
    
    switch (zoom)
    {
    case 0:
        zoomFactor = [imgView zoomFactor];
        [imgView setZoomFactor: zoomFactor * ZOOM_OUT_FACTOR];
        break;
    case 1:
        zoomFactor = [imgView zoomFactor];
        [imgView setZoomFactor: zoomFactor * ZOOM_IN_FACTOR];
        break;
    case 2:
        [imgView zoomImageToActualSize: self];
        break;
    case 3:
        [imgView zoomImageToFit: self];
        break;
    }
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
        case 1:
            [imgView setCurrentToolMode: IKToolModeMove];
            break;
        case 0:
            [imgView setCurrentToolMode: IKToolModeSelect];
            break;
        case 3:
            [imgView setCurrentToolMode: IKToolModeCrop];
            break;
        case 2:
            [imgView setCurrentToolMode: IKToolModeRotate];
            break;
        case 4:
            [imgView setCurrentToolMode: IKToolModeAnnotate];
            break;
    }
}

- (IBAction)setRotation: (id)sender
{
    [imgView setRotation:sender];
}

- (IBAction)selectedImage:(id)sender
{
    switch ([sender tag]) {
        case 1: break;
        case 2: break;
        case 3: break;            
        default:
            break;
    }
}

- (IBAction)colorNum:(id)sender
{
    MyNumberInput *mni = [MyNumberInput sharedManager];
    NSButton *btn = nil;
    
    colNum = [mni openWithMin:2 max:255 string:"Reduced Total Color Number"];
    if( colNum == MYPANEL_INIT )
    {
        btn = [panel getObjectFromTag:RC_BWNUM];
        [btn setEnabled:NO];
        btn = [panel getObjectFromTag:RC_REDUCE];
        [btn setEnabled:NO];
    }
    else
    {
        btn = [panel getObjectFromTag:RC_BWNUM];
        [btn setEnabled:YES];
        btn = [panel getObjectFromTag:RC_REDUCE];
        [btn setEnabled:YES];
        btn = (NSButton *)sender;
        [btn setTitle:[NSString stringWithFormat:@"Reduced %d",colNum]];
    }
}

- (IBAction)blackWhiteNum:(id)sender
{
    
}


@end
