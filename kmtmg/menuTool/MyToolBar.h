/* MyToolBar */

#import <Cocoa/Cocoa.h>
#import "MyDrawButton.h"
#import "MyPanel.h"

@interface MyToolBar : MyPanel
{
	NSArray *cntlCfgs;
}

-(IBAction) pressSpace:(id)sender;

-(MyDrawButton *) buttonMode:(int)mode;
-(MyDrawButton *) buttonFunc:(int)index;
-(void) updatePage;
-(void) setConfigArray:(NSArray *)array;
-(void) setPageMax:(int)m;
-(NSString *)menuForFunc:(char *)func;

@end
