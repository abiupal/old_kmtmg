//
//  MyTopSskView.h
//  kmtmg
//
//  Created by 武村 健二 on 11/09/09.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

@class MyWindowController;

@interface MyTopSskView : NSCollectionView
{
    IBOutlet MyWindowController *winController;
    IBOutlet NSMenu *topMenu;
    IBOutlet NSMenu *sskMenu;
    NSInteger selected;
    char commandString[32];
}

- (NSMenu *)topMenu:(BOOL)unvisible;
- (NSMenu *)sskMenu;

- (IBAction)resizeArea:(id)sender;
- (IBAction)removeImage:(id)sender;
- (IBAction)changeVisible:(id)sender;
- (IBAction)putOnData:(id)sender;

@property NSInteger selected;

@end
