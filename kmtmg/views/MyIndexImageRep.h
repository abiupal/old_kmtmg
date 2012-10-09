//
//  MyIndexImageRep.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/02.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "../funcs/myImageData.h"

@interface MyIndexExtend : NSObject <NSCoding> {
@private
    unsigned char buf[16];
}
- (int)serial;
- (int)koshi;
- (int)ren;
- (int)hi;
- (NSString *)typeString;

- (void)setSerial:(int)serial;
- (void)setKoshi:(int)koshi;
- (void)setRen:(int)ren;
- (void)setHi:(int)hi;
- (void)setTypeString:(char *)type;

@end

@interface MyIndexImageRep : NSCustomImageRep {
    NSMutableArray *palette, *undoData; // substi
    unsigned char *data;
    
@private
    NSImage *dispImage, *preDispImage;
    NSRect preImgRect, scrollImg;
    BOOL bAccepted, bUndoRecord;
    
    NSMutableArray *extend;
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

- (MyIndexExtend *)extendByY:(NSUInteger)y;
- (void)setCGSExtendByY:(NSUInteger)y cgs:(unsigned char *)line;

- (void)startUndoRecord;
- (void)endUndoRecord;
- (void)setUndoDrawing:(id)sender;


@property(readonly,assign) NSMutableArray *palette, *undoData;
@property(readonly) unsigned char *data;

@end
