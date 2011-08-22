//
//  MySplashWindow.h
//  ToolBar
//
//  Created by 武村 健二 on 07/09/21.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyDrawIcon.h"


@interface MySplashIconView : NSView
{
	char *iFuncName;
	MyDrawIcon *iIcon;
}

- (void)setFuncName:(char *)func;

@end


@interface MySplashWindow : NSWindow
{
	CGFloat iAlphaAdd;
	CGFloat iInterval;
}

- (void)setInterval:(CGFloat)interval alpha:(CGFloat)add;
- (CGFloat)interval;
- (CGFloat)alphaAdd;
- (void)startSplash;

@end

@interface MySplashIconWindow : MySplashWindow
{
	MySplashIconView *iView;
}
- (void)setFuncName:(char *)func;

@end
