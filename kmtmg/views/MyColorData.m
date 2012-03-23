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

#define CURRENT_VERSION 1.00f

- (id)initWithFloatRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    if( self != nil )
    {
        r = red; g = green; b = blue; a = 1.0f;
        allowFromSrc = allowToDst = 0;
        version = CURRENT_VERSION;
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
        version = CURRENT_VERSION;
    }
    
    return self;
}

- (id)initWithUCharData:(unsigned char *)data
{
    if( self != nil )
    {
        [self changeDataWithUCharData:data];
        a = 1.0f;
        allowFromSrc = allowToDst = 0;
        version = CURRENT_VERSION;
    }
    
    return self;
}

NSString    *MCDCodeKeyRed = @"red";
NSString    *MCDCodeKeyGreen = @"green";
NSString    *MCDCodeKeyBlue = @"blue";
NSString    *MCDCodeKeyAlpha = @"alpha";
NSString    *MCDCodeKeyAllowFromSrc = @"allowFromSrc";
NSString    *MCDCodeKeyAllowToDst = @"allowToDst";
NSString    *MCDCodeKeyVersion = @"version";

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    version = [decoder decodeFloatForKey:MCDCodeKeyVersion];
    
    r = [decoder decodeFloatForKey:MCDCodeKeyRed];
    g = [decoder decodeFloatForKey:MCDCodeKeyGreen];
    b = [decoder decodeFloatForKey:MCDCodeKeyBlue];
    a = [decoder decodeFloatForKey:MCDCodeKeyAlpha];
    
    int i = [decoder decodeIntForKey:MCDCodeKeyAllowFromSrc];
    allowFromSrc = i;
    i = [decoder decodeIntForKey:MCDCodeKeyAllowToDst];
    allowToDst = i;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeFloat:version forKey:MCDCodeKeyVersion];
    
    [encoder encodeFloat:r forKey:MCDCodeKeyRed];
    [encoder encodeFloat:g forKey:MCDCodeKeyGreen];
    [encoder encodeFloat:b forKey:MCDCodeKeyBlue];
    [encoder encodeFloat:a forKey:MCDCodeKeyAlpha];
    
    int i = allowFromSrc;
    [encoder encodeInt:i forKey:MCDCodeKeyAllowFromSrc];
    i = allowToDst;
    [encoder encodeInt:i forKey:MCDCodeKeyAllowToDst];
}

- (void)changeDataWithUCharData:(unsigned char *)data
{
    r = data[0]; r /= 255;
    g = data[1]; g /= 255; 
    b = data[2]; b /= 255;
    
    MyLog(@"%.2f,%.2f,%.2f\n", r, g, b);
}

@end
