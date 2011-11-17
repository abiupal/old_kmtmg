//
//  MyViewData.m
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2007-2011 wHITEgODDESS. All rights reserved.
//

#import "MyViewData.h"
#import "../MyDefines.h"
#import "MyIndexImageRep.h"
#import "MyColorData.h"
#import "../io/IoSKY.h"
#import "../panels/MyTopImage.h"
#import <IoCGS/MyOS.h>

@implementation MyViewData

@synthesize size, frameSize, penDot;
@synthesize scale, ratio, pixel;
@synthesize noSpace, startPosition, startPositionIsNoSpace;
@synthesize gridBoldFat;
@synthesize backgroundColor, gridColor, penColor;
@synthesize name;
@synthesize index;
@synthesize bReverseLR, bEnabled, bSaved;
@synthesize penColorNo;
@synthesize backgroundFraction, drawFraction;
@synthesize sutekake;
@synthesize indexImage;
@synthesize palette, topImages;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self) {
        version = 1.00;
		size = NSMakeSize( 800, 600 );
		scale = NSMakePoint( 1, 1 );
		ratio = NSMakePoint( 1, 1 );
		pixel = NSMakePoint( 1, 1 );
		noSpace = NSMakePoint( MVD_NOSPACE_DEFAULT, MVD_NOSPACE_DEFAULT );
		backgroundColor = [[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0] retain];
		gridColor = [[NSColor colorWithCalibratedRed:0.4 green:0.4 blue:0.4 alpha:0.8] retain];
		penColor = [[NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:1.0] retain];
		originType = MVD_ORIGIN_LD;
		gridType = MVD_GRID_ALL;
		startPosition = NSMakePoint( 0, 0 );
		gridBoldFat = NSMakePoint( 10, 10 );
		index = -1;
        indexImage = nil;
        IoSKY *sky = [[IoSKY alloc] init];
        [self setPaletteFromData:[sky l64] colorNum:256];
        [sky release];
        [self setPenFromPalette:0];
		name = nil;
		bReverseLR = NO;
        bEnabled = NO;
        bSaved = NO;
        backgroundFraction = 0.3f;
        sutekake = 0;
        penDot = NSMakeSize(1, 1);
        
        memset( &allowFromSrc, 0, sizeof(allowFromSrc) );
        memset( &allowToDst, 0, sizeof(allowToDst) );
        /*
        int i ;
        for( i = 0; i < 256; i++ )
        {
            if( i % 3 == 0 ) continue;
            else if( i % 3 == 1 )
            {
                allowToDst[i] = 1;
            }
            else
            {
                allowFromSrc[i] = 1;
            }
        }
        for( i = 256; i < 512; i++ )
        {
            if( i % 3 == 0 ) continue;
            else if( i % 3 == 1 )
            {
                allowFromSrc[i] = -1;
            }
            else
            {
                allowToDst[i] = -1;
            }
        }*/
        
        topSsk = nil;
        topImages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [topImages release];
    
    [palette release];
    
	[backgroundColor release];
    
    if( indexImage != nil )
        [indexImage release];
    
	if( name != nil )
		[name release];
    
    [super dealloc];
}

