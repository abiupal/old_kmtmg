/* MyView */

#import <Cocoa/Cocoa.h>
#import "MyViewData.h"

@interface MyView : NSView
{
	MyViewData *mvd;
	NSRect iUpdateRect, iUpdateDisp;
    BOOL keyScroll, initialDraw;
    NSInteger penColorNoForDoubleClick;
}

- (void)setMyViewData:(MyViewData *)data;
- (void)checkUpdateData;
- (NSPoint)centerPositionUpdateRect;

@property BOOL keyScroll;

@end
