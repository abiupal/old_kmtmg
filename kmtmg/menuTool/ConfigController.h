//
//  configController.h
//  ToolBar
//
//  Created by 武村 健二 on 07/09/05.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyToolBar.h"
#import "configData.h"
// #import "FunctionController.h"

enum { CFGMODE_NOSELECT = 9100,
	   CFGMODE_DRAW, CFGMODE_EDIT, CFGMODE_PALETTE,
	   CFGMODE_WEAVING, CFGMODE_CARPET, CFGMODE_JLACE,
	   CFGMODE_RLACE, CFGMODE_SIMULATE, 
	   CFGMODE_MAX };

typedef struct
{
	NSMenu *m;
	ConfigData *d;
	NSInteger sub;
} MAKEMENU;

@interface ConfigController : NSObject
{
	NSString *iConfigPath;
	NSMutableArray *iArray;
	NSMutableArray *iTool[CFGMODE_MAX -CFGMODE_NOSELECT];
	MENU_PAGEINDEX iNow;
	// FunctionController *cntlFunc;
	NSInteger iMode, iMaxPage[CFGMODE_MAX -CFGMODE_NOSELECT];
	NSInteger iCheckInited;
	NSInteger iMenuItemNumberBeforeAdding, iMenuSub;
	BOOL iMenuEnabled;
}

+ (ConfigController *)sharedManager;
- (id)init;
- (void)setPath:(NSString *)path;
- (NSInteger)maxPage:(NSInteger)mode;
- (NSInteger)mode:(ConfigData *)d;
- (NSInteger)mode;
- (void)setMode:(NSInteger)m;
- (MENU_PAGEINDEX *)pageIndex;
- (NSArray *)tool:(NSInteger)mode;
- (void)function:(char *)cmd;
- (void)setMenuStatus:(BOOL)b;

@end
