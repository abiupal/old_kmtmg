//
//  ConfigController.m
//  ToolBar
//
//  Created by 武村 健二 on 07/09/05.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import "ConfigController.h"
#import "MySplashWindow.h"
#import "../panels/MyInfo.h"
#import "../MyDefines.h"

@interface MyMenuItem : NSMenuItem
{
	char *cpFunc;
}
- (id)init;
- (void)setFunc:(char *)f;
- (char *)func;
@end

@implementation MyMenuItem
- (id)init
{
	self = [super init];
	if( self )
	{
		cpFunc = NULL;
	}
	
	return self;
}
- (void)setFunc:(char *)f
{
	cpFunc = f;
}
- (char *)func
{
	return cpFunc;
}

@end

static ConfigController *sharedConfigControllerManager = NULL;

@implementation ConfigController
		
+ (ConfigController *)sharedManager
{
	@synchronized(self)
	{
		if( sharedConfigControllerManager == Nil )
			[[self alloc] init];
	}
	
	return sharedConfigControllerManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedConfigControllerManager == Nil )
		{
			sharedConfigControllerManager = [super allocWithZone:zone];
			return sharedConfigControllerManager;
		}
	}
	
	return Nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return UINT_MAX;
}
- (void)release
{
}
- (id)autorelease
{
	return self;
}

#pragma mark - Check and Add Menu

- (void)checkMaxPageForToolBar
{
	NSInteger i, m;
	ConfigData *d;
	
	for( i = CFGMODE_NOSELECT; i < CFGMODE_MAX; ++i )
		iTool[i -CFGMODE_NOSELECT] = [[NSMutableArray array] retain];
	
    for( d in iArray )
	{
		if( [d key] != CFGKEY_TOOLBAR ) continue;
		m =  [self mode:d] -CFGMODE_NOSELECT;
		[iTool[m] addObject:d];
		if( iMaxPage[m] < [d toolPage] )
			iMaxPage[m]++;
	}
	for( i = CFGMODE_NOSELECT; i < CFGMODE_MAX; ++i )
	{
		MyLog( @"Mode:%4d > Index:%lu, MaxPage:%d", i, [[self tool:i] count], [self maxPage:i] );
		if( iMode == CFGMODE_NOSELECT && [self maxPage:i] )
		{
			iMode = i;
			iNow.page = 1;
			iNow.index = 1;
		}
	}
}


- (void)checkFunction:(id)sender
{
	MyLog( @"checkFunction >> %s", [sender func] );
	[self function:[sender func]];
}

- (void)addMenuItem:(MAKEMENU *)mm
{
	MyMenuItem *item;
	
	item = [[MyMenuItem allocWithZone:[NSMenu menuZone]] init];
	[item setFunc:[mm->d func]];
	[item setTitle:[mm->d menu]];
	[item setTarget:self];
	[item setAction:@selector( checkFunction: ) ];
	[item setEnabled:iMenuEnabled];
	// setKey
    if( [mm->d key] == CFGKEY_TOOLBAR )
    {
    }
    else
    {
        [item setKeyEquivalent:[NSString stringWithFormat:@"%c",(char)[mm->d key]]];
    }
    if( !([mm->d key] & CFGKEY_CTRL) )
        [item setKeyEquivalentModifierMask:0];
	[mm->m addItem:item];
	[item release];
    
    MyLog(@"%s, %@, menuEnabled:%d", [mm->d func], [mm->d menu], iMenuEnabled );
	
	[mm->d setAdded:TRUE];
}

- (void)addMenu:(MAKEMENU *)mm
{
	NSMenu *menu;
	NSMenuItem *item;
	
	if( !mm->sub )
	{
		// Top Menu
		item = [mm->m itemWithTitle:[mm->d superMenu]];
		if( item == Nil )
		{
			item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
				initWithTitle:[mm->d superMenu]
				action:NULL keyEquivalent:@""];
			menu = mm->m;
			mm->m = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[mm->d superMenu]];
			[mm->m setAutoenablesItems:NO];
			[item setSubmenu:mm->m];
			[mm->m release];
			[menu addItem:item];
			[menu setAutoenablesItems:NO];
			[item release];
		}
		else
			mm->m = [item submenu];
	}
	if( 0 < [mm->d subPage] )
	{
		int i = 0;
		MAKEMENU mm_sub;
		memset( &mm_sub, 0, sizeof(mm_sub));
		mm_sub.sub = 1;
		// Sub Menu in Top Menu
		item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle:[mm->d menu]
			action:NULL keyEquivalent:@""];
		mm_sub.m = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[mm->d menu]];
		[mm_sub.m setAutoenablesItems:NO];		
		[item setSubmenu:mm_sub.m];
		[mm_sub.m release];
		[mm->m addItem:item];
		[item release];
		[mm->d setAdded:TRUE];
		for( ; i < [iArray count]; ++i )
		{
			mm_sub.d = [iArray objectAtIndex:i];
			if( [mm_sub.d isAdded] == TRUE ) continue;
			if( [mm_sub.d cfgPage] != [mm->d subPage] ) continue;
			[self addMenu:&mm_sub];
		}
	}
	else
		[self addMenuItem:mm];
}

- (void)checkMenuItem:(id)item
{
	MyLog( @"cMI >>>> :%@, %s", [item title], [item func]);
	if( [item func] != nil )
		[item setEnabled:iMenuEnabled];
}

- (void)checkMenu:(NSMenu *)menu
{
	NSInteger i, start, max = [menu numberOfItems];
	NSMenuItem *item;
	
	if( menu == [NSApp mainMenu] )
	{
		start = iMenuItemNumberBeforeAdding;
	}
	else start = 0;
	MyLog( @"cM >> :%@", [menu title] );
	for( i = start; i < max; ++i )
	{
		item = [menu itemAtIndex:i];
		MyLog( @"cM[%2d]:%d", iMenuSub, i );
		if( [item hasSubmenu] == YES )
		{
			iMenuSub++;
			[self checkMenu:[item submenu]];
		}
		else
			[self checkMenuItem:item];
	}

}

- (void)checkMenus
{
	iMenuSub = 1;
	[self checkMenu:[NSApp mainMenu]];
}

- (void)addMenus;
{
	NSInteger i = 0;
	MAKEMENU mm;
	
	if( iArray == Nil ) return;
	
	NSMenu *main = [NSApp mainMenu];
	iMenuItemNumberBeforeAdding = [main numberOfItems];
	 
	memset( &mm, 0, sizeof(mm) );
	for( ; i < [iArray count]; ++i )
	{
		mm.d = [iArray objectAtIndex:i];
		if( [mm.d isAdded] == TRUE ) continue;
		mm.m = main;
		[self addMenu:&mm];
	}
	[self checkMenus];
}

- (void)readConfig
{
	ConfigData *d, *pre;
	FILE *fp = NULL;
	char *p, buf[256];
	
	memset( &buf, 0, sizeof(buf) );
	fp = fopen( [iConfigPath UTF8String], "rb" );
	if( fp == NULL )
	{
		/*
		system( "pwd > tmp.txt" );
		fp = fopen( "tmp.txt", "r" );
		p = fgets( buf, 255, fp );
		fclose( fp );*/
		NSAlert *alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:[NSString stringWithFormat:@"Could not find %s at %s.", [iConfigPath UTF8String], p] ];
		[alert setInformativeText:@"Not Found Config File for menu information."];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert runModal];
		[alert release];
		return;
	}
	iArray = [[NSMutableArray array] retain];

	d = pre = NULL;
	for( ;; )
	{
		p = fgets( buf, 255, fp );
		if( p == NULL ) break;
		if( *p != '_' ) continue;
		
		d = [[ConfigData alloc] initWithData:p previous:pre];
		[iArray addObject:d];
		pre = d;
	}
	
}

#pragma mark - init

-(id) init
{
	self = [super init];
	if( self )
	{
		iCheckInited = 0;
		iArray = Nil;
		int i;
		for( i = CFGMODE_NOSELECT; i < CFGMODE_MAX; ++i )
			iTool[i -CFGMODE_NOSELECT] = Nil;
		iNow.page = -1;
		iNow.index = -1;
		iMode = CFGMODE_NOSELECT;
		memset( &iMaxPage[0], 0, sizeof(iMaxPage) );
		// Function Controller
		// cntlFunc = [FunctionController sharedManager];
		iMenuEnabled = YES;
	}
	
	return self;
}

