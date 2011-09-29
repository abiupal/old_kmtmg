//
//  MyTopSsk.h
//  kmtmg
//
//  Created by 武村 健二 on 11/09/06.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTopSsk : NSObject <NSCoding>
{
    NSMutableArray *images;
    IBOutlet NSArrayController *arrayController;
    IBOutlet NSCollectionView *collectionView;
}

- (NSMutableArray *)array;

- (IBAction)pressTOP:(id)sender;
- (IBAction)pressSSK:(id)sender;
- (void)addTopImage:(NSDictionary *)dic;
- (void)removeImageIndex:(NSInteger)n;
- (BOOL)changeVisible:(NSInteger)n;

@end


@interface MyTopSskCell : NSImageView {
    BOOL unvisible;
}

@property BOOL unvisible;

@end