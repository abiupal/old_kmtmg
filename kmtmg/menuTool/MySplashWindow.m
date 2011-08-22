//
//  MySplashWindow.m
//  ToolBar
//
//  Created by 武村 健二 on 07/09/21.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import "MySplashWindow.h"


@implementation MySplashIconView

- (BOOL)isFlipped
{
	return YES;
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(NSRect)rect
{
    [[NSColor clearColor] set];
   // [NSBezierPath fillRect:rect];
	[iIcon drawRect:rect func:iFuncName];
}

- (void)setFuncName:(char *)func
{
	iFuncName = func;
	iIcon = [MyDrawIcon sharedManager];
}

@end


@implementation MySplashWindow

- (void)updateSplashTimer:(NSTimer*)timer
{
	MySplashWindow *w = [timer userInfo];
	CGFloat f = [w alphaValue];
		
	if( f )
	{
		f += [w alphaAdd];
        // MyLog(@"Alpha:%.3f", f);
		if( f < 0.0 ) f = 0.0;
		if( 1.0 < f ) f = 1.0;
		[w setAlphaValue:f];
		[w flushWindow];
		[NSTimer scheduledTimerWithTimeInterval:[w interval]
                                         target:w
                                       selector:@selector(updateSplashTimer:)
                                       userInfo:w
                                        repeats:NO];
	}
	else
	{
		[w close];
	}
}

- (CGFloat)interval
{
	return iInterval;
}

- (CGFloat)alphaAdd
{
	return iAlphaAdd;
}

- (void)setInterval:(CGFloat)interval alpha:(CGFloat)reduce
{
	iInterval = interval;
	iAlphaAdd = reduce;
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)startSplash
{	
    [self setLevel:NSFloatingWindowLevel];
    [self setReleasedWhenClosed:YES];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setOpaque:NO];
    [self setHasShadow:NO];
    [self orderFrontRegardless];
    
    [self display];
	
	[NSTimer scheduledTimerWithTimeInterval:iInterval
                                 target:self
                               selector:@selector(updateSplashTimer:)
                               userInfo:self
                                repeats:NO];
}

@end

@implementation MySplashIconWindow

-(void) dealloc
{
	[iView release];
	[super dealloc];
}

- (void)setFuncName:(char *)func
{
	iView = [[MySplashIconView alloc] initWithFrame:[self frame]];
	if( iView != NULL )
	{
		[iView retain];
		[iView setBounds:NSMakeRect(0,0,128,128)]; // Icon Size
		[iView setFuncName:func];
		[self setContentView:iView];
	}
}

@end

