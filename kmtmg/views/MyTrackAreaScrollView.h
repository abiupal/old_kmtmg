//
//  MyTrackAreaScrollView.h
//  kmtmg
//
//  Created by 武村 健二 on 11/03/11.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyTrackAreaScrollView : NSScrollView {
    NSWindow *keyWindow;
    
@private
    NSTrackingArea *trackingArea;
}

@property (assign) NSWindow *keyWindow;

@end
