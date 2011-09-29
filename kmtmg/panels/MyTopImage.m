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
@synthesize visible;

- (id)init
{
    self = [super init];
    if( self != nil )
    {
        dstDispPosition = NSZeroRect;
        visible = TRUE;
    }
    
    return self;
}


NSString    *MTICodeKeyDstDispPosition = @"dstDispPosition";
NSString    *MTICodeKeyParentImageSize = @"parentImageSize";
NSString    *MTICodeKeyVisible = @"visible";

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    dstDispPosition = [decoder decodeRectForKey:MTICodeKeyDstDispPosition];
    parentImageSize = [decoder decodeSizeForKey:MTICodeKeyParentImageSize];
    visible = [decoder decodeBoolForKey:MTICodeKeyVisible];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeRect:dstDispPosition forKey:MTICodeKeyDstDispPosition];
    [encoder encodeSize:parentImageSize forKey:MTICodeKeyParentImageSize];
    [encoder encodeBool:visible forKey:MTICodeKeyVisible];
}

- (void)setDispPosition:(NSRect)r
{
    dstDispPosition = r;
}

- (void)drawDispRect:(NSRect)disp imageRect:(NSRect)img fraction:(CGFloat)f pixel:(NSPoint)pixel
{
    if( visible == FALSE ) return;
    
    NSRect common = NSIntersectionRect( img, dstDispPosition );
    if( NSEqualRects( common, NSZeroRect ) == YES ) return;
    
    CGFloat x, y, w, h;
    NSRect src = NSZeroRect;
    src.size = [self size];
    
    if( NSEqualRects( img, common ) == YES )
    {
        x = src.size.width * common.origin.x / parentImageSize.width;
        y = src.size.height * common.origin.y / parentImageSize.height;
        w = src.size.width * common.size.width / parentImageSize.width;
        h = src.size.height * common.size.height / parentImageSize.height;
        
        [self drawInRect:disp
                fromRect:NSMakeRect( x, y, w, h )
               operation:NSCompositeSourceOver 
                fraction:f];
    }
    else
    {
        // NSLog(@"\n  disp:%@\n   img:%@\ncommon:%@\n   dst%@\n",
        //      NSStringFromRect(disp), NSStringFromRect(img), NSStringFromRect(common),NSStringFromRect(dstDispPosition));
        x = disp.origin.x;
        y = disp.origin.y;
        x += (common.origin.x - img.origin.x) * pixel.x;
        w = common.size.width * pixel.x;
        if( common.size.width != dstDispPosition.size.width )
        {
            if( dstDispPosition.origin.x != common.origin.x )
            {
                src.origin.x = src.size.width;
                src.origin.x *= (common.origin.x - dstDispPosition.origin.x);
                src.origin.x /= dstDispPosition.size.width;
            }
            src.size.width *= common.size.width;
            src.size.width /= dstDispPosition.size.width;
        }

        y += (common.origin.y -img.origin.y) * pixel.y;
        h = common.size.height * pixel.y;
        if( common.size.height != dstDispPosition.size.height )
        {
            if( dstDispPosition.origin.y != common.origin.y )
            {
                src.origin.y = src.size.height;
                src.origin.y *= (common.origin.y - dstDispPosition.origin.y);
                src.origin.y /= dstDispPosition.size.height;
            }
            src.size.height *= common.size.height;
            src.size.height /= dstDispPosition.size.height;
        }
        
        common = NSMakeRect( x, y, w, h );
        // NSLog(@"\n   dst:%@\n   src:%@",NSStringFromRect(common), NSStringFromRect(src));
        [self drawInRect:common
                fromRect:src
               operation:NSCompositeSourceOver 
                fraction:f];
    }
    
}

@end