// NSSize
NSString    *MVDCodeKeySize = @"size";
NSString    *MVDCodeKeyFrameSize = @"frameSize";
NSString    *MVDCodeKeyPenDot = @"penDot";
// NSPoint
NSString    *MVDCodeKeyScale = @"scale";
NSString    *MVDCodeKeyRaito = @"ratio";
NSString    *MVDCodeKeyPixel = @"pixel";
NSString    *MVDCodeKeyNoSpace = @"noSpace";
NSString    *MVDCodeKeyStartPosition = @"startposition";
NSString    *MVDCodeKeyStartPositionIsNoSpace = @"startPositionIsNoSpace";
NSString    *MVDCodeKeyGridBoldFat = @"gridBoldFat";
// NSColor
NSString    *MVDCodeKeyBackgroundColor = @"backgroundColor";
NSString    *MVDCodeKeyGridColor = @"gridColor";
NSString    *MVDCodeKeyPenColor = @"penColor";
// NSInteger
NSString    *MVDCodeKeyOriginType = @"originType";
NSString    *MVDCodeKeyGridType = @"gridType";
NSString    *MVDCodeKeyIndex = @"index";
NSString    *MVDCodeKeyPenColorNo = @"penColorNo";
NSString    *MVDCodeKeySutekake = @"sutekake";
// BOOL
NSString    *MVDCodeKeybReverseLR = @"bReverseLR";
NSString    *MVDCodeKeybEnabled = @"bEnabled";
// float
NSString    *MVDCodeKeyVersion = @"version";
NSString    *MVDCodeKeyBackgroundFraction = @"backgroundFraction";
NSString    *MVDCodeKeyDrawFraction = @"drawFraction";
// NSString
NSString    *MVDCodeKeyName = @"name";
// char
NSString    *MVDCodeKeyAllowFromSrc = @"allowFromSrc";
NSString    *MVDCodeKeyAllowToDst = @"allowToDst";
NSString    *MVDCodeKeyEffectIgnoreType = @"effectIgnoreType";
// NSArray
NSString    *MVDCodeKeyPalette = @"palette";
NSString    *MVDCodeKeyTopImages = @"topImages";
// MyIndexImageRep
NSString    *MVDCodeKeyIndexImage = @"indexImage";
// MyTopSsk
NSString    *MVDCodeKeyTopSsk = @"topSsk";

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    size = [decoder decodeSizeForKey:MVDCodeKeySize];
    frameSize = [decoder decodeSizeForKey:MVDCodeKeyFrameSize];
    penDot = [decoder decodeSizeForKey:MVDCodeKeyPenDot];
    
    scale = [decoder decodePointForKey:MVDCodeKeyScale];
    ratio = [decoder decodePointForKey:MVDCodeKeyRaito];
    pixel = [decoder decodePointForKey:MVDCodeKeyPixel];
    noSpace = [decoder decodePointForKey:MVDCodeKeyNoSpace];
    startPosition = [decoder decodePointForKey:MVDCodeKeyStartPosition];
    startPositionIsNoSpace = [decoder decodePointForKey:MVDCodeKeyStartPositionIsNoSpace];
    gridBoldFat = [decoder decodePointForKey:MVDCodeKeyGridBoldFat];
    
    originType = [decoder decodeIntegerForKey:MVDCodeKeyOriginType];
    gridType = [decoder decodeIntegerForKey:MVDCodeKeyGridType];
    index = [decoder decodeIntegerForKey:MVDCodeKeyIndex];
    penColorNo = [decoder decodeIntegerForKey:MVDCodeKeyPenColorNo];
    sutekake = [decoder decodeIntegerForKey:MVDCodeKeySutekake];
    
    name = [decoder decodeObjectForKey:MVDCodeKeyName];
    [name retain];
    bReverseLR = [decoder decodeBoolForKey:MVDCodeKeybReverseLR];
    bEnabled = [decoder decodeBoolForKey:MVDCodeKeybEnabled];
    bSaved = NO;
    version = [decoder decodeFloatForKey:MVDCodeKeyVersion];
    backgroundFraction = [decoder decodeFloatForKey:MVDCodeKeyBackgroundFraction];
    drawFraction = [decoder decodeFloatForKey:MVDCodeKeyDrawFraction];
    if( drawFraction < 0.1f )
        drawFraction = 1.0f;
    
    NSInteger i = [decoder decodeIntegerForKey:MVDCodeKeyEffectIgnoreType];
    effectIgnoreType = i;
    NSUInteger length;
    const uint8_t *p = [decoder decodeBytesForKey:MVDCodeKeyAllowFromSrc returnedLength:&length];
    if( 512 < length ) length = 512;
    memcpy(&allowFromSrc[0], p, length);
    p = [decoder decodeBytesForKey:MVDCodeKeyAllowToDst returnedLength:&length];
    if( 512 < length ) length = 512;
    memcpy(&allowToDst[0], p, length);
    
    backgroundColor = [decoder decodeObjectForKey:MVDCodeKeyBackgroundColor];
    gridColor = [decoder decodeObjectForKey:MVDCodeKeyGridColor];
    penColor = [decoder decodeObjectForKey:MVDCodeKeyPenColor];
    [backgroundColor retain];
    [gridColor retain];
    [penColor retain];
    
    palette = [decoder decodeObjectForKey:MVDCodeKeyPalette];
    indexImage = [decoder decodeObjectForKey:MVDCodeKeyIndexImage];
    topImages = [decoder decodeObjectForKey:MVDCodeKeyTopImages];
    [palette retain];
    [indexImage retain];
    [topImages retain];
    
    [indexImage setPaletteArray:palette];
    
    topSsk = nil;


    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{    
    [encoder encodeSize:size forKey:MVDCodeKeySize];
    [encoder encodeSize:frameSize forKey:MVDCodeKeyFrameSize];
    [encoder encodeSize:penDot forKey:MVDCodeKeyPenDot];
    
    [encoder encodePoint:scale forKey:MVDCodeKeyScale];
    [encoder encodePoint:ratio forKey:MVDCodeKeyRaito];
    [encoder encodePoint:pixel forKey:MVDCodeKeyPixel];
    [encoder encodePoint:noSpace forKey:MVDCodeKeyNoSpace];
    [encoder encodePoint:startPosition forKey:MVDCodeKeyStartPosition];
    [encoder encodePoint:startPositionIsNoSpace forKey:MVDCodeKeyStartPositionIsNoSpace];
    [encoder encodePoint:gridBoldFat forKey:MVDCodeKeyGridBoldFat];

    [encoder encodeInteger:originType forKey:MVDCodeKeyOriginType];
    [encoder encodeInteger:gridType forKey:MVDCodeKeyGridType];
    [encoder encodeInteger:index forKey:MVDCodeKeyIndex];
    [encoder encodeInteger:penColorNo forKey:MVDCodeKeyPenColorNo];
    [encoder encodeInteger:sutekake forKey:MVDCodeKeySutekake];
        
    [encoder encodeObject:name forKey:MVDCodeKeyName];
    [encoder encodeBool:bReverseLR forKey:MVDCodeKeybReverseLR];
    [encoder encodeBool:bEnabled forKey:MVDCodeKeybEnabled];
    [encoder encodeFloat:version forKey:MVDCodeKeyVersion];
    [encoder encodeFloat:backgroundFraction forKey:MVDCodeKeyBackgroundFraction];
    [encoder encodeFloat:drawFraction forKey:MVDCodeKeyDrawFraction];
    
    NSInteger i = effectIgnoreType;
    [encoder encodeInteger:i forKey:MVDCodeKeyEffectIgnoreType];
    [encoder encodeBytes:(const uint8_t *)&allowFromSrc[0] length:512 forKey:MVDCodeKeyAllowFromSrc];
    [encoder encodeBytes:(const uint8_t *)&allowToDst[0] length:512 forKey:MVDCodeKeyAllowToDst];
    
    [encoder encodeObject:backgroundColor forKey:MVDCodeKeyBackgroundColor];
    [encoder encodeObject:gridColor forKey:MVDCodeKeyGridColor];
    [encoder encodeObject:penColor forKey:MVDCodeKeyPenColor];

    [encoder encodeObject:palette forKey:MVDCodeKeyPalette];
    [encoder encodeObject:indexImage forKey:MVDCodeKeyIndexImage];
    // [encoder encodeObject:topSsk forKey:MVDCodeKeyTopSsk];
    [encoder encodeObject:topImages forKey:MVDCodeKeyTopImages];
    
    topSsk = nil;
}


