//
//  Preference.m
//  kmtmg
//
//  Created by 武村 健二 on 11/10/27.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "Preference.h"
#import "NSMatrix+MyModify.h"

@implementation Preference

static Preference *sharedPreferenceManager = NULL;

#pragma mark - Singleton

+ (Preference *)sharedManager
{
	@synchronized(self)
	{
		// MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedPreferenceManager == Nil )
			[[self alloc] init];
	}
	
	return sharedPreferenceManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedPreferenceManager == Nil )
		{
			sharedPreferenceManager = [super allocWithZone:zone];
			return sharedPreferenceManager;
		}
	}
	
	return Nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	// MyLog( @"copyWithZone:%@ ",[self className] );
	
	return self;
}

- (id)retain
{
	// MyLog( @"retain:%@ ",[self className] );
    
	return self;
}

- (NSUInteger)retainCount
{
	return UINT_MAX;
}

- (void)release
{
	// MyLog( @"release:%@ ",[self className] );
}

- (id)autorelease
{
	// MyLog( @"autorelease:%@ ",[self className] );
	
	return self;
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if( self )
    {
        [NSBundle loadNibNamed:@"Preference" owner:self];
    }
    
    return self;
}

- (BOOL)open
{
    [bootOptions changeColorString:[NSColor whiteColor]];
    [defaultPalette changeColorString:[NSColor whiteColor]];
    [keepDrawImage changeColorString:[NSColor whiteColor]];
    
    return [NSApp runModalForWindow:oPanel];
}

- (IBAction)cancel:(id)sender
{
    [oPanel setTag:NO];
}

- (IBAction)set:(id)sender
{
	
	
    [oPanel setTag:YES];
}

- (IBAction)selectedKeepDrawImage:(id)sender
{
    NSInteger selected = [sender selectedRow];
    if( !selected )
    {
        [drawImageFolder setEnabled:NO];
        [btnSelectDrawImageFolder setEnabled:NO];
        [btnSet setEnabled:YES];
    }
    else
    {
        [drawImageFolder setEnabled:YES];
        [btnSelectDrawImageFolder setEnabled:YES];
        
        if( [[drawImageFolder stringValue] length] < 2 )
            [btnSet setEnabled:NO];
        else
            [btnSet setEnabled:YES];
    }
}


@end
