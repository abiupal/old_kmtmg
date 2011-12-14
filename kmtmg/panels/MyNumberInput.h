//
//  MyNumberInput.h
//  kmtmg
//
//  Created by 武村 健二 on 11/12/13.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <AppKit/AppKit.h>

@class MyDrawButton;
@class MyPanel;

@interface MyNumberInput : NSObject
{
    IBOutlet MyPanel *panel;
    IBOutlet NSTextField *range, *number, *prevLabel;
    
    IBOutlet NSNumberFormatter *formatter;
    
    CGFloat prevValue;
}

+ (MyNumberInput *)sharedManager;
- (NSInteger)openWithMin:(CGFloat)min max:(CGFloat)max;
- (IBAction)press:(id)sender;
- (IBAction)prev:(id)sender;

@end