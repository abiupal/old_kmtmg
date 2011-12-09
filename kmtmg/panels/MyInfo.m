//
//  MyInfo.m
//  kmtmg
//
//  Created by 武村 健二 on 11/03/22.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//
#import "MyInfo.h"
#import "MyPaletteImage.h"
#import "../MyDefines.h"
#import "../menuTool/ToolBarController.h"
#import "../views/MyInfoView.h"

static MyInfo *sharedMyInfoManager = NULL;

@implementation MyInfo
@synthesize scroll;
@synthesize currentWindow;
@synthesize currentButton;
@synthesize currentInfoView;
@synthesize dotSize;
@synthesize ratio;
@synthesize currentFunction;
@synthesize prePosition;

static char *funcName[2] = { "M_INFO_OPEN", "M_INFO_CLOSE"};


#pragma mark - search Object from Tag

- (id)getObjectName:(char *)name tag:(int)n
{
    if( scroll == nil ) return nil;
    
	NSArray *a = [scroll subviews];
    NSArray *a2 = [[a objectAtIndex:0] subviews];
    a = [[a2 objectAtIndex:0] subviews];
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

#pragma mark - Singleton

+ (MyInfo *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyInfoManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyInfoManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyInfoManager == Nil )
		{
			sharedMyInfoManager = [super allocWithZone:zone];
			return sharedMyInfoManager;
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
    if (self) {
        // Initialization code here.
        alphaDisable = 0.9f;
        prePosition = NSMakePoint(-999.99, -999.99);
        currentWindow = nil;
        currentButton = nil;
        currentInfoView = nil;
        prePosColor = -1;
        scrollerFont = [[NSFont fontWithName:@"Courier" size:12] retain];
        rubberFont = [[NSFont boldSystemFontOfSize:10] retain];
        // [[NSFont fontWithName:@"Courier" size:14] retain];
        dotSize = NSMakeSize(1, 1);
        ratio = NSMakePoint(1, 1);
        funcId = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [scrollerFont release];
    [rubberFont release];
    
    [super dealloc];
}

static char *defaultFunc = "M_TOOLBAR_PRESS";

- (void)awakeFromNib
{
    [information setFloatingPanel:YES];
    [information setBecomesKeyOnlyIfNeeded:NO];
    [information setHidesOnDeactivate:YES];
    [information setReleasedWhenClosed:NO];
    [information setAlphaValue:alphaDisable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayProfileChanged:)
                                                 name:NSApplicationDidChangeScreenParametersNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willClosePalette:)
                                                 name:NSWindowWillCloseNotification
                                               object:information];
    
    [currentFunction setFuncName:defaultFunc menuName:@""];

}

- (BOOL)acceptsFirstResponder {
    return NO;
}

- (BOOL)displaysWhenScreenProfileChanges
{
    return YES;
}

#pragma mark - Font

- (NSFont *)scrollerFont
{
    return scrollerFont;
}

- (NSFont *)rubberFont
{
    return rubberFont;
}

#pragma mark - notification

- (void)willClosePalette:(NSNotification*)notification
{    
    funcId = 1;
    [self drawIcon];
}

- (void)displayProfileChanged:(NSNotification*)notification
{
    NSScreen *screen = [information screen];
    if( screen == nil )
        screen = [NSScreen mainScreen];
    
    NSRect main = [screen visibleFrame];
    NSRect mine = [information frame];
    
    if( NSContainsRect( mine, main ) == NO )
    {
        mine.origin.x = 60;
        mine.origin.y = 200;
        [information setFrameTopLeftPoint:mine.origin];
    }
}

#pragma mark - func

- (void)open
{
    if( currentWindow != nil )
    {
        [information orderFront:nil];
        funcId = 0;
        [self drawIcon];
    }
}

- (void)close
{
    if( currentWindow != nil )
    {
        [information performClose:nil];
    }
}

- (void)drawIcon
{
    if( currentButton != nil )
    {
        if( funcId )
        {
            if( currentInfoView != nil )
                [currentInfoView setDrawEnabled:YES];
            [currentButton setFuncName:funcName[funcId] menuName:@"Info"];
        }
        else
        {
            if( currentInfoView != nil )
                [currentInfoView setDrawEnabled:NO];
            [currentButton setFuncName:funcName[funcId] menuName:@""];
        }
        [currentButton display];
    }
}

- (void)textPosition:(NSPoint)pos
{
    if( NSEqualPoints( prePosition, pos ) ) return;
    
    NSString *str = [NSString stringWithFormat:@"%d",(int)pos.x];
    [posX setStringValue:str];
    if( currentInfoView != nil )
        [currentInfoView.posX setStringValue:str];
    
    str = [NSString stringWithFormat:@"%d",(int)pos.y];
    [posY setStringValue:str];
    if( currentInfoView != nil )
        [currentInfoView.posY setStringValue:str];
    
    prePosition = pos;
}

- (void)penColor:(NSColor *)color palNo:(NSInteger)no
{
    [penView.palImage drawColorAndIndex:color index:no];
    [penView setNeedsDisplay:YES];
    
    if( currentInfoView != nil )
    {
        [currentInfoView.penView.palImage drawColorAndIndex:color index:no];
        [currentInfoView.penView setNeedsDisplay:YES];
    }

}

