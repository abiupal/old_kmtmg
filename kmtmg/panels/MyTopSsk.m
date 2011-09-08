//
//  MyTopSsk.m
//  kmtmg
//
//  Created by 武村 健二 on 11/09/06.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyTopSsk.h"
#import "../MyDefines.h"
#import "MyTopImage.h"


@implementation MyTopSsk


#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        /* No retain / release NSMutableArray
        CFArrayCallBacks cb = kCFTypeArrayCallBacks;
        cb.retain = NULL;
        cb.release = NULL;
        
        images = (NSMutableArray *)CFArrayCreateMutable(kCFAllocatorDefault, 0, &cb);
         */
        images = [[NSMutableArray alloc] init];

    }
    
    return self;
}

- (void)dealloc
{
    [images release];
    
    [super dealloc];
}

- (NSMutableArray *)array
{
    return images;
}

- (void)update
{
    [collectionView setNeedsDisplay:YES];
}


@end
