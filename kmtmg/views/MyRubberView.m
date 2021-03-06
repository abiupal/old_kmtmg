//
//  MyRubberView.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/25.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyRubberView.h"
#import "MyViewData.h"
#import "../MyDefines.h"
#import "../panels/MyInfo.h"
#import "../funcs/myDrawing.h"
#import "NSMutableAttributedString+MyModify.h"

@implementation MyRubberView

#pragma mark - Init

- (id)init
{
    self = [super init];
    if( self != nil )
    {
        rect = NSZeroRect;
        end = NSZeroPoint;
        type = -1;
    }
    
    return self;
}

- (void)dealloc
{
    [iColor release];
    
    [super dealloc];
}

- (void)setRubberType:(NSInteger)newType
{
    if( type == newType ) return;
    if( newType < RUBBER_NONE ) return;
    if( RUBBER_MAX <= newType ) return;
    
    rect = NSZeroRect;
    end = NSZeroPoint;
    
    type = newType;
    if (type & RUBBER_XSAGON)
    {
        myDraw_sincos( type & RUBBER_MASK );
    }
    
    if( iFont == nil )
        iFont = [[MyInfo sharedManager] rubberFont];
    if( iColor == nil )
        iColor = [[NSColor colorWithCalibratedWhite:1.0 alpha:0.9] retain];
    
    [self setNeedsDisplay:YES];
}

- (NSInteger)typeMask
{
    return type & RUBBER_MASK;
}

#pragma mark - func