#pragma mark - Origin

/*
- (void)setImageUDLR
{
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    
    NSRect r = NSMakeRect(0,0,[bitmap pixelsWide], [bitmap pixelsHigh]);
    
    NSBitmapImageRep *offScreen = nil;
    
    if( originType == MVD_ORIGIN_RD || originType == MVD_ORIGIN_LU )
    {
        offScreen = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                            pixelsWide:size.width * 2
                                                            pixelsHigh:size.height
                                                         bitsPerSample:8
                                                       samplesPerPixel:4
                                                              hasAlpha:YES
                                                              isPlanar:NO
                                                        colorSpaceName:NSCalibratedRGBColorSpace
                                                           bytesPerRow:0
                                                          bitsPerPixel:0];
    }
    else
    {
        offScreen = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                            pixelsWide:size.width
                                                            pixelsHigh:size.height * 2
                                                         bitsPerSample:8
                                                       samplesPerPixel:4
                                                              hasAlpha:YES
                                                              isPlanar:NO
                                                        colorSpaceName:NSCalibratedRGBColorSpace
                                                           bytesPerRow:0
                                                          bitsPerPixel:0];
    }
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:offScreen]];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];

    NSAffineTransform *atf = [NSAffineTransform transform];
    if( originType == MVD_ORIGIN_RD || originType == MVD_ORIGIN_LU )
    {
        [atf translateXBy:r.size.width yBy:0];
        [atf scaleXBy:-1 yBy:1];
    }
    else
    {
        [atf translateXBy:0 yBy:r.size.height];
        [atf scaleXBy:1 yBy:-1];
    }
    [atf concat];
    NSDictionary *hints = [NSDictionary dictionaryWithObject:atf forKey:NSImageHintCTM];
    NSCompositingOperation op = NSCompositeCopy;
    CGFloat requestedAlpha = 1.0f;
    
    BOOL b = [bitmap drawInRect:r
                       fromRect:NSZeroRect
                      operation:op
                       fraction:requestedAlpha
                 respectFlipped:NO
                          hints:hints];
    [NSGraphicsContext restoreGraphicsState];
    [image lockFocus];
    b = [offScreen drawInRect:r fromRect:r operation:op fraction:requestedAlpha respectFlipped:NO hints:nil];
    [image unlockFocus];
    
    [offScreen release];
    
	bReverseLR = NO;
}
*/