-(void) setPath:(NSString *)path
{
	if( !iCheckInited )
	{
		iConfigPath = path;
		[self readConfig];
		[self addMenus];
		[self checkMaxPageForToolBar];
	}
}

- (void)dealloc
{
	int i;
	for( i = CFGMODE_NOSELECT; i < CFGMODE_MAX; ++i )
			[iTool[i -CFGMODE_NOSELECT] release];
	[iArray release];
	[super dealloc];
}


- (MENU_PAGEINDEX *)pageIndex
{
	return &iNow;
}


- (NSInteger)maxPage:(NSInteger)mode
{
	mode -= CFGMODE_NOSELECT;
	if( mode < 0 ) mode = 0;
	if( CFGMODE_MAX <= mode ) mode = 0;
	
	return iMaxPage[mode];
}

- (NSInteger)mode:(ConfigData *)d
{
	int mode = CFGMODE_NOSELECT;
	
	if( MY_CMP( [d func], "D_" ) )
		mode = CFGMODE_DRAW;
	else if( MY_CMP( [d func], "E_" ) )
		mode = CFGMODE_EDIT;
	else if( MY_CMP( [d func], "P_" ) )
		mode = CFGMODE_PALETTE;
	else if( MY_CMP( [d func], "W_" ) )
		mode = CFGMODE_WEAVING;
	else if( MY_CMP( [d func], "C_" ) )
		mode = CFGMODE_CARPET;
	else if( MY_CMP( [d func], "J_" ) )
		mode = CFGMODE_JLACE;
	else if( MY_CMP( [d func], "R_" ) )
		mode = CFGMODE_RLACE;
	else if( MY_CMP( [d func], "S_" ) )
		mode = CFGMODE_SIMULATE;
		
	return mode;
}

- (NSInteger)mode
{
	return iMode;
}

- (void)setMode:(NSInteger)m
{
	if( m < CFGMODE_NOSELECT ) return;
	if( CFGMODE_MAX <= m ) return;
	
	iMode = m;
}

- (NSArray *)tool:(NSInteger)mode
{
	mode -= CFGMODE_NOSELECT;
	if( mode < 0 ) mode = 0;
	if( CFGMODE_MAX <= mode ) mode = 0;
	
	return iTool[mode];
}

- (void)funcCommandTimer:(NSTimer *)timer
{
    NSData *cmd = [timer userInfo];
    [[MyInfo sharedManager] setFunction:(char *)[cmd bytes]];
    
    if( [NSApp mainWindow] != nil )
    {
        [[[NSApp mainWindow] windowController] functionCommand:(char *)[cmd bytes]];
    }

}

- (void)function:(char *)cmd
{
    /*
    MyDrawIcon *drawIcon = [MyDrawIcon sharedManager];
	if( [drawIcon hasIcon:cmd] == YES )
	{
		int n = 128;
		NSRect screen = [[NSScreen mainScreen] visibleFrame];
		NSPoint center = NSMakePoint( screen.size.width /2, screen.size.height /2 );
		screen = NSMakeRect(center.x -n, center.y -n, n * 2, n * 2);
		MySplashIconWindow *splash;
		splash = [[MySplashIconWindow alloc] initWithContentRect:screen
                                                       styleMask:NSBorderlessWindowMask 
                                                         backing:NSBackingStoreBuffered 
                                                           defer:NO];
		[splash retain];
        
		[splash setInterval:0.05 alpha:-0.05];
		[splash setFuncName:cmd];
		[splash startSplash];
	}
    [NSTimer scheduledTimerWithTimeInterval:0.6
                                     target:self
                                   selector:@selector(funcCommandTimer:)
                                   userInfo:[NSData dataWithBytes:cmd length:strlen(cmd)]
                                    repeats:NO];
     */
    [[MyInfo sharedManager] setFunction:cmd];
    
    if( [NSApp mainWindow] != nil )
    {
        [[[NSApp mainWindow] windowController] functionCommand:cmd];
    }
    
}

- (void)setMenuStatus:(BOOL)b
{
	if( iMenuEnabled == b ) return;
	
	iMenuEnabled = b;
	[self checkMenus];
}

@end
