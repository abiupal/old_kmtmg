//
//  MyTopSskView.m
//  kmtmg
//
//  Created by 武村 健二 on 11/09/09.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyTopSskView.h"
#import "../MyDefines.h"
#import "../views/MyWindowController.h"

@implementation MyTopSskView
@synthesize selected;

/*
// 0:Visible
// 1:Resize
// 2:Remove
// */
- (NSMenu *)topMenu:(BOOL)unvisible
{
    if( unvisible == NO )
    { // View ON
        NSMenuItem *mi = [topMenu itemAtIndex:0];
        [mi setTitle:@"Visible OFF"];
        [topMenu itemChanged:mi];
        mi = [topMenu itemAtIndex:1];
        [mi setHidden:NO];
        [topMenu itemChanged:mi];
    }
    else
    { // View OFF
        NSMenuItem *mi = [topMenu itemAtIndex:0];
        [mi setTitle:@"Visible ON"];
        [topMenu itemChanged:mi];
        mi = [topMenu itemAtIndex:1];
        [mi setHidden:YES];
        [topMenu itemChanged:mi];
    }
    return topMenu;
}

- (NSMenu *)sskMenu
{
    return sskMenu;
}

- (IBAction)resizeArea:(id)sender
{
    memset(commandString, 0, sizeof(commandString));
    sprintf(commandString, "TS_RESIZE_%d", selected );
    [winController functionCommand:commandString];
}
- (IBAction)removeImage:(id)sender
{
    memset(commandString, 0, sizeof(commandString));
    sprintf(commandString, "TS_REMOVE_%d", selected );
    [winController functionCommand:commandString];
}
- (IBAction)changeVisible:(id)sender
{
    memset(commandString, 0, sizeof(commandString));
    sprintf(commandString, "TS_VISIBLE_%d", selected );
    [winController functionCommand:commandString];
}
- (IBAction)putOnData:(id)sender
{
    memset(commandString, 0, sizeof(commandString));
    sprintf(commandString, "TS_PUTON_%d", selected );
    [winController functionCommand:commandString];
}

@end