- (void)setOriginType:(int)n
{
	if( n < MVD_ORIGIN_LU || MVD_ORIGIN_MAX <= n ) return;
	
	originType = n;
}

- (NSInteger)originType
{
    return originType;
}

- (BOOL)originUp
{
	if( originType == MVD_ORIGIN_LU || originType == MVD_ORIGIN_RU )
		return YES;
    
	return NO;
}

- (BOOL)originRight
{
	if( originType == MVD_ORIGIN_RD || originType == MVD_ORIGIN_RU )
		return YES;
    
	return NO;
}

#pragma mark - Setter

- (void)setGridType:(int)n
{
	if( n < 0 || MVD_GRID_MAX <= n ) return;
	
	gridType = n;
}

- (NSInteger)gridType
{
    return gridType;
}

- (void)setScale:(NSPoint)newScale
{
	scale = newScale;
	pixel.x = scale.x * ratio.x;
	pixel.y = scale.y * ratio.y;
}

- (void)setRatio:(NSPoint)newRatio
{
	ratio = newRatio;
	pixel.x = scale.x * ratio.x;
	pixel.y = scale.y * ratio.y;
}

- (void)setStartX:(CGFloat)startx isNoSpace:(int)n
{
	startPosition.x = startx;
	startPositionIsNoSpace.x = n;
}

- (void)setStartY:(CGFloat)starty isNoSpace:(int)n
{
	startPosition.y = starty;
	startPositionIsNoSpace.y = n;
}


- (void)setBackground:(NSColor *)newColor
{
	[backgroundColor autorelease];
	backgroundColor = [newColor retain];
}

- (void)setGrid:(NSColor *)newColor
{
	[gridColor autorelease];
	gridColor = [newColor retain];
}

- (void)setPen:(NSColor *)newColor
{
	[penColor autorelease];
	penColor = [newColor retain];
}

- (void)setPenFromPalette:(NSInteger)palNo
{
    MyColorData *rgba = [palette objectAtIndex:palNo];
    NSColor *color = [NSColor colorWithDeviceRed:rgba->r green:rgba->g blue:rgba->b alpha:rgba->a];
    [self setPen:color];
    penColorNo = palNo;
}

#pragma mark - Effect / Ignore

