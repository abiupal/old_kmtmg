//
//  MyIndexImageRep.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/02.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "../funcs/myImageData.h"

@interface MyIndexImageRep : NSCustomImageRep {
    NSMutableArray *palette; // substi
    unsigned char *data;
    
@private
    NSImage *dispImage, *preDispImage;
    NSRect preImgRect, scrollImg;
    BOOL bAccepted;
}

- (id)initWithPaletteArray:(NSMutableArray *)array size:(NSSize)size;
- (void)convertImageFromBitmapRep:(NSBitmapImageRep *)bitmap;
- (void)setIndexData:(unsigned char *)index;
- (void)testpattern;
- (void)drawDispRect:(NSRect)disp imageRect:(NSRect)img origin:(NSInteger)originType background:(BOOL)bkImage drawFraction:(CGFloat)fraction;
- (void)drawScrollDispRect:(NSRect)disp imageRect:(NSRect)img origin:(NSInteger)originType background:(BOOL)bkImage drawFraction:(CGFloat)fraction;
- (BOOL)drawPlot:(NSPoint)po paletteIndex:(NSInteger)no;
- (NSInteger)indexAtPosition:(NSPoint)pos;
- (void)setInfoColorFromDataPosition:(NSPoint)pos;
- (MYID)myIdSrc;
- (MYID)myIdDst;
- (void)setPaletteArray:(NSMutableArray *)array;

@property(readonly,assign) NSMutableArray *palette;
@property(readonly) unsigned char *data;

@end
