//
//  MyAppDelegete.m
//  MyDoc
//
//  Created by 武村 健二 on 11/01/29.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyAppDelegate.h"
#import "MyDefines.h"
#import <IoCGS/MyOS.h>
#import "funcs/myDrawing.h"
#import "Preference.h"

@implementation MyAppDelegate

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
        // cntlCfg = [ConfigController sharedManager];
    }
    
    return self;
}

- (void)dealloc {
    // Clean-up code here.
    [super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application 
    BOOL boot = NO;
    SInt32 major, minor, bugFix;
    Gestalt( gestaltSystemVersionMajor, &major );
    Gestalt( gestaltSystemVersionMinor, &minor );
    Gestalt( gestaltSystemVersionBugFix, &bugFix );
    if( 10 <= major )
    {
        if( 6 < minor || (6 == minor && 8 <= bugFix) )
            boot = YES;
    }
    if( boot == NO )
    {
        [[MyOS sharedManager] alertMessage:@"Not boot on this Version." info:@"Bootable from Mac OSX 10.6.8."];
        [NSApp terminate:nil];
    }
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return NO;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	MyLog( @"applicationWillTerminate:%@ ",[self className] );
    
    myDraw_init();
}

#pragma mark - Menu

- (IBAction)openPreference:(id)sender
{
    Preference *pref = [Preference sharedManager];
    [pref open];
}

@end
