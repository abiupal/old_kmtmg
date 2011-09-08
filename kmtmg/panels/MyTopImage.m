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
}

- (void)setDispPosition:(NSRect)r
{
    dstDispPosition = r;
}

- (void)drawUpdateRect:(NSRect)update disp:(NSRect)disp fraction:(CGFloat)f
{
    NSSize bkSize = [self size];
    CGFloat x, y, w, h;
    x = bkSize.width * update.origin.x / parentImageSize.width;
    y = bkSize.height * update.origin.y / parentImageSize.height;
    w = bkSize.width * update.size.width / parentImageSize.width;
    h = bkSize.height * update.size.height / parentImageSize.height;
    [self drawInRect:disp
          fromRect:NSMakeRect( x, y, w, h )
         operation:NSCompositeSourceOver 
          fraction:f];
}

@end
