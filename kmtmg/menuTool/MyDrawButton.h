/* MyDrawButton */

#import <Cocoa/Cocoa.h>
#import "MyDrawIcon.h"

@interface MyDrawButtonFuncMenu : NSObject {
    NSString *menuString;
    char funcCommand[16];
}

- (id)initWithData:(const char *)f menu:(const char *)m;
- (char *)funcCommand;

@property(readonly,assign) NSString *menuString;

@end

@interface MyDrawButton : NSButton
{
	char *iFuncName;
	NSString *iMenuName;
	MyDrawIcon *iIcon;
    NSImage *iImage;
}

-(void) setFuncName:(char *)func menuName:(NSString *)menu;
-(char *)funcName;

@end
