//
//  MyPanel.h
//  kmtmg
//
//  Created by 武村 健二 on 11/08/04.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MyPanel : NSPanel
{
    NSInteger tag;
}

- (void)setTag:(NSInteger)n;

@end
