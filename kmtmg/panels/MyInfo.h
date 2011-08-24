//
//  MyInfo.h
//  kmtmg
//
//  Created by 武村 健二 on 11/03/22.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../views/MyTrackAreaScrollView.h"

@class MyPaletteView;
@class MyDrawButton;

@interface MyInfo : NSObject {
    IBOutlet NSPanel *information;
    IBOutlet MyPaletteView *penView, *posView;
    IBOutlet NSTextField *posX, *posY;
    IBOutlet MyTrackAreaScrollView *scroll;
    IBOutlet NSSlider *fraction;
    IBOutlet MyDrawButton *currentFunction;
    NSWindow *currentWindow;
    
@private
    NSPoint prePosition;
    CGFloat alphaDisable, scale;
    NSSize dotSize;
    NSPoint ratio;
    NSInteger prePosColor;
    NSFont *scrollerFont;
    NSFont *rubberFont;
}
@property (assign) MyTrackAreaScrollView *scroll;
@property (assign) NSWindow *currentWindow;
@property (readonly) NSPoint prePosition;
@property NSSize dotSize;
@property NSPoint ratio;
@property (assign) MyDrawButton *currentFunction;

+ (MyInfo *)sharedManager;
- (void)open;
- (void)textPosition:(NSPoint)pos;
- (void)penColor:(NSColor *)color palNo:(NSInteger)no;
- (void)posColor:(NSColor *)color palNo:(NSInteger)no;
- (void)setImageFraction:(CGFloat)f;
- (CGFloat)imageFraction;
- (void)setScale:(CGFloat)n;
- (void)updateInfo;
- (void)setFunction:(char *)cmd;
- (NSFont *)scrollerFont;
- (NSFont *)rubberFont;

- (IBAction)changeFraction:(id)sender;
- (IBAction)changeDotX:(id)sender;
- (IBAction)changeDotY:(id)sender;
- (IBAction)changeRatioX:(id)sender;
- (IBAction)changeRatioY:(id)sender;
- (IBAction)pressFunction:(id)sender;

@end
