//
//  MyEditingManager.h
//  kmtmg
//
//  Created by 武村 健二 on 11/09/09.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyfuncManager.h"

@interface MyEditingManager : MyfuncManager
{
    
}


+ (MyEditingManager *)sharedManager;

- (void)mouseDown:(NSPoint)po;
- (void)mouseUp:(NSPoint)po;
- (void)mouseDragged:(NSPoint)po;
- (void)mouseMoved:(NSPoint)po;
- (void)rightMouseDown:(NSPoint)po;
- (void)rightMouseUp:(NSPoint)po;

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv;
- (void)cancel;

@end
