//
//  configData.h
//  MenuConfig
//
//  Created by 武村 健二 on 07/09/03.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MAX_CONFIGTEXT 32
#define CFGKEY_ESC	0x1b
#define CFGKEY_TAB	0x09
#define CFGKEY_CTRL	0x0100
#define CFGKEY_TOOLBAR -1

typedef struct
{
	unsigned short page, index;
} MENU_PAGEINDEX;

@interface ConfigData : NSObject
{
	MENU_PAGEINDEX iCfg, iTool;
	char iSuperMenu[MAX_CONFIGTEXT];
	char iFunc[MAX_CONFIGTEXT];
	char iMenu[MAX_CONFIGTEXT];
	long iKey, iSubPage;
	BOOL iAdded;
}

- (id)initWithData:(const char *)data previous:(id)m;
- (unsigned short)cfgPage;
- (unsigned short)toolPage;
- (MENU_PAGEINDEX)tool;
- (NSString *)superMenu;
- (char *)func;
- (NSString *)menu;
- (BOOL)isAdded;
- (void)setAdded:(BOOL)b;
- (int)subPage;
- (long)key;
- (void)log;

@end