- (void)checkEffectIgnoreWithPaletteArray
{
    char type = [self effectIgnoreSrc] ;
    MyColorData *rgba;
    NSInteger i = 0;
    
    if (type == MVD_EFFECT_SRC )
    {
        i = 0;
        for( rgba in palette )
        {
            rgba.allowFromSrc = allowFromSrc[i++];
        }
    }
    else if( type == MVD_IGNORE_SRC )
    {
        i = 256;
        for( rgba in palette )
        {
            rgba.allowFromSrc = allowFromSrc[i++];
        }
    }
    else
    {
        for( rgba in palette )
        {
            rgba.allowFromSrc = 99;
        }
    }
    
    type = [self effectIgnoreDst] ;
    if (type == MVD_EFFECT_DST )
    {
        i = 0;
        for( rgba in palette )
        {
            rgba.allowToDst = allowToDst[i++];
        }
    }
    else if( type == MVD_IGNORE_DST )
    {
        i = 256;
        for( rgba in palette )
        {
            rgba.allowToDst = allowToDst[i++];
        }
    }
    else
    {
        for( rgba in palette )
        {
            rgba.allowToDst = 99;
        }
    }
}

// Effect/Ignore Flag YES..>Src / NO ..> Dst
- (void)setEffectIgnoreClearSrc:(BOOL)b
{
    if( b == YES )
        effectIgnoreType &= ~(MVD_EFFECT_SRC + MVD_IGNORE_SRC);
    else
        effectIgnoreType &= ~(MVD_EFFECT_DST + MVD_IGNORE_DST);
}

- (void)setEffectSrc:(BOOL)b
{
    [self setEffectIgnoreClearSrc:b];
    
    if( b == YES )
        effectIgnoreType += MVD_EFFECT_SRC;
    else
        effectIgnoreType += MVD_EFFECT_DST;
    
    [self checkEffectIgnoreWithPaletteArray];
}
- (void)setIgnoreSrc:(BOOL)b
{
    [self setEffectIgnoreClearSrc:b];
    
    if( b == YES )
        effectIgnoreType += MVD_IGNORE_SRC;
    else
        effectIgnoreType += MVD_IGNORE_DST;
    
    [self checkEffectIgnoreWithPaletteArray];
}

- (char)effectIgnoreSrc
{
    return (effectIgnoreType & (MVD_EFFECT_SRC + MVD_IGNORE_SRC));
}
- (char)effectIgnoreDst
{
    return (effectIgnoreType & (MVD_EFFECT_DST + MVD_IGNORE_DST));
}

- (void) setEffectIgnoreClearWithCheckArraySrc:(BOOL)b
{
    [self setEffectIgnoreClearSrc:b];
    [self checkEffectIgnoreWithPaletteArray];
}

- (BOOL)setEffectIgnoreFlagAtPaletteNo:(NSInteger)palNo src:(BOOL)b
{
    BOOL ret = NO;
    MyColorData *rgba = nil;
    char eiType = 0;
    eiType = [self effectIgnoreSrc];
    if( b == YES && eiType )
    {
        rgba = [palette objectAtIndex:palNo];
        if( eiType == MVD_EFFECT_SRC )
        {
            rgba.allowFromSrc = rgba.allowFromSrc ? 0 : 1;
            allowFromSrc[palNo] = rgba.allowFromSrc;
        }
        else
        {
            rgba.allowFromSrc = rgba.allowFromSrc ? 0 : -1;
            allowFromSrc[palNo +256] = rgba.allowFromSrc;
        }
        ret = YES;
    }
    eiType = [self effectIgnoreDst];
    if( b == NO && eiType )
    {
        rgba = [palette objectAtIndex:palNo];
        if( eiType == MVD_EFFECT_DST )
        {
            rgba.allowToDst = rgba.allowToDst ? 0 : 1;
            allowToDst[palNo] = rgba.allowToDst;
        }
        else
        {
            rgba.allowToDst = rgba.allowToDst ? 0 : -1;
            allowToDst[palNo +256] = rgba.allowToDst;
        }
        ret = YES;
    }
    
    return ret;
}

#pragma mark - Image


