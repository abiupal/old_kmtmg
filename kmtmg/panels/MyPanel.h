//
//  MyPanel.h
//  kmtmg
//
//  Created by 武村 健二 on 11/08/04.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

#define MYPANEL_INIT -999999
#define MYPANEL_NORMAL 0

@interface MyPanel : NSPanel
{
    NSInteger tag;
    NSCursor *cursor;
}

- (void)setTag:(NSInteger)n;
- (id)getObjectFromTag:(int)n;
- (id)getObjectName:(char *)name tag:(int)n;

@property NSInteger tag;

@end
