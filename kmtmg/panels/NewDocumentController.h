/* NewDocumentController */

#import <Cocoa/Cocoa.h>
#import "../views/MyViewData.h"
#import "MyPanel.h"

@interface NewDocumentController : NSObject
{
    IBOutlet MyPanel *oPanel;
	NSString *iName;
	CGFloat iWidth, iHeight;
	NSColor *iBackground;
    BOOL bNewDocument;
}

@property BOOL bNewDocument;

+ (NewDocumentController *)sharedManager;

- (IBAction)background:(id)sender;
- (IBAction)disclogure:(id)sender;
- (IBAction)height:(id)sender;
- (IBAction)width:(id)sender;
- (IBAction)name:(id)sender;
- (IBAction)set:(id)sender;
- (IBAction)cancel:(id)sender;

- (void) setNewDocumentSetting:(MyViewData *)mvd;
- (BOOL) open;

@end