- (BOOL)setImageFromURL:(NSURL *)url
{
    BOOL ret = NO;
    
    /*
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[img TIFFRepresentation]];
    
    size = NSMakeSize([bitmap pixelsWide], [bitmap pixelsHigh]);
    */
    /* Bitmap Format changed to 32 bit RGBA 
    NSBitmapImageRep *bitmapWhoseFormatIKnow = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                                       pixelsWide:size.width pixelsHigh:size.height
                                                                                    bitsPerSample:8
                                                                                  samplesPerPixel:4
                                                                                         hasAlpha:YES
                                                                                         isPlanar:NO
                                                                                   colorSpaceName:NSCalibratedRGBColorSpace
                                                                                      bytesPerRow:0
                                                                                     bitsPerPixel:0];
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapWhoseFormatIKnow]];
    [bitmap draw];
    [NSGraphicsContext restoreGraphicsState];
    [bitmapWhoseFormatIKnow release];
    */
    
    size = NSZeroSize;
    /* background topImages */
    [self addBackgroundImageURL:url];
    
    if( NSEqualSizes(size, NSZeroSize) == NO )
    {
        [self setImageWithSize:size];
        ret = YES;
    }
    
    return ret;
}

- (void)setPaletteFromData:(unsigned char *)data colorNum:(int)n
{
    [palette release];
    palette = [[NSMutableArray alloc] init];
    
	int i;
    MyColorData *rgba;    
    for( i = 0; i < n; i++ )
    {
        rgba = [[MyColorData alloc] initWithUCharData:&data[i * 3]];
        [palette addObject:rgba];
        [rgba release];
    }
}

- (void)setImageWithSize:(NSSize)imageSize
{
    size = imageSize;
    
    if( indexImage != nil )
        [indexImage release];
    
    indexImage = [[MyIndexImageRep alloc] initWithPaletteArray:palette size:size];
}

- (void)setImageWithData:(unsigned char *)indexData 
                    size:(NSSize)imageSize 
                 palette:(unsigned char *)palData
                colorNum:(int)n
{
    [self setPaletteFromData:palData colorNum:n];
    [self setImageWithSize:imageSize];
    [indexImage setIndexData:indexData];
}


- (BOOL)hasImage
{
	if( indexImage != nil )
		return YES;
	else
		return NO;
}

- (void)setName:(NSString *)newName
{
	if( name != nil )
		[name autorelease];
	name = [newName copy];
}

- (void)drawDispRect:(NSRect)disp imageRect:(NSRect)img
{
    if( 0 < [topImages count] && 0.0f < backgroundFraction )
        [indexImage drawDispRect:disp imageRect:img origin:originType background:YES drawFraction:drawFraction];
    else
        [indexImage drawDispRect:disp imageRect:img origin:originType background:NO drawFraction:drawFraction];
}

- (void)drawScrollDispRect:(NSRect)disp imageRect:(NSRect)img
{
    BOOL bk = NO;
    if( 0 < [topImages count] && 0.0f < backgroundFraction )
        bk = YES;

    if( pixel.x < 3 && pixel.y < 3 )
        [indexImage drawScrollDispRect:disp imageRect:img origin:originType background:bk drawFraction:drawFraction];
    else
        [indexImage drawDispRect:disp imageRect:img origin:originType background:bk drawFraction:drawFraction];
}

- (void)setMyDrawSrc:(MYDRAW *)myd
{    
    myd->src = [indexImage myIdSrc];
    myd->src.allow = &allowFromSrc[0];
    myd->src.effectIgnoreType = [self effectIgnoreSrc];
    myd->pen = penColorNo;
}

- (void)setMyDrawDst:(MYDRAW *)myd
{    
    myd->dst = [indexImage myIdDst];
    myd->dst.allow = &allowToDst[0];
    myd->dst.effectIgnoreType = [self effectIgnoreDst];
    myd->pen = penColorNo;
}

- (void)addTopImage:(MyTopImage *)tImg
{    
    if ( topSsk == nil ) return;
    
    if( [tImg isValid] == NO )
        [tImg recache];
    NSImage *image = [[[NSImage alloc] initWithSize:NSMakeSize(128, 128)] autorelease];
    [image lockFocus];
    [tImg drawInRect:NSMakeRect(0,0,128,128) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0f];
    [image unlockFocus];
    [image setName:[NSString stringWithFormat:@"topImages_%d",[topImages count]]];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:image
                                                    forKey:@"image"];
    
    [topSsk addTopImage:dic];
}

