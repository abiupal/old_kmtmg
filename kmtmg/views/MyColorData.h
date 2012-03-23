//
//  MyColorData.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/06.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyColorData : NSObject <NSCoding> {

@public
    CGFloat r, g, b, a;
    // -1: Ignore
    //  0: normal
    //  1: Effect
    char allowFromSrc, allowToDst;
@private
    CGFloat version;
}

- (id)initWithFloatRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (id)initWithIntRed:(int)red green:(int)green blue:(int)blue;
- (id)initWithUCharData:(unsigned char *)data;

- (void)changeDataWithUCharData:(unsigned char *)data;

@property char allowFromSrc, allowToDst;

@end
