//
//  MyTopSsk.h
//  kmtmg
//
//  Created by 武村 健二 on 11/09/06.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTopSsk : NSObject
{
    NSMutableArray *images;
    IBOutlet NSArrayController *arrayController;
}


+ (MyTopSsk *)sharedManager;

@end