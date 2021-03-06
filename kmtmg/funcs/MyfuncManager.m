//
//  MyfuncManager.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/08.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "MyfuncManager.h"
#import "../views/MyViewData.h"
#import "../MyDefines.h"
#import "../views/MyRubberView.h"

@implementation MyfuncManager

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        enabled = NO;
        locked = NO;
        mvd = nil;
        pre = NSMakePoint(-9999, -9999);
        rightPos = pre;
        down = pre;
        memset( funcCommand, 0, sizeof(funcCommand));
    }
    
    return self;
}

- (char *)funcCommand
{
    return &funcCommand[0];
}

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv
{
    if( locked == YES ) return;
    
    mvd = d;
    rubber = rv;
    if( cmd != &funcCommand[0] )
    {
        memset( funcCommand, 0, sizeof(funcCommand));
        strcat( funcCommand, cmd );
    }
    enabled = YES;
    locked = NO;
}

- (BOOL)isEnabled
{
    return enabled;
}

- (void)disabled
{
    enabled = NO;
    [rubber setRubberType:RUBBER_NONE];
}

#pragma mark - Left Mouse

- (BOOL)mouseDown:(NSPoint)po
{
    if( enabled == NO ) return NO;
    
    if( locked == YES || strlen(funcCommand) < 2 ) return NO;
    
    locked = YES;
    
    pos = po;
    down = pos;
    pre = pos;
    
    return YES;
}

- (BOOL)mouseUp:(NSPoint)po
{
    if( enabled == NO ) return NO;
    
    if( locked == NO || strlen(funcCommand) < 2 ) return NO;
    
    pos = po;
    if( NSEqualPoints( down, pos ) == NO ) return NO;
        
    return YES;
}

- (BOOL)mouseDragged:(NSPoint)po
{
    if( enabled == NO ) return NO;
    
    if( locked == NO || strlen(funcCommand) < 2 ) return NO;
    
    pos = po;
    if( NSEqualPoints(pre, pos) == YES ) return NO;

    return YES;
}

#pragma mark - Right Mouse

- (BOOL)rightMouseDown:(NSPoint)po
{
    if( enabled == NO ) return NO;
    
    if( locked == YES || strlen(funcCommand) < 2 ) return NO;
        
    return YES;
}

- (BOOL)rightMouseUp:(NSPoint)po
{
    if( enabled == NO ) return NO;
    
    if( locked == NO || strlen(funcCommand) < 2 ) return NO;
        
    if( NSEqualPoints( rightPos, po ) == NO ) return NO;
    
    return YES;
}


#pragma mark - Others Mouse

- (void)mouseFinishedUp
{
    pre = NSMakePoint(-9999, -9999);
    down = rightPos = pre;
    locked = NO;
    
    MyLog(@"mouseFinishedUp");
}

#pragma mark - funcs

- (NSRect)rectFromPosition
{
    NSPoint st,ed;
    
    if (pre.x <= pos.x )
    {
        st.x = pre.x;
        ed.x = pos.x;
    }
    else
    {
        st.x = pos.x;
        ed.x = pre.x;
    }
    
    if( pre.y <= pos.y )
    {
        st.y = pre.y;
        ed.y = pos.y;
    }
    else
    {
        st.y = pos.y;
        ed.y = pre.y;
    }
    
    return NSMakeRect(st.x, st.y, (ed.x -st.x +1), (ed.y -st.y +1));
}

- (void)updateWindow
{
    if( [NSApp mainWindow] != nil )
    {
        [[[NSApp mainWindow] windowController] checkUpdateData];
    }
}

- (NSInteger)checkPositionSelectedType
{
    NSInteger type = PositionSelectedType_INVALID;
    
    if( pre.x < pos.x )
    {
        if( pre.y < pos.y )
            type = PositionSelectedType_LD2RU;
        else
            type = PositionSelectedType_LU2RD;
    }
    else if( pre.y < pos.y )
        type = PositionSelectedType_RD2LU;
    else
        type = PositionSelectedType_RU2LD;
    
    return type;
}


@end
