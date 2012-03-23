//
//  MySelect4.m
//  kmtmg
//
//  Created by 武村 健二 on 11/08/03.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MySelect4.h"
#import "../MyDefines.h"
#import "../menuTool/MyDrawButton.h"
#import "MyPanel.h"

@implementation MySelect4

static MySelect4 *sharedMySelect4Manager = NULL;

#pragma mark - Singleton

+ (MySelect4 *)sharedManager
{
	@synchronized(self)
	{
		// MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMySelect4Manager == Nil )
			[[self alloc] init];
	}
	
	return sharedMySelect4Manager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMySelect4Manager == Nil )
		{
			sharedMySelect4Manager = [super allocWithZone:zone];
			return sharedMySelect4Manager;
		}
	}
	
	return Nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	MyLog( @"copyWithZone:%@ ",[self className] );
	
	return self;
}

- (id)retain
{
	MyLog( @"retain:%@ ",[self className] );
    
	return self;
}

- (NSUInteger)retainCount
{
	return UINT_MAX;
}

- (void)release
{
	MyLog( @"release:%@ ",[self className] );
}

- (id)autorelease
{
	MyLog( @"autorelease:%@ ",[self className] );
	
	return self;
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        [NSBundle loadNibNamed: @"Select4" owner:self];
    }
    
    return self;
}

- (NSInteger)openWithArray:(NSArray *)a
{
    MyDrawButtonFuncMenu *dbfm = nil;
    int i = 0;
    for( i = 0; i < [a count]; i++ )
    {
        dbfm = [a objectAtIndex:i];
        switch (i)
        {
            case 0: [s1 setFuncName:[dbfm funcCommand] menuName:dbfm.menuString]; break;
            case 1: [s2 setFuncName:[dbfm funcCommand] menuName:dbfm.menuString]; break;
            case 2: [s3 setFuncName:[dbfm funcCommand] menuName:dbfm.menuString]; break;
            case 3: [s4 setFuncName:[dbfm funcCommand] menuName:dbfm.menuString]; break;
        }
    }
    
    panel.tag = MYPANEL_INIT;
    
    return [NSApp runModalForWindow:panel];
}

- (IBAction)press:(id)sender
{
    [panel setTag:[sender tag]];
}

@end
