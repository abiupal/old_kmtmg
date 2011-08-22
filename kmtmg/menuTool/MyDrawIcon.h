//
//  MyDrawIcon.h
//  ToolBar
//
//  Created by 武村 健二 on 07/09/07.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyDrawIcon : NSObject
{
	NSRect iRect;
	int iPenWidth, iIconSize;
    NSImage *cursorImage;
}

+ (MyDrawIcon *)sharedManager;
- (BOOL)hasIcon:(char *)f;
- (void)drawRect:(NSRect)r func:(char *)f;
- (void)setOnShadow;
- (void)setOffShadow;
- (NSImage *)cursorImage;

@end
