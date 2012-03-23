//
//  MyNumberInput.h
//  kmtmg
//
//  Created by 武村 健二 on 11/12/13.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MyPanel.h"

@interface MyNumberInput : NSObject
{
    IBOutlet MyPanel *panel;
    IBOutlet NSTextField *range, *number, *prevLabel, *message;
    
    IBOutlet NSNumberFormatter *formatter;
    
    CGFloat prevValue;
}

+ (MyNumberInput *)sharedManager;
- (NSInteger)openWithMin:(CGFloat)min max:(CGFloat)max string:(const char *)msg;
- (IBAction)press:(id)sender;
- (IBAction)prev:(id)sender;

@end