//
//  Preference.h
//  kmtmg
//
//  Created by 武村 健二 on 11/10/27.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPanel.h"

@interface Preference : NSObject
{
    IBOutlet MyPanel *oPanel;
    IBOutlet NSTextField *drawImageFolder;
    IBOutlet NSMatrix *bootOptions, *defaultPalette, *keepDrawImage;
    IBOutlet NSButton *btnSelectDrawImageFolder, *btnSet;
}

+ (Preference *)sharedManager;

- (IBAction)cancel:(id)sender;
- (IBAction)set:(id)sender;
- (IBAction)selectedKeepDrawImage:(id)sender;

- (BOOL)open;

@end
