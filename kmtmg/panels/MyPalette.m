//
//  MyPalette.m
//  kmtmg
//
//  Created by 武村 健二 on 11/03/10.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyPalette.h"
#import "MyPaletteImage.h"
#import "MyColorData.h"
#import "../MyDefines.h"

static MyPalette     *sharedMyPaletteManager = NULL;

static char *funcName[2] = { "M_PALETTE_OPEN", "M_PALETTE_CLOSE"};

@implementation MyPalette
@synthesize scroll;
@synthesize currentWindow;
@synthesize currentButton;

#pragma mark - Singleton

+ (MyPalette *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyPaletteManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyPaletteManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyPaletteManager == Nil )
		{
			sharedMyPaletteManager = [super allocWithZone:zone];
			return sharedMyPaletteManager;
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
        int i;
        // Initialization code here.
        images = [[NSMutableArray alloc] init];
        for( i = 0; i < 256; i++ )
        {
            MyPaletteImage *image = [[[MyPaletteImage alloc] initWithSize:NSMakeSize(30, 30)] autorelease];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:image
                                                                          forKey:@"image"];
            [images addObject:dic];
        }
        alphaDisable = 0.9f;
        currentWindow = nil;
        currentButton = nil;
        funcId = 0;
        version = 1.00;
    }
    
    return self;
}

- (void)dealloc
{
    [images release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [palette setFloatingPanel:YES];
    [palette setBecomesKeyOnlyIfNeeded:NO];
    [palette setHidesOnDeactivate:YES];
    [palette setReleasedWhenClosed:NO];
    [palette setAlphaValue:alphaDisable];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayProfileChanged:)
                                                 name:NSApplicationDidChangeScreenParametersNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willClosePalette:)
                                                 name:NSWindowWillCloseNotification
                                               object:palette];
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

- (BOOL)displaysWhenScreenProfileChanges
{
    return YES;
}

NSString    *MPCodeKeyImages = @"images";
NSString    *MPCodeKeyAlphaDisable = @"alphaDisable";
NSString    *MPCodeKeyFuncId = @"funcId";
NSString    *MPCodeKeyVersion = @"version";

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    version = [decoder decodeFloatForKey:MPCodeKeyVersion];
    
    images = [decoder decodeObjectForKey:MPCodeKeyImages];
    [images retain];
    
    alphaDisable = [decoder decodeFloatForKey:MPCodeKeyAlphaDisable];
    funcId = [decoder decodeIntForKey:MPCodeKeyFuncId];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeFloat:version forKey:MPCodeKeyVersion];
    [encoder encodeObject:images forKey:MPCodeKeyImages];
    [encoder encodeFloat:alphaDisable forKey:MPCodeKeyAlphaDisable];
    [encoder encodeInt:funcId forKey:MPCodeKeyFuncId];
}

#pragma mark - notification

- (void)willClosePalette:(NSNotification*)notification
{
    funcId = 1;
    [self drawIcon];
}

- (void)displayProfileChanged:(NSNotification*)notification
{
    NSScreen *screen = [palette screen];
    if( screen == nil )
        screen = [NSScreen mainScreen];
    
    NSRect main = [screen visibleFrame];
    NSRect mine = [palette frame];
    
    if( NSContainsRect( mine, main ) == NO )
    {
        mine.origin.x = 64;
        mine.origin.y = main.size.height - 103; // 778 -> 675
        [palette setFrameTopLeftPoint:mine.origin];
    }
}

#pragma mark - func

- (void)open
{
    if( currentWindow != nil )
    {
        [palette orderFront:nil];
        funcId = 0;
        [self drawIcon];
    }
}

- (void)close
{
    if( currentWindow != nil )
    {
        [palette performClose:nil];
        [self drawIcon];
    }
}

- (void)setPaletteArray:(NSArray *)array
{
    if( currentWindow == nil ) return;
    
    NSCollectionView *cv = [[scroll contentView] documentView];
    NSColor *color;
    NSDictionary *dic;
    MyPaletteImage *img;
    NSCollectionViewItem *item;
    NSArray *a;
    MyPaletteCell *cell;
    int i = 0;
    MyColorData *rgba;
    for( rgba in array )
    {
        color = [NSColor colorWithDeviceRed:rgba->r green:rgba->g blue:rgba->b alpha:rgba->a];
        dic = [images objectAtIndex:i];
        img = [dic objectForKey:@"image"];
        [img drawColorAndIndex:color index:i +1];
        item = [cv itemAtIndex:i];
        a = [[item view] subviews];
        cell = [a objectAtIndex:0];
        [cell setTag:i +1001];
        cell.windowController = [currentWindow windowController];
        i++;
    }
    [palette display];
}

- (void)setEffectIgnore:(NSArray *)array
{
    NSDictionary *dic;
    MyPaletteImage *img;
    MyColorData *rgba;
    int i = 0;
    for( rgba in array )
    {
        dic = [images objectAtIndex:i];
        img = [dic objectForKey:@"image"];
        [img setEffectIgnoreMarkOfSrc:rgba.allowFromSrc dst:rgba.allowToDst];
        i++;
    }
    [palette display];
}

- (void)setEffectIgnorePalNo:(NSInteger)palNo colorData:(MyColorData *)rgba
{
    NSDictionary *dic = [images objectAtIndex:palNo];
    MyPaletteImage *img = [dic objectForKey:@"image"];
    [img setEffectIgnoreMarkOfSrc:rgba.allowFromSrc dst:rgba.allowToDst];
    [palette display];
}

- (void)drawIcon
{
    if( currentButton != nil )
    {
        if( funcId )
            [currentButton setFuncName:funcName[funcId] menuName:@"Pal"];
        else
            [currentButton setFuncName:funcName[funcId] menuName:@""];
        [currentButton display];
    }
}

@end
