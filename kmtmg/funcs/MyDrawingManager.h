//
//  MyDrawingManager.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/08.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyfuncManager.h"
#import "myImageData.h"

@interface MyDrawingManager : MyfuncManager
{
    NSView *view;
@private
    NSImage *offScreen;
    MYDRAW myd;
    MYID myi;
}

+ (MyDrawingManager *)sharedManager;

- (void)mouseDown:(NSPoint)po;
- (void)mouseUp:(NSPoint)po;
- (void)mouseDragged:(NSPoint)po;
- (void)mouseMoved:(NSPoint)po;
- (void)rightMouseDown:(NSPoint)po;
- (void)rightMouseUp:(NSPoint)po;

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv;
- (void)cancel;

@property(assign) NSView *view;

@end
