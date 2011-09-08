//
//  MyLayerView.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/23.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyLayerView.h"
#import "MyViewData.h"
#import "MyLayerWindow.h"

@implementation MyCursorView

@synthesize mvd;
@synthesize scrollStart;

- (id)init
{
    self = [super init];
    if( self != nil )
    {
        cursorPos = NSZeroPoint;
        previousPos = NSZeroPoint;
        flag = NO;
    }
    
    return self;
}

- (void)drawline:(NSPoint)pos
{
    NSRect mine = [self window].frame;
    CGContextRef cg = [[NSGraphicsContext currentContext] graphicsPort];
    
   /* CGContextStrokeRect(cg, CGRectMake(0, pos.y-1, pos.x -10, 2));
    CGContextStrokeRect(cg, CGRectMake(pos.x +10, pos.y-1, mine.size.width -pos.x -10, 2)); */
    CGContextMoveToPoint(cg, 0, pos.y);
    CGContextAddLineToPoint(cg, mine.size.width, pos.y);
    CGContextStrokePath(cg);
    
    /*
     CGContextStrokeRect(cg, CGRectMake(pos.x-1, 0, 2, pos.y -10));
    CGContextStrokeRect(cg, CGRectMake(pos.x-1, pos.y +10, 2, mine.size.height -pos.y -10)); */
    CGContextMoveToPoint(cg, pos.x, 0);
    CGContextAddLineToPoint(cg, pos.x, mine.size.height);
    CGContextStrokePath(cg);
}

- (void)drawMark:(NSPoint)pos
{
    CGContextRef cg = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSetShadow(cg, CGSizeMake(3, 4), 6.0 );

    CGContextSetRGBFillColor(cg, 0, 1, 1, 1.0);
    CGContextMoveToPoint(cg, pos.x +10, pos.y +10);
    CGContextAddLineToPoint(cg, pos.x +20, pos.y +10);
    CGContextAddLineToPoint(cg, pos.x +10, pos.y +20);
    CGContextDrawPath(cg, kCGPathFill);

    CGContextMoveToPoint(cg, pos.x -10, pos.y -10);
    CGContextAddLineToPoint(cg, pos.x -20, pos.y -10);
    CGContextAddLineToPoint(cg, pos.x -10, pos.y -20);
    CGContextDrawPath(cg, kCGPathFill);
    
    CGContextSetRGBFillColor(cg, 1, 0, 0, 1.0);
    CGContextMoveToPoint(cg, pos.x +12, pos.y +12);
    CGContextAddLineToPoint(cg, pos.x +18, pos.y +12);
    CGContextAddLineToPoint(cg, pos.x +12, pos.y +18);
    CGContextDrawPath(cg, kCGPathFill);

    CGContextMoveToPoint(cg, pos.x -12, pos.y -12);
    CGContextAddLineToPoint(cg, pos.x -18, pos.y -12);
    CGContextAddLineToPoint(cg, pos.x -12, pos.y -18);
    CGContextDrawPath(cg, kCGPathFill);
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor clearColor] set];
    NSRectFill(dirtyRect);
    
    if( NSEqualPoints(cursorPos, previousPos) == NO )
    {
        previousPos = cursorPos;

        NSPoint pos = [self viewPointFromImagePoint:cursorPos];
        if( pos.x < LAYER_ADJUST_SIZE ) return;
        if( [self frame].size.height - LAYER_ADJUST_SIZE <= pos.y ) return;

        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        
        CGContextRef cg = [gc graphicsPort];
        
        CGContextSetShouldAntialias(cg, NO);
        
        const CGFloat dashStyle[] = {4.0, 8.0};
        CGContextSetLineDash(cg, 0.0, dashStyle, 2); 
        CGContextSetLineWidth(cg, 1.0);
                
        if( flag == NO )
            CGContextSetRGBStrokeColor(cg, 0, 0, 1, 1.0);
        else
            CGContextSetRGBStrokeColor(cg, 1, 1, 0, 1.0);
        
        [self drawline:pos];
        
        if( flag == NO )
            CGContextSetRGBStrokeColor(cg, 1, 1, 0, 1.0);
        else
            CGContextSetRGBStrokeColor(cg, 0, 0, 1, 1.0);
        
        CGContextSetLineDash(cg, 4.0, dashStyle, 2); 
        
        [self drawline:pos];
        
        [self drawMark:pos];

        
        [gc restoreGraphicsState];
        
        flag = (flag ? NO : YES);
    }
}

- (NSPoint)viewPointFromImagePoint:(NSPoint)pos
{
    // MyLog(@"%@->",NSStringFromPoint(pos));
    
    pos.x = [mvd displayFromImagePositionX:pos.x];
    pos.y = [mvd displayFromImagePositionY:pos.y];
    
    pos.x -= scrollStart.x;
    pos.y -= scrollStart.y;
    
    //  NSLog(@"  >>>>>   %@",NSStringFromPoint(pos));
    pos.x += LAYER_ADJUST_SIZE;
    
    if( 2 <= mvd.pixel.x )
        pos.x += (mvd.pixel.x /2);
    if( 2 <= mvd.pixel.y )
        pos.y += (mvd.pixel.y /2);
    
    // Adjust by origin
    if( [mvd originUp] == YES )
        pos.y -= mvd.pixel.y;
    if( [mvd originRight] == YES )
        pos.x -= mvd.pixel.x;
    
    return pos;
}

- (void)setPosition:(NSPoint)pos
{
    if( NSEqualPoints(cursorPos, pos) == NO )
    {
        cursorPos = pos;
        [self setNeedsDisplay:YES];
    }
}

@end

/*
@implementation MyCAView

- (void)setInitLayer
{
    NSBitmapImageRep*   bitmapImage;
    CGImageRef          image;
    bitmapImage = [NSBitmapImageRep imageRepWithContentsOfFile:
                   @"/Library/Desktop Pictures/Nature/Earth.jpg"];
    image = [bitmapImage CGImage];
    
    // レイヤーを作成する
    CALayer* layer;
    layer = [CALayer layer];
    // レイヤーに画像を設定する
    layer.contents = (id)image;
    layer.frame = CGRectMake(0, 0, 256, 160);
    
    // 背景レイヤーを作成する
    CALayer*    backgroundLayer;
    backgroundLayer = [CALayer layer];
    backgroundLayer.backgroundColor = kCGColorClear;
    
    // 画像レイヤーを背景レイヤーに追加する
    [backgroundLayer addSublayer:layer];
    
    // レイヤーをビューに設定する
    [self setLayer:backgroundLayer];
    [self setWantsLayer:YES];
}

@end
 */