- (void)cancel
{
    if( type & RUBBER_LINE || type & RUBBER_RECT )
    {
        rect = NSZeroRect;
        end = NSZeroPoint;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Position

- (NSPoint)startPoint
{
    return rect.origin;
}

- (void)setStartPosition:(NSPoint)pos
{
    if( NSEqualPoints(rect.origin, pos) == YES ) return;
    
    rect.origin = pos;
}

- (void)setEndPosition:(NSPoint)pos
{
    if( NSEqualPoints(rect.origin, NSZeroPoint) == YES ) return;
    if( NSEqualPoints(end, pos) == YES ) return;
    
    rect.size.width = (pos.x - rect.origin.x +1);
    if( rect.size.width < 1 ) rect.size.width -= 2;
    
    rect.size.height = (pos.y - rect.origin.y +1);
    if( rect.size.height < 1 ) rect.size.height -= 2;
    
    end = pos;
    
    [self setNeedsDisplay:YES];
}

- (void)setPosition:(NSPoint)pos
{
    [super setPosition:pos];
    
    if ( NSEqualPoints(rect.origin,NSZeroPoint) == YES)
    {
        [self setStartPosition:pos];
    }
    else
    {
        [self setStartPosition:end];
        [self setEndPosition:pos];
    }
}

#pragma mark - Draw

- (void)drawInfo
{
    NSInteger numOfString = 3;
	NSMutableAttributedString *str1, *str2, *str3;
    
    str1 = [[NSMutableAttributedString alloc] 
              initWithString:
              [NSString stringWithFormat:@"S:%d,%d E:%d,%d px",
               (NSInteger)rect.origin.x, (NSInteger)rect.origin.y,
               (NSInteger)end.x, (NSInteger)end.y]];
    str2 = [[NSMutableAttributedString alloc] 
              initWithString:
              [NSString stringWithFormat:@"W:%d H:%d px",
               (NSInteger)rect.size.width, (NSInteger)rect.size.height]];
    
    NSPoint po = NSZeroPoint;
    if( rect.size.width < rect.size.height )
        po.y = rect.size.height - rect.size.width;
    else
        po.x = rect.size.width - rect.size.height;
    str3 = [[NSMutableAttributedString alloc] 
            initWithString:
            [NSString stringWithFormat:@"x:%d y:%d on Zero",
             (NSInteger)(po.x), (NSInteger)(po.y)]];
    
    [str1 changeStringColor:iColor withFont:[NSFont boldSystemFontOfSize:14]];
    [str2 changeStringColor:iColor withFont:[NSFont boldSystemFontOfSize:14]];
    [str3 changeStringColor:iColor withFont:[NSFont boldSystemFontOfSize:14]];
    	
	NSSize size = [str1 size];
    
    [[NSColor colorWithCalibratedWhite:0.2 alpha:0.6] set];
    
    NSPoint pos = [self viewPointFromImagePoint:end];
    pos.x += size.height * 2;
    pos.y += size.height * numOfString + (size.height /2);
    
    NSRect textBackground = NSMakeRect(
                                pos.x -size.height,
                                pos.y - (size.height /2),
                                size.width +size.height * 2,
                                size.height * (numOfString +1) );
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path appendBezierPathWithRoundedRect:textBackground xRadius:10 yRadius:10];
    [path fill];
    [path stroke];
    
    [str1 drawAtPoint:pos];
    pos.y += size.height;
    [str2 drawAtPoint:pos];
    pos.y += size.height;
    [str3 drawAtPoint:pos];
    
    [str1 release];
    [str2 release];
    [str3 release];
}

- (void)plotCircle:(CGContextRef)cg center:(NSPoint)pos
{
    NSRect circleRect = NSOffsetRect( NSMakeRect( -4, -4, 8, 8 ), pos.x, pos.y );

    [[NSColor greenColor] set];
    CGContextFillEllipseInRect( cg,  NSRectToCGRect(circleRect) );
    
    
    circleRect = NSOffsetRect( NSMakeRect( -3, -3, 6, 6 ), pos.x, pos.y );
    [[NSColor redColor] set];
    CGContextFillEllipseInRect( cg,  NSRectToCGRect(circleRect) );
}

#pragma mark - Xsagon

- (void)xsagonNum:(int)n cgc:(CGContextRef)cg center:(NSPoint)cp outside:(NSPoint)op
{
    
    NSInteger i;    
    myDraw_xsagon(n, cp.x, cp.y, op.x, op.y );
    MYPOINT *po = myDraw_poolPoint();
    if( po == NULL )
    {
        return;
    }
    
    for( i = 0; i < n -1; i++ )
    {
        po[i].x += cp.x;
        po[i].y += cp.y;
    }

    CGContextMoveToPoint( cg, op.x, op.y);
	for( i = 0; i < n -1; i++ )
	{
        CGContextAddLineToPoint( cg, po[i].x, po[i].y );
	}
    CGContextAddLineToPoint( cg, op.x, op.y);
}

#pragma mark - drawRect

- (void)drawRect:(NSRect)dirtyRect
{
    /* [[NSColor clearColor] set];
    NSRectFill(dirtyRect); */
        
    if( NSEqualPoints(end, NSZeroPoint) == YES ) return;
    
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
    // [gc setShouldAntialias:NO];
    CGContextRef cg = [gc graphicsPort];
    
    NSPoint st = [self viewPointFromImagePoint:rect.origin];
    NSPoint ed = [self viewPointFromImagePoint:end];
    // MyLog(@"%@,%@", NSStringFromPoint(st),NSStringFromPoint(ed));
    
    const CGFloat dashStyle[] = {3.0};
    
    if ( type & RUBBER_XSAGON )
    {
        [[NSColor blackColor] set];
        CGContextSetLineWidth(cg, 1.0);
        CGContextSetLineDash(cg, 0.0, dashStyle, 1); 

        [self xsagonNum:[self typeMask] cgc:cg center:st outside:ed];
        CGContextStrokePath(cg);
        
        [[NSColor whiteColor] set];
        CGContextSetLineDash(cg, 3.0, dashStyle, 1);  
        
        [self xsagonNum:[self typeMask] cgc:cg center:st outside:ed];
        CGContextStrokePath(cg);
    }
    
    if( type & RUBBER_LINE )
    {        
        [[NSColor blackColor] set];
        CGContextSetLineWidth(cg, 1.0);
        
        CGContextSetLineDash(cg, 0.0, dashStyle, 1); 
        
        CGContextMoveToPoint(cg, st.x, st.y);
        CGContextAddLineToPoint(cg, ed.x, ed.y);
        CGContextStrokePath(cg);
        
        [[NSColor whiteColor] set];
        CGContextSetLineDash(cg, 3.0, dashStyle, 1);  
        
        CGContextMoveToPoint(cg, st.x, st.y);
        CGContextAddLineToPoint(cg, ed.x, ed.y);
        CGContextStrokePath(cg);
        
        [gc setShouldAntialias:YES];
        
        [self plotCircle:cg center:st];
        [self plotCircle:cg center:ed];
        [self drawInfo];
    }
    else if( type & RUBBER_RECT )
    {
        CGFloat x, y, w, h;
        if( st.x <= ed.x )
        {
            x = st.x;
            w = (ed.x -st.x +1);
        }
        else
        {
            x = ed.x;
            w = (st.x -ed.x +1);
        }
        if( st.y <= ed.y )
        {
            y = st.y;
            h = (ed.y -st.y +1);
        }
        else
        {
            y = ed.y;
            h = (st.y -ed.y +1);
        }
        CGRect selected = CGRectMake(x, y, w, h);
        
        if( flag == NO )
            CGContextSetRGBStrokeColor(cg, 0, 0, 0, 1.0);
        else
            CGContextSetRGBStrokeColor(cg, 1, 1, 1, 1.0);
        CGContextSetLineWidth(cg, 1.0);
        CGContextSetLineDash(cg, 0.0, dashStyle, 1); 
        CGContextStrokeRect(cg, selected);
        
        if( type & RUBBER_CIRCLE )
        {
            CGContextStrokeEllipseInRect(cg, selected);
        }
        else if( type & RUBBER_HISI )
        {
            CGContextMoveToPoint(cg, x + w /2, y);
            CGContextAddLineToPoint(cg, x + w, y + h /2);
            CGContextAddLineToPoint(cg, x + w /2, y + h);
            CGContextAddLineToPoint(cg, x, y + h /2);
            CGContextAddLineToPoint(cg, x + w /2, y);
            CGContextStrokePath(cg);
        }

        if( flag == YES )
            CGContextSetRGBStrokeColor(cg, 0, 0, 0, 1.0);
        else
            CGContextSetRGBStrokeColor(cg, 1, 1, 1, 1.0);
        CGContextSetLineDash(cg, 3.0, dashStyle, 1);  
        CGContextStrokeRect(cg, selected );
        
        if( type & RUBBER_CIRCLE )
        {
            CGContextStrokeEllipseInRect(cg, selected);
        }
        else if( type & RUBBER_HISI )
        {
            CGContextMoveToPoint(cg, x + w /2, y);
            CGContextAddLineToPoint(cg, x + w, y + h /2);
            CGContextAddLineToPoint(cg, x + w /2, y + h);
            CGContextAddLineToPoint(cg, x, y + h /2);
            CGContextAddLineToPoint(cg, x + w /2, y);
            CGContextStrokePath(cg);
        }

        
        // [gc setShouldAntialias:YES];
        
        [self plotCircle:cg center:st];
        [self plotCircle:cg center:ed];
        
        [self drawInfo];
    }
    
    [gc restoreGraphicsState];
    
    flag = (flag ? NO : YES);
}

@end
