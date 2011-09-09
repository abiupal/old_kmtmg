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

- (NSMenu *)topMenu
{
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

@end
