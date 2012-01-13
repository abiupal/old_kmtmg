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

@interface MyReduceColor : NSObject
{
    IBOutlet MyPanel *panel;
    IBOutlet IKImageView *imgView;
    IBOutlet NSTextField *colNum;
    
    NSDictionary *imgProperties;
}

- (NSInteger)openWithImage:(NSBitmapImageRep *)bitmap;
- (IBAction)doZoom: (id)sender;
- (IBAction)switchToolMode: (id)sender;


@end
