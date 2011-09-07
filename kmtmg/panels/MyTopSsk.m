//
//  MyTopSsk.m
//  kmtmg
//
//  Created by 武村 健二 on 11/09/06.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyTopSsk.h"
#import "../MyDefines.h"


static MyTopSsk     *sharedMyTopSskManager = NULL;

@implementation MyTopSsk

#pragma mark - Singleton

+ (MyTopSsk *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyTopSskManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyTopSskManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyTopSskManager == Nil )
		{
			sharedMyTopSskManager = [super allocWithZone:zone];
			return sharedMyTopSskManager;
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

@end
