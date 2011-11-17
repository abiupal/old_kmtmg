//
//  MyViewData.h
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2007-2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyIndexImageRep.h"
#import "MyViewDataDefines.h"
#import "../panels/MyTopSsk.h"

@interface MyViewData : NSObject <NSCoding>
{
       
@private
    CGFloat version;
	NSSize size, frameSize, penDot;
	NSPoint scale, ratio, pixel;
	NSPoint noSpace, startPosition, startPositionIsNoSpace;
	NSPoint gridBoldFat;
	NSColor *backgroundColor, *gridColor, *penColor;
	// NSImage *image, *backgroundImage;
    NSMutableArray *palette;
	NSString *name;
	NSInteger originType, gridType, index;
    NSInteger penColorNo, sutekake;
	BOOL bReverseLR, bEnabled, bSaved;
    
    MyIndexImageRep *indexImage;
    CGFloat backgroundFraction, drawFraction;
    NSMutableArray *topImages;
    MyTopSsk *topSsk;
    
    // -1: Ignore
    //  0: normal
    //  1: Effect
    //   [0-255]:For_Effect
    // [256-511]:For_Ignore
    char allowFromSrc[512];
    char allowToDst[512];
    char effectIgnoreType;
}

- (void)setOriginType:(int)n;
- (NSInteger)originType;
- (BOOL)originUp;
- (BOOL)originRight;
// - (void)setSize:(NSSize)newSize;
- (void)setGridType:(int)n;
- (NSInteger)gridType;
- (void)setScale:(NSPoint)newRatio;
- (void)setRatio:(NSPoint)newRatio;
- (void)setStartX:(CGFloat)startx isNoSpace:(int)n;
- (void)setStartY:(CGFloat)starty isNoSpace:(int)n;
- (void)setBackground:(NSColor *)newColor;
- (void)setGrid:(NSColor *)newColor;
- (void)setPen:(NSColor *)newColor;
- (void)setPenFromPalette:(NSInteger)palNo;
// YES..>Src / NO ..> Dst
- (void)setEffectSrc:(BOOL)b;
- (void)setIgnoreSrc:(BOOL)b;
- (char)effectIgnoreSrc;
- (char)effectIgnoreDst;
- (void)setEffectIgnoreClearWithCheckArraySrc:(BOOL)b;
- (BOOL)setEffectIgnoreFlagAtPaletteNo:(NSInteger)palNo src:(BOOL)b;

// - (void)makeReverseLR;
- (void)setPaletteFromData:(unsigned char *)data colorNum:(int)n;
- (BOOL)setImageFromURL:(NSURL *)url;
- (void)setImageWithData:(unsigned char *)indexData size:(NSSize)imageSize palette:(unsigned char *)palData colorNum:(int)n;
- (void)setImageWithSize:(NSSize)imageSize;

- (void)addBackgroundImageURL:(NSURL *)url;
- (void)removeBackgroundImage:(NSInteger)n;
- (void)changeRectPosition:(NSRect)r backgroundImage:(NSInteger)n;
- (void)changeVisibleBackgroundImage:(NSInteger)n;

- (BOOL)hasImage;
- (void)setName:(NSString *)newName;

- (void)drawDispRect:(NSRect)disp imageRect:(NSRect)img;
- (void)drawScrollDispRect:(NSRect)disp imageRect:(NSRect)img;
- (BOOL)drawPlot:(NSPoint)po;
- (NSRect)plotDisplayRect:(NSPoint)po;
- (NSInteger)imageFromDisplayPositionX:(CGFloat)x;
- (NSInteger)imageFromDisplayPositionY:(CGFloat)y;
- (CGFloat)displayFromImagePositionX:(NSInteger)x;
- (CGFloat)displayFromImagePositionY:(NSInteger)y;
- (NSInteger)indexFromDataPosition:(NSPoint)pos;
- (void)setMyDrawSrc:(MYDRAW *)myd;
- (void)setMyDrawDst:(MYDRAW *)myd;
- (void)setTopSsk:(MyTopSsk *)mts;

@property NSSize size, frameSize, penDot;
@property NSPoint scale, ratio, pixel;
@property NSPoint noSpace, startPosition, startPositionIsNoSpace;
@property NSPoint gridBoldFat;
@property(retain) NSColor *backgroundColor, *gridColor, *penColor;
// @property(retain) NSBitmapImageRep *bitmap;
@property(copy) NSString *name;
@property(readonly) NSInteger index, penColorNo;
@property(readonly) BOOL bReverseLR;
@property BOOL bEnabled, bSaved;
@property CGFloat backgroundFraction, drawFraction;
@property NSInteger sutekake;
@property(readonly, assign) MyIndexImageRep *indexImage;
@property(readonly, assign) NSMutableArray *palette, *topImages;


@end
