//
//  configData.m
//  MenuConfig
//
//  Created by 武村 健二 on 07/09/03.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import "configData.h"
#import "../MyDefines.h"

@implementation ConfigData

- (id)initWithData:(const char *)data previous:(id)m
{
    self = [super init];
	if( self )
	{
		char str_buf[8][MAX_CONFIGTEXT], *p;
		memset( str_buf, 0, sizeof(str_buf) );
		sscanf( data,"%s %s %s %s %s %s %s",
				str_buf[0],
				str_buf[1], str_buf[2],
				str_buf[3], str_buf[4],
				str_buf[5], str_buf[6]);
		p = str_buf[0];
		iCfg.page = atoi( ++p );
		p = strchr( p, '-' );
		iCfg.index = atoi( ++p );
		p = str_buf[5];
		if( m != NULL && *p == '@' )
			iTool.page = [m toolPage];
		else
			iTool.page = atoi( p );
		p = str_buf[6];
		iTool.index = atoi( p );
		
		memset( iSuperMenu, 0, sizeof(iSuperMenu));
		if( m != NULL && str_buf[1][0] == '@' )
			strcat( iSuperMenu, [[m superMenu] UTF8String] );
		else
			strcat( iSuperMenu, str_buf[1] );
		memset( iFunc, 0, sizeof(iFunc));
		strcat( iFunc, str_buf[2] );
		if( !strncmp( iFunc, "SUBPAGE_", 8 ) )
			iSubPage = atoi( (iFunc +8) );
		
		memset( iMenu, 0, sizeof(iMenu));
		strcat( iMenu, str_buf[3] );
		iKey = 0;
		p = str_buf[4];
		if( !strncmp( p, "TOOLBAR", 7 ) )
			iKey = CFGKEY_TOOLBAR;
		else if( !strncmp( p, "ESC", 3 ) )
			iKey = CFGKEY_ESC;
		else if( !strncmp( p, "TAB", 3 ) )
			iKey = CFGKEY_TAB;
		else if( !strncmp( p, "CTRL+", 5 ) )
		{
			iKey = CFGKEY_CTRL;
			iKey += *(p +5);
		}
		iAdded = FALSE;
	}
	
	return self;
}

- (void)log
{
	MyLog( @"CFG  >> page:%d, index:%d", iCfg.page, iCfg.index );
	MyLog( @"SUPER > %@", [self superMenu] );
	MyLog( @"FUNC  > %s", iFunc );
	MyLog( @"MENU  > %@", [self menu] );
	switch( iKey )
	{
		case CFGKEY_TOOLBAR:
			MyLog( @"KEY  >> ToolBar" ); break;
		case CFGKEY_ESC:
			MyLog( @"KEY  >> Escape" ); break;
		case CFGKEY_TAB:
			MyLog( @"KEY  >> Tab" ); break;
		default:
			if( iKey & CFGKEY_CTRL )
				MyLog( @"KEY  >> CTRL+ %c", (iKey & 0xff) );
			else
				MyLog( @"KEY  >> %c", (iKey & 0xff) );
			break;
	}
	MyLog( @"TOOL >> page:%d, index:%d", iTool.page, iTool.index );
}

- (unsigned short)cfgPage
{
	return iCfg.page;
}

- (unsigned short)toolPage
{
	return iTool.page;
}

- (MENU_PAGEINDEX)tool
{
	return iTool;
}

- (NSString *)superMenu
{
	return [NSString stringWithUTF8String:iSuperMenu];
}
- (char *)func
{
	return iFunc;
}
- (NSString *)menu
{
	return [NSString stringWithUTF8String:iMenu];
}

- (BOOL)isAdded
{
	return iAdded;
}

- (void)setAdded:(BOOL)b
{
	iAdded = b;
}

- (int)subPage
{
	return iSubPage;
}

- (long)key
{
	return iKey;
}

@end