- (void)posColor:(NSColor *)color palNo:(NSInteger)no
{
    if( prePosColor != no )
    {
        prePosColor = no;
        [posView.palImage drawColorAndIndex:color index:no];
        [posView setNeedsDisplay:YES];
        if( currentInfoView != nil )
        {
            [currentInfoView.posView.palImage drawColorAndIndex:color index:no];
            [currentInfoView.posView setNeedsDisplay:YES];
        }
    }
}

- (void)updateInfo
{
    // 11 DotX
	id obj = [self getObjectName:"NSTextField" tag:11];
	[obj setStringValue:[NSString stringWithFormat:@"%d",(int)dotSize.width]];
	obj = [self getObjectName:"NSTextField" tag:12];
	[obj setStringValue:[NSString stringWithFormat:@"%d",(int)dotSize.height]];
	// 21 RatioX
    obj = [self getObjectName:"NSTextField" tag:21];
	[obj setStringValue:[NSString stringWithFormat:@"%d",(int)ratio.x]];
	obj = [self getObjectName:"NSTextField" tag:22];
	[obj setStringValue:[NSString stringWithFormat:@"%d",(int)ratio.y]];
    [currentWindow update];
    
    // 31 scale
    obj = [self getObjectName:"NSTextField" tag:31];
    NSString *str = nil;
    if( 0.0f < scaleValue && scaleValue < 1.0f )
        str = [NSString stringWithFormat:@"1/%d",(int)(1.0f / scaleValue)];
	else
        str = [NSString stringWithFormat:@"%d",(int)scaleValue];
    [obj setStringValue:str];
    if( currentInfoView != nil )
        [currentInfoView.scale setStringValue:str];
}

- (void)setImageFraction:(CGFloat)f
{
    if( f < 0.0f ) f = 0.0f;
    if( 1.0f < f ) f = 1.0f;
    
    f *= 100.0f;
    int n = (int)f;
    [fractionSketch setIntValue:n];
    
    if( currentWindow != nil )
    {
        MyWindowController *mwc = [currentWindow windowController];
        if( 0 < [mwc.mvd.topImages count] )
            [fractionSketch setEnabled:YES];
        else
            [fractionSketch setEnabled:NO];
    }
    
    [self updateInfo];
}

- (CGFloat)imageFraction
{
    CGFloat f = [fractionSketch floatValue];
    f /= 100.0f;
    
    return f;
}

- (void)setDrawFraction:(CGFloat)f
{
    if( f < 0.0f ) f = 0.0f;
    if( 1.0f < f ) f = 1.0f;
    
    f *= 100.0f;
    int n = (int)f;
    [fractionDrawing setIntValue:n];
    
    [self updateInfo];
}
- (CGFloat)drawFraction
{
    CGFloat f = [fractionDrawing floatValue];
    f /= 100.0f;
    
    return f;
}

- (void)setScale:(CGFloat)n
{
    if( !n ) return;
    
    scaleValue = n;
    [self updateInfo];
}

- (void)updateViewRatio
{
    MyWindowController *mwc = [currentWindow windowController];
    mwc.mvd.ratio = ratio;
    [mwc setCenterFromInfoAutoCenter:NO];
}

- (void)updateViewDotSize
{
    MyWindowController *mwc = [currentWindow windowController];
    mwc.mvd.penDot = dotSize;
}

- (void)setFunction:(char *)cmd
{
    [currentFunction setFuncName:cmd menuName:Nil];
    [NSThread sleepForTimeInterval:0.5];
}

#pragma mark - Action

- (IBAction)changeFraction:(id)sender
{
    if( currentWindow == nil ) return;
    
    MyWindowController *mwc = [currentWindow windowController];
    mwc.mvd.backgroundFraction = [self imageFraction];
    mwc.mvd.drawFraction = [self drawFraction];
    [mwc.oView checkUpdateData];
}

- (IBAction)changeDotX:(id)sender
{
    CGFloat n = [sender doubleValue];
    if( n < 1.0 ) n = 1.0;
    if( 255 < n ) n = 255;
    
    dotSize.width = n;
    [self updateViewDotSize];
}

- (IBAction)changeDotY:(id)sender
{
    CGFloat n = [sender doubleValue];
    if( n < 1.0 ) n = 1.0;
    if( 255 < n ) n = 255;
    
    dotSize.height = n;
    [self updateViewDotSize];
}

- (IBAction)changeRatioX:(id)sender
{
    CGFloat n = [sender doubleValue];
    if( n < 1.0 ) n = 1.0;
    if( 255 < n ) n = 255;
    
    ratio.x = n;
    [self updateViewRatio];
}
- (IBAction)changeRatioY:(id)sender
{
    CGFloat n = [sender doubleValue];
    if( n < 1.0 ) n = 1.0;
    if( 255 < n ) n = 255;
    
    ratio.y = n;
    [self updateViewRatio];
}
- (IBAction)pressFunction:(id)sender
{
    if( currentWindow == nil ) return;
    
    [[ToolBarController sharedManager] openToolBar];
}

@end
