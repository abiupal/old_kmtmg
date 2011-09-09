//
//  MyTopImage.m
//  kmtmg
//
//  Created by 武村 健二 on 11/09/08.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyTopImage.h"
#import "../MyDefines.h"

@implementation MyTopImage

@synthesize parentImageSize;

- (id)init
{
    self = [super init];
    if( self != nil )
    {
        dstDispPosition = NSZeroRect;
    }
    
    return self;
}

- (void)setDispPosition:(NSRect)r
{
    dstDispPosition = r;
}

- (void)drawDispRect:(NSRect)disp imageRect:(NSRect)img fraction:(CGFloat)f
{
    NSRect common = NSIntersectionRect( img, dstDispPosition );
    if( NSEqualRects( common, NSZeroRect ) == YES ) return;
    
    NSSize bkSize = [self size];
    CGFloat x, y, w, h;
    x = bkSize.width * common.origin.x / parentImageSize.width;
    y = bkSize.height * common.origin.y / parentImageSize.height;
    w = bkSize.width * common.size.width / parentImageSize.width;
    h = bkSize.height * common.size.height / parentImageSize.height;

    if( NSEqualRects( img, common ) == YES )
    {        
        [self drawInRect:disp
                fromRect:NSMakeRect( x, y, w, h )
               operation:NSCompositeSourceOver 
                fraction:f];
    }
    else
    {
        
    }
    
}

@end
