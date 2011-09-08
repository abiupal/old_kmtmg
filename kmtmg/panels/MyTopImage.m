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

@end