- (void)setTopSsk:(MyTopSsk *)mts
{
    topSsk = mts;
    
    if ( [topImages count] == 0 ) return;
    
    MyTopImage *tImage = nil;
    for( tImage in topImages )
    {
        [self addTopImage:tImage];
    }
}

- (void)addBackgroundImageURL:(NSURL *)url
{
    MyTopImage *tImage = [[[MyTopImage alloc] initWithContentsOfURL:url] autorelease];
    if( tImage != nil && NSEqualSizes(size, NSZeroSize) )
    {
        size = [tImage size];
    }
    tImage.visible = TRUE;
    [tImage setDispPosition:NSMakeRect(0, 0, size.width, size.height)];
    tImage.parentImageSize = size;

    [topImages addObject:tImage];
    [self addTopImage:tImage];
}

- (void)removeBackgroundImage:(NSInteger)n
{
    if ( n < 0 || [topImages count] <= n ) return;
    
    MyOS *myos = [MyOS sharedManager];
    NSArray *btns = [NSArray arrayWithObjects:@"Remove", @"Cancel", nil];
    NSString *info = [NSString stringWithFormat:@"Background Image No.%d / %d",
                      n +1, [topImages count]];
    if( [myos alertButtons:btns
                   message:@"Remove the original Picture ?"
                      info:info] == NSAlertSecondButtonReturn )
            return;
    
    [topImages removeObjectAtIndex:n];
    [topSsk removeImageIndex:n];
}

- (void)changeRectPosition:(NSRect)r backgroundImage:(NSInteger)n
{
    if ( n < 0 || [topImages count] <= n ) return;
    
    MyTopImage *tImg = [topImages objectAtIndex:n];
    [tImg setDispPosition:r];
}

- (void)changeVisibleBackgroundImage:(NSInteger)n
{
    if ( n < 0 || [topImages count] <= n ) return;
    
    if( [topSsk changeVisible:n] == YES )
    {
        MyTopImage *tImage = [topImages objectAtIndex:n];
        tImage.visible = (tImage.visible ? NO : YES);
    }
}

#pragma mark - Position

- (NSInteger)imageFromDisplayPositionX:(CGFloat)x
{
	CGFloat b, n = 0.0f;
	
	b = noSpace.x;
	if( x <= b )
	{
		for( ; x < b; b -= pixel.x)
			--n;
		x = n;
	}
	else
	{
		x -= b;
		x /= pixel.x;
	}
	if( [self originRight] )
		x = size.width - x;
	x++;
	return (NSInteger)x;
}

- (NSInteger)imageFromDisplayPositionY:(CGFloat)y
{
	CGFloat b, n = 0.0f;
	
	b = noSpace.y;
	if( y <= b )
	{
		for( ; y < b; b -= pixel.y)
			--n;
		y = n;
	}
	else
	{
		y -= b;
		y /= pixel.y;
	}
	if( [self originUp] )
		y = size.height - y;
	y++;
	
	return (NSInteger)y;
}

- (CGFloat)displayFromImagePositionX:(NSInteger)x
{
    CGFloat px;
    
    x--;
    
    if( [self originRight] )
        x = size.width -x;
    px = x;
    px *= pixel.x;
    px += noSpace.x;
    
    return px;
}

- (CGFloat)displayFromImagePositionY:(NSInteger)y
{
    CGFloat py;
    
    y--;
    if( [self originUp] )
        y = size.height -y;
    
    py = y;
    py *= pixel.y;
    py += noSpace.y;
    
    return py;
}

- (NSInteger)indexFromDataPosition:(NSPoint)pos
{
    return [indexImage indexAtPosition:pos];
}

#pragma mark - drawing

- (BOOL)drawPlot:(NSPoint)po
{
    return [indexImage drawPlot:po paletteIndex:penColorNo];
}

- (NSRect)plotDisplayRect:(NSPoint)po
{
    po.x = [self displayFromImagePositionX:po.x];
    po.y = [self displayFromImagePositionY:po.y];
    
    po.x += pixel.x / 2;
    po.y += pixel.y / 2;
    
    return NSMakeRect(po.x - pixel.x, po.y -pixel.y, pixel.x * 2, pixel.y * 2);
}



@end
