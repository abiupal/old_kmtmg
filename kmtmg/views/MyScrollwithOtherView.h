/* MyScrollwithOtherView */

#import <Cocoa/Cocoa.h>
#import "MyViewData.h"

@class MyCursorView;

@interface MyScrollwithOtherView : NSScrollView
{
@private
	IBOutlet id oHSview;
    IBOutlet id oVSview;
	MyViewData *iData;
	NSPoint preScrollValue, startPosition;
    BOOL directScroll;
    
    MyCursorView *oCursor, *oRubber;
    NSCursor *cursor;
}

- (void)setMyViewData:(MyViewData *)data hsv:(id)hv vsv:(id)vv;
- (void)upScrollLine;
- (void)downScrollLine;
- (void)leftScrollLine;
- (void)rightScrollLine;
- (void)upScrollPage;
- (void)downScrollPage;
- (void)leftScrollPage;
- (void)rightScrollPage;
- (void)updateScrolledStartPosition:(NSPoint)start;
- (void)updateScrolledHSView:(CGFloat)x;
- (void)updateScrolledVSView:(CGFloat)y;

@property NSPoint startPosition;
@property(assign) MyCursorView *oCursor, *oRubber;

@end
