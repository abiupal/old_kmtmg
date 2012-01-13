//
//  MyColoringManager.h
//  kmtmg
//
//  Created by 武村 健二 on 12/01/10.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "MyfuncManager.h"

@interface MyColoringManager : MyfuncManager
{
    CGFloat gH, gS, gV;
    /* R:[0]-[255]
    // G:[256]-[511]
    // B:[512]-[767] */
    unsigned char *buffer;
    NSUInteger allocSize;
    NSInteger bwNum, colNum;
}

+ (MyColoringManager *)sharedManager;

- (void)mouseDown:(NSPoint)po;
- (void)mouseUp:(NSPoint)po;
- (void)mouseDragged:(NSPoint)po;
- (void)mouseMoved:(NSPoint)po;
- (void)rightMouseDown:(NSPoint)po;
- (void)rightMouseUp:(NSPoint)po;

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv;
- (void)cancel;
- (void)cleanup;

- (unsigned char *)palette;
- (NSInteger)paletteNum;
- (NSData *)reduceColorImage:(NSImage *)src rect:(NSRect)dstRect size:(NSSize)dstSize;
- (NSData *)reduceColorImage:(NSImage *)src size:(NSSize)dstSize;

@end
