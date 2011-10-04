//
//  MyPalette.h
//  kmtmg
//
//  Created by 武村 健二 on 11/03/10.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyTrackAreaScrollView.h"

@class MyDrawButton;
@class MyColorData;

@interface MyPalette : NSObject <NSCoding> {
    NSMutableArray *images;
    IBOutlet NSArrayController *arrayController;
    IBOutlet NSPanel *palette;
    IBOutlet MyTrackAreaScrollView *scroll;
    NSWindow *currentWindow;
    MyDrawButton *currentButton;
    
@private
    CGFloat version;
    CGFloat alphaDisable;
    int funcId;
}

@property (assign) MyTrackAreaScrollView *scroll;
@property (readwrite, assign) NSWindow *currentWindow;  
@property (readwrite, assign) MyDrawButton *currentButton;

+ (MyPalette *)sharedManager;
- (void)open;
- (void)setPaletteArray:(NSArray *)array;
- (void)drawIcon;
- (void)close;
- (void)setEffectIgnore:(NSArray *)array;
- (void)setEffectIgnorePalNo:(NSInteger)palNo colorData:(MyColorData *)rgba;

@end
