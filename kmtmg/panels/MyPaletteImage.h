//
//  MyPaletteImage.h
//  kmtmg
//
//  Created by 武村 健二 on 11/03/11.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../views/MyWindowController.h"

@interface MyPaletteImage : NSImage {
@private
    char sType, dType;
}

- (void)drawColorAndIndex:(NSColor *)color index:(NSInteger)n;
- (void)setEffectIgnoreMarkOfSrc:(char)sType dst:(char)dType;

@property(readonly) char sType, dType;

@end

@interface MyPaletteCell : NSImageView {
    MyWindowController *windowController;
    NSInteger myTag;
}

- (void)setTag:(NSInteger)anInt;

@property (readwrite, assign) MyWindowController *windowController;

@end

@interface MyPaletteView : NSView {
@private
    MyPaletteImage *palImage;
}
@property (retain) MyPaletteImage *palImage;

@end