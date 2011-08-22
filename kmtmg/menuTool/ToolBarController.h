/* ToolBarController */

#import <Cocoa/Cocoa.h>
#import "ConfigController.h"

@class MyToolBar;

@interface ToolBarController : NSResponder
{
    IBOutlet MyToolBar *oTool;
    IBOutlet NSWindow *oWindow;
    ConfigController *cntlCfg;
}

+ (ToolBarController *)sharedManager;
- (IBAction)aButton:(id)sender;
- (IBAction)aMode:(id)sender;
- (IBAction)aPage:(id)sender;
- (void)openToolBar;

@end
