//
//  MyReduceColor.h
//  kmtmg
//
//  Created by 武村 健二 on 12/01/13.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class IKImageView;
@class MyPanel;
@class MyTextFieldWithNumberInput;

@interface MyReduceColor : NSObject
{
    IBOutlet MyPanel *panel;
    IBOutlet IKImageView *imgView;
    
    NSInteger colNum, bwNum;
    
    NSDictionary *imgProperties;
}

- (NSInteger)openWithImage:(NSBitmapImageRep *)bitmap;
- (IBAction)doZoom: (id)sender;
- (IBAction)switchToolMode: (id)sender;
- (IBAction)setRotation: (id)sender;
- (IBAction)selectedImage: (id)sender;
- (IBAction)colorNum:(id)sender;
- (IBAction)blackWhiteNum:(id)sender;

@property NSInteger colNum, bwNum;

@end
