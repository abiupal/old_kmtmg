//
//  MyEditingManager.m
//  kmtmg
//
//  Created by 武村 健二 on 11/09/09.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyEditingManager.h"
#import "../MyDefines.h"
#import "../views/MyLayerView.h"
#import "../views/MyRubberView.h"

MyEditingManager *sharedMyEditingManager = NULL;

@implementation MyEditingManager

#pragma mark - Singleton

+ (MyEditingManager *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyEditingManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyEditingManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyEditingManager == Nil )
		{
			sharedMyEditingManager = [super allocWithZone:zone];
			return sharedMyEditingManager;
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
        // Initialization code here.  
    }
    
    return self;
}

#pragma  mark - funcs

- (void)setRubberMode
{
    if( MY_CMP(funcCommand, "TS_RESIZE_") )
    {
        [rubber setRubberType:RUBBER_RECT];
    }
    else
        [rubber setRubberType:RUBBER_NONE];
    
}

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv
{
    [super setCommand:cmd data:d rubber:rv];
        
    [self setRubberMode];
}

- (BOOL)moveCommandCheck
{
    BOOL ret = NO;
    
    if( MY_CMP(funcCommand, "TS_RESIZE_") )
        ret = YES;

    return ret;
}


- (void) dispatch
{
    BOOL cancel = YES;
    
    if( MY_CMP(funcCommand, "TS_RESIZE_") )
    {
        NSInteger n = atoi( funcCommand +10 );
        NSRect rect = [self rectFromPosition];
        rect.origin.x--;
        rect.origin.y--;
        [mvd changeRectPosition:rect backgroundImage:n];
        [self updateWindow];
    }
    
    if( cancel ) 
        [self cancel];
}


#pragma mark - Cancel

- (void)cancel
{
    [rubber cancel];
}

#pragma mark - Left Mouse

- (void)mouseDown:(NSPoint)po
{
    if( [super mouseDown:po] == NO ) return;
}

- (void)mouseUp:(NSPoint)po
{
    if( [super mouseUp:po] == NO )
        goto END_MOUSEUP;
    
    if( NSEqualPoints( [rubber startPoint], NSZeroPoint ) == NO )
    {
        pre = [rubber startPoint];
        [self dispatch];
    }
    else
        [rubber setPosition:pos];
    
    
END_MOUSEUP:
    [super mouseFinishedUp];
}

- (void)mouseDragged:(NSPoint)po
{
    if( [super mouseDragged:po] == NO ) return;
    
    pre = pos;
}

#pragma mark - Right Mouse

- (void)rightMouseDown:(NSPoint)po
{
    if( [super rightMouseDown:po] == NO ) return;
}


- (void)rightMouseUp:(NSPoint)po
{
    if( [super rightMouseUp:po] == NO ) return;
}

#pragma mark - Others Mouse

- (void)mouseMoved:(NSPoint)po
{    
    if( [self moveCommandCheck] == YES )
    {
        [rubber setEndPosition:po];
    }
}

@end
