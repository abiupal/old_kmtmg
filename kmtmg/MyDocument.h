//
//  MyDocument.h
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "views/MyWindowController.h"
#import "MyPalette.h"

@interface MyDocument : NSPersistentDocument {
@private
    MyWindowController *mvc;
    MyViewData  *mvd;
}

- (void)functionCommand:(char *)cmd;

@end
