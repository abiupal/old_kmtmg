/* MyScrollView */

#import <Cocoa/Cocoa.h>
#import "MyViewData.h"

enum { SCROLL_H, SCROLL_V };


@interface MyScrollView : NSView
{
	CGFloat iBase, iInc, iGap;
	NSFont *iFont;
	NSColor *iColor;
	int iType;
	MyViewData *iData;
    NSScroller *iScroll;
}

- (void)setMyViewData:(MyViewData *)data scrollBar:(NSScroller *)scroll;
- (void)setBaseData:(CGFloat)base inc:(CGFloat)inc;
- (NSSize)drawNum:(CGFloat)n pos:(NSPoint)pos;
- (CGFloat)displayNumber:(CGFloat)n;
- (void)checkUpdateData;

@end
