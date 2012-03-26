/* MyToolBar */

#import <Cocoa/Cocoa.h>
#import "MyDrawButton.h"
#import "MyPanel.h"

@class ToolBarController;

@interface MyToolBar : MyPanel
{
	NSArray *cntlCfgs;
    ToolBarController *tc;
}

-(void) pressSpaceKey;
-(void) pressTabKey;

-(MyDrawButton *) buttonMode:(int)mode;
-(MyDrawButton *) buttonFunc:(int)index;
-(void) updatePage;
-(void) setConfigArray:(NSArray *)array;
-(void) setPageMax:(int)m;
-(NSString *)menuForFunc:(char *)func;

@property(assign) ToolBarController *tc;

@end
