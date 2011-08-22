//
//  MyColorData.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/06.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyColorData.h"

@implementation MyColorData

@synthesize allowFromSrc, allowToDst;


- (id)initWithFloatRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    if( self != nil )
    {
        r = red; g = green; b = blue; a = 1.0f;
        allowFromSrc = allowToDst = 0;
    }
    
    return self;
}

- (id)initWithIntRed:(int)red green:(int)green blue:(int)blue
{
    if( self != nil )
    {
        r = red; r /= 255;
        g = green; g /= 255; 
        b = blue; b /= 255;
        a = 1.0f;
        allowFromSrc = allowToDst = 0;
    }
    
    return self;
}

- (id)initWithUCharData:(unsigned char *)data
{
    if( self != nil )
    {
        r = data[0]; r /= 255;
        g = data[1]; g /= 255; 
        b = data[2]; b /= 255;
        a = 1.0f;
        allowFromSrc = allowToDst = 0;
    }
    
    return self;
}


@end
