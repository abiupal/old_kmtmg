//
//  MySelect4.h
//  kmtmg
//
//  Created by 武村 健二 on 11/08/03.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

@class MyDrawButton;
@class MyPanel;

@interface MySelect4 : NSObject
{
    IBOutlet MyPanel *panel;
    IBOutlet MyDrawButton *s1, *s2, *s3, *s4;
}

+ (MySelect4 *)sharedManager;
- (NSInteger)openWithArray:(NSArray *)a;
- (IBAction)press:(id)sender;

@end
