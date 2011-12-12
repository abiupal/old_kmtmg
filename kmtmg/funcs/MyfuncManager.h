//
//  MyfuncManager.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/08.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MyViewData;
@class MyRubberView;

@interface MyfuncManager : NSObject
{
    BOOL enabled, locked;
    MyViewData *mvd;
    NSPoint pre, down, pos, rightPos;
    MyRubberView *rubber;
    char funcCommand[32];
}


- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv;

- (BOOL)mouseDown:(NSPoint)po;
- (BOOL)mouseUp:(NSPoint)po;
- (void)mouseFinishedUp;
- (BOOL)mouseDragged:(NSPoint)po;
- (BOOL)rightMouseDown:(NSPoint)po;
- (BOOL)rightMouseUp:(NSPoint)po;
- (BOOL)isEnabled;
- (void)disabled;
- (char *)funcCommand;

- (NSRect)rectFromPosition;
- (void)updateWindow;
- (NSInteger)checkPositionSelectedType;

@end
