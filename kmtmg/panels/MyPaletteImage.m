//
//  MyPaletteImage.m
//  kmtmg
//
//  Created by 武村 健二 on 11/03/11.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyPaletteImage.h"
#import "MyDefines.h"

@implementation MyPaletteImage

@synthesize sType, dType;

- (id)init
{
    self = [super init];
    if (self) {
        sType = dType = 99;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawColorAndIndex:(NSColor *)color index:(NSInteger)n
{
    NSColor *stringColor = nil;
    CGFloat kuro = 0;
    
    if( [[color colorSpaceName] isEqualToString:NSCalibratedWhiteColorSpace] == NO )
        kuro = (24.0f * [color redComponent] + 67.0f * [color greenComponent] + 8 * [color blueComponent]) / 100 ;
    // MyLog( @"%3d >> %.3f = 24 * %.3f + 67 * %.3f + 8 * %.3f", n, kuro, [color redComponent], [color greenComponent], [color blueComponent] );
    else
        kuro = 1.0f - [color whiteComponent];
    if( kuro <= 0.53f )
        stringColor = [NSColor whiteColor];
    else
        stringColor = [NSColor blackColor];
    
    NSPoint pos = NSZeroPoint;
    NSMutableAttributedString *string = nil;
    if( -1 < n )
    {
        NSFont *font = [[NSFont fontWithName:@"Courier" size:12] retain];
        string = [[[NSMutableAttributedString alloc] 
                                              initWithString:[NSString stringWithFormat:@"%d", (int)n]]
                                             autorelease];
    
        [string beginEditing];
        
        [string addAttribute:NSFontAttributeName
                       value:font
                       range:NSMakeRange(0, [string length])];
        [string addAttribute:NSForegroundColorAttributeName
                       value:stringColor
                       range:NSMakeRange(0, [string length])];
    
	
        [string endEditing];
	
        NSSize ss = [string size];
        NSSize is = [self size];
        pos = NSMakePoint((is.width - ss.width) /2, (is.height - ss.height) /2);
    }
    
    [self lockFocus];
    [color set];
    NSRectFill( NSMakeRect(0, 0, self.size.width, self.size.height));
	if( string != nil )
        [string drawAtPoint:pos];
    
    [self unlockFocus];
    
    sType = dType = 99;
}

- (void)setEffectIgnoreMarkOfSrc:(char)sValue dst:(char)dValue
{
    sType = sValue;
    dType = dValue;
}

@end

#pragma mark - MyImageCell

@implementation MyImageCell

@synthesize windowController;

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (void)setTag:(NSInteger)anInt
{
    myTag = anInt;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint po = [self convertPoint:[theEvent locationInWindow] fromView:Nil];
    // MyLog( @"> %d, %@", myTag, NSStringFromPoint(po) );
    
    [windowController pressPaletteNo:myTag -1001 pos:po];
}

- (void)effectIgnoreSrc:(char)type size:(NSSize)size
{
    switch (type) {
        case -1:
            [[NSColor colorWithCalibratedRed:0.8 green:0.0 blue:0.0 alpha:0.8] set]; break;
        case 1:
            [[NSColor colorWithCalibratedRed:0.0 green:0.8 blue:0.0 alpha:0.8] set]; break;
            
        default:
            [[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:0.8] set]; break;
    }
    // NSRectFill(NSMakeRect(2, 2 +size.height * 3 / 4, size.width, size.height  / 4));
    NSBezierPath *path = [NSBezierPath bezierPath];
    size.width -= 4;
    [path moveToPoint:NSMakePoint(4, size.height)];
    [path lineToPoint:NSMakePoint(4 + size.width,  size.height)];
    [path lineToPoint:NSMakePoint(4 + size.width /2,  size.height * 3 /4)];
    [path closePath];
    [path fill];
    [[NSColor orangeColor] set];
    [path setLineWidth:1.5];
    [path setLineCapStyle:NSSquareLineCapStyle];
    [path setLineJoinStyle:NSMiterLineJoinStyle];
    [path stroke];
}

- (void)effectIgnoreDst:(char)type size:(NSSize)size
{
    switch (type) {
        case -1:
            [[NSColor colorWithCalibratedRed:0.8 green:0.0 blue:0.0 alpha:0.8] set]; break;
        case 1:
            [[NSColor colorWithCalibratedRed:0.0 green:0.8 blue:0.0 alpha:0.8] set]; break;
            
        default:
            [[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:0.8] set]; break;
    }
    // NSRectFill(NSMakeRect(2, 2 +size.height * 3 / 4, size.width, size.height  / 4));
    NSBezierPath *path = [NSBezierPath bezierPath];
    size.width -= 4;
    [path moveToPoint:NSMakePoint(4, 4)];
    [path lineToPoint:NSMakePoint(4 + size.width, 4)];
    [path lineToPoint:NSMakePoint(4 + size.width, 4 + size.height /5)];
    [path lineToPoint:NSMakePoint(4, 4 + size.height /5)];
    [path closePath];
    [path fill];
    [[NSColor orangeColor] set];
    [path setLineWidth:2];
    [path setLineCapStyle:NSSquareLineCapStyle];
    [path setLineJoinStyle:NSMiterLineJoinStyle];
    [path stroke];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    MyPaletteImage *palImage = (MyPaletteImage *)[self image];
    
    if( palImage.sType != 99 )
        [self effectIgnoreSrc:palImage.sType size:[palImage size]];
    
    if( palImage.dType != 99 )
        [self effectIgnoreDst:palImage.dType size:[palImage size]];
}


@end

#pragma mark - MyPaletteView

@implementation MyPaletteView
@synthesize palImage;

- (void)awakeFromNib
{
    if( palImage == nil )
    {
        palImage = [[[MyPaletteImage alloc] initWithSize:[self bounds].size] retain];
    }
}
- (void)dealloc
{
    [palImage release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [palImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

@end

