//
//  MyTopImage.h
//  kmtmg
//
//  Created by 武村 健二 on 11/09/08.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MyTopImage : NSImage {

    NSRect dstDispPosition;
    NSSize parentImageSize;
}

- (void)setDispPosition:(NSRect)r;
- (void)drawDispRect:(NSRect)disp imageRect:(NSRect)img fraction:(CGFloat)f;

@property NSSize parentImageSize;

@end
