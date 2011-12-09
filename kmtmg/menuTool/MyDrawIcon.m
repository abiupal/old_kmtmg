//
//  MyDrawIcon.m
//  ToolBar
//
//  Created by 武村 健二 on 07/09/07.
//  Copyright 2007 Oriya Inc. All rights reserved.
//

#import "MyDrawIcon.h"

static MyDrawIcon *sharedMyDrawIconManager = NULL;
static NSShadow *gShadow = NULL;

#define MY_CMP( A, B ) ( !strncmp( A, B, strlen(B)) ? 1 : 0 )

@implementation MyDrawIcon
		
+ (MyDrawIcon *)sharedManager
{
	@synchronized(self)
	{
		if( sharedMyDrawIconManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyDrawIconManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyDrawIconManager == Nil )
		{
			sharedMyDrawIconManager = [super allocWithZone:zone];
			return sharedMyDrawIconManager;
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

#pragma mark - Init

- (id)init
{
    self = [super init];
    if( self != nil )
    {
        int n = 1;
        cursorImage = [[NSImage alloc] initWithSize:NSMakeSize(n, n)];
        [cursorImage lockFocus];
        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        
        [gc setShouldAntialias:NO];
        NSRectFill( NSMakeRect(0, 0, 1, 1) );
        [gc restoreGraphicsState];

        [cursorImage unlockFocus];
    }
    
    return self;
}

- (void)dealloc
{
    [cursorImage release];
    
    [super dealloc];
}

- (NSImage *)cursorImage
{
    return cursorImage;
}

#pragma mark - Shadow

- (void)setOnShadow
{
	if( gShadow == NULL )
	{
		gShadow = [[ NSShadow new ] retain];
		[gShadow setShadowOffset : NSMakeSize( 8, -8 ) ]; 
		[gShadow setShadowBlurRadius : 5 ];
		[gShadow setShadowColor : [ NSColor grayColor ] ];
	}
	[NSGraphicsContext saveGraphicsState];
	[gShadow set];
}

- (void)setOffShadow
{
	[NSGraphicsContext restoreGraphicsState];
}

#pragma mark - Drawing Parts

// Drawing Parts
// -------------
// size:128 x 128
// [NSBezierPath appendBezierPathWithRect:]

- (void)dColorPen
{
	[[NSColor colorWithCalibratedRed:0.7 green:0.3 blue:0.3 alpha:0.5] set];
}

- (void)dColorMain
{
	[[NSColor colorWithCalibratedRed:0.3 green:0.8 blue:0.3 alpha:0.9] set];
}
- (void)dColorMainDark
{
	[[NSColor colorWithCalibratedRed:0.3 green:0.4 blue:0.3 alpha:0.8] set];
}

- (void)dPlot:(NSRect)rect
{
	[[NSColor colorWithCalibratedRed:0.2 green:1.0 blue:0.2 alpha:0.8] set];
    NSRectFill(rect);
	[[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.3 alpha:0.8] set];
    [NSBezierPath strokeRect:rect];
}

#pragma mark - Drawing Function

- (void)dCross:(NSPoint)pos
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    CGFloat p[4] = { 1, 1, 4, 0 };
    p[3] = iPenWidth;
 /*   if( 1 <= NSWidth(iRect) )
    {
        p[0] = (128 / NSWidth(iRect));
        for( i = 1; i < 4; i++ )
            p[i] /= p[0];
    }
*/
	pos = NSMakePoint(pos.x -p[1], pos.y -p[2]);
	[path moveToPoint:pos]; pos.x += p[3];
	[path lineToPoint:pos]; pos.y += p[3];
	[path lineToPoint:pos]; pos.x += p[3];
	[path lineToPoint:pos]; pos.y += p[3];
	[path lineToPoint:pos]; pos.x -= p[3];
	[path lineToPoint:pos]; pos.y += p[3];
	[path lineToPoint:pos]; pos.x -= p[3];
	[path lineToPoint:pos]; pos.y -= p[3];
	[path lineToPoint:pos]; pos.x -= p[3];
	[path lineToPoint:pos]; pos.y -= p[3];
	[path lineToPoint:pos]; pos.x += p[3];
	[path lineToPoint:pos]; pos.y -= p[3];
	[path closePath];
	[[NSColor colorWithCalibratedRed:0.9 green:0.0 blue:0.0 alpha:0.7] set];
	[path fill];
	path = [NSBezierPath bezierPath];
	pos = NSMakePoint(pos.x, pos.y +p[1]);
	[path moveToPoint:pos]; pos.x += p[3] -p[1];
	[path lineToPoint:pos]; pos.y += p[3];
	[path lineToPoint:pos]; pos.x += p[3];
	[path lineToPoint:pos]; pos.y += p[3] -p[1];
	[path lineToPoint:pos]; pos.x -= p[3];
	[path lineToPoint:pos]; pos.y += p[3];
	[path lineToPoint:pos]; pos.x -= p[3] -p[1];
	[path lineToPoint:pos]; pos.y -= p[3];
	[path lineToPoint:pos]; pos.x -= p[3];
	[path lineToPoint:pos]; pos.y -= p[3] -p[1];
	[path lineToPoint:pos]; pos.x += p[3];
	[path lineToPoint:pos]; pos.y -= p[3] -p[1];
	[path closePath];
	[self dColorPen];
	[path stroke];
}

- (void)dCrossLDRU:(NSRect)r
{
	[self dCross:NSMakePoint( NSMaxX(r), NSMinY(r) )];
	[self dCross:NSMakePoint( NSMinX(r), NSMaxY(r) )];
}

- (void)dDashBox:(NSRect)r
{
	NSBezierPath *path = [NSBezierPath bezierPathWithRect:r];
	CGFloat pat[] = { 2.0, 2.0 };
	
	[[NSColor blackColor] set];
	[path setLineDash:pat count:2 phase:0.0];
	[path stroke];
}

- (void)dCircle:(NSPoint)pos size:(CGFloat)r
{
	[self dColorMain];
	
	NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:
		NSMakeRect( pos.x -r/2, pos.y -r/2, r, r )];
	[path setLineWidth:iPenWidth];
	[path stroke];
}

- (void)dFCircle:(NSPoint)pos size:(CGFloat)r
{
	[self dColorMain];
	[[NSBezierPath bezierPathWithOvalInRect:
		NSMakeRect( pos.x -r/2, pos.y -r/2, r, r )] fill];
}

#pragma mark -

- (NSBezierPath *)makePolygonPath:(NSBezierPath *)path num:(int)n
                origin:(NSPoint)pos radius:(float)r
{
    int	i;
	
	// pos.y
    
    for(i = 0; i <= n; ++i)
	{
        NSPoint	tmpPoint = pos;
        tmpPoint.x += r * 
            cos(M_PI_2 + 2 * M_PI * (i / (float)n));
        tmpPoint.y -= r * 
            sin(M_PI_2 + 2 * M_PI * (i / (float)n));
        
        if( !i )
            [path moveToPoint:tmpPoint];
        else
            [path lineToPoint:tmpPoint];
    }
	[path closePath];
	return path;
}

// minus : Hisi
- (NSPoint)dNAngle:(int)n
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	[self dColorMain];
	[path setLineWidth:iPenWidth];
    
    int sw = 1;
    CGFloat p[3] = { 1,10,30 };
    if( 1 <= NSWidth(iRect) )
    {
        p[0] = 128 / NSWidth(iRect);
        p[1] /= p[0];
        p[2] /= p[0];
    }
    if( n < 0 )
    {
        n *= -1;
        sw = 0;
    }
    path = [self makePolygonPath:path num:n
                          origin:NSMakePoint( NSMidX(iRect), NSMidY(iRect)-p[1])
                          radius:p[2]];
	
	if( sw )
	{
		NSAffineTransform *at = [NSAffineTransform transform];
		[at translateXBy:-NSMidX(iRect) yBy:-(NSMidY(iRect) -p[1])];
		[path transformUsingAffineTransform:at];
		at = [NSAffineTransform transform];
		[at rotateByDegrees:45];
		[path transformUsingAffineTransform:at];
		at = [NSAffineTransform transform];
		[at translateXBy:NSMidX(iRect) yBy:NSMidY(iRect) -p[1]];
		[path transformUsingAffineTransform:at];
	}
	[path stroke];
	return [path currentPoint];
}

- (void)dFreeLine
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    int i;
    CGFloat p[9] = {  1,24,30,34,
                     54,64,74,84,104 };
    if( 1 <= NSWidth(iRect) )
    {
        p[0] = 128 / NSWidth(iRect);
        for( i = 1; i < 9; i++ )
            p[i] /= p[0];
    }

    [self dColorMain];
    [path setLineWidth:iPenWidth];
    [path moveToPoint:NSMakePoint( p[1], p[1])];
    [path curveToPoint:NSMakePoint( p[5], p[4]) 
            controlPoint1:NSMakePoint(p[3], p[6])
            controlPoint2:NSMakePoint(p[4], p[6]) ];
    [path curveToPoint:NSMakePoint( p[8], p[7]) 
            controlPoint1:NSMakePoint(p[7], p[2])
            controlPoint2:NSMakePoint(p[8], p[7]) ];
	[path stroke];
}

- (void)dTrace
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    int i;
    CGFloat p[6] = {  1,24,54,64,84,104 };
    if( 1 <= NSWidth(iRect) )
    {
        p[0] = 128 / NSWidth(iRect);
        for( i = 1; i < 6; i++ )
            p[i] /= p[0];
    }
	[self dColorMain];
	[path setLineWidth:iPenWidth];
	[path moveToPoint:NSMakePoint( p[1], p[1])];
	[path lineToPoint:NSMakePoint( p[2], p[4])];
	[path lineToPoint:NSMakePoint( p[4], p[1])];
	[path lineToPoint:NSMakePoint( p[5], p[3])];
	[path stroke];
}

- (void)dBox:(NSRect)r
{
	NSBezierPath *path = [NSBezierPath bezierPathWithRect:r];
	
	[self dColorMain];
	[path setLineWidth:iPenWidth];
	[path stroke];
}

- (void)dAllLineX:(NSRect)r
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	[self dColorMain];
	[path setLineWidth:iPenWidth];
	[path moveToPoint:NSMakePoint( NSMinX(r), NSMidY(r) )];
	[path lineToPoint:NSMakePoint( NSMaxX(r), NSMidY(r) )];
	[path stroke];
}

- (void)dAllLineY:(NSRect)r
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	[self dColorMain];
	[path setLineWidth:iPenWidth];
	[path moveToPoint:NSMakePoint( NSMidX(r), NSMinY(r) )];
	[path lineToPoint:NSMakePoint( NSMidX(r), NSMaxY(r) )];
	[path stroke];
}

- (void)dAllLine:(NSRect)r
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	[self dColorMain];
	[path setLineWidth:iPenWidth];
	[path moveToPoint:NSMakePoint( NSMinX(r), NSMidY(r) )];
	[path lineToPoint:NSMakePoint( NSMaxX(r), NSMidY(r) )];
	[path stroke];
	[self dColorMainDark];
	[path setLineWidth:iPenWidth];
	[path moveToPoint:NSMakePoint( NSMidX(r), NSMinY(r) )];
	[path lineToPoint:NSMakePoint( NSMidX(r), NSMaxY(r) )];
	[path stroke];
}

- (void)dPaint:(int)sw
{
    NSBezierPath *path;
    int i;
    CGFloat p[27] = { 1,18,34,38,
                     42,45,46,47,
                     50,54,55,56,
                     62,64,65,74,
                     80,84,88,90,
                     94,104,78,48,68,24,58 };
    if( 1 <= NSWidth(iRect) )
    {
        p[0] = 128 / NSWidth(iRect);
        for( i = 1; i < 27; i++ )
            p[i] /= p[0];
    }
	
	path = [NSBezierPath bezierPath];
	[self dColorMain];
	[path moveToPoint:NSMakePoint( p[20], p[2])];
	[path lineToPoint:NSMakePoint( p[21],p[13])];
    [path curveToPoint:NSMakePoint( p[15], p[17]) 
            controlPoint1:NSMakePoint(p[21], p[22])
            controlPoint2:NSMakePoint(p[17], p[18]) ];
	[path lineToPoint:NSMakePoint(p[8],p[11])];
	[path closePath];
	[path moveToPoint:NSMakePoint( p[20], p[2])];
    [path curveToPoint:NSMakePoint(p[9], p[9]) 
            controlPoint1:NSMakePoint(p[17],p[3])
            controlPoint2:NSMakePoint(p[13],p[4])];
	[path closePath];
	[path fill];
	[path setLineWidth:iPenWidth];
	[path stroke];
	
	
	path = [NSBezierPath bezierPath];
	[self dColorMainDark];
	[path moveToPoint:NSMakePoint( p[20], p[2])];
    [path curveToPoint:NSMakePoint(p[9], p[9]) 
            controlPoint1:NSMakePoint(p[17],p[3])
            controlPoint2:NSMakePoint(p[13],p[4])];
    [path curveToPoint:NSMakePoint(p[20], p[2]) 
            controlPoint1:NSMakePoint(p[24],p[23])
            controlPoint2:NSMakePoint(p[16],p[23])];
	[path closePath];
	[path fill];
	
	path = [NSBezierPath bezierPath];
	if( sw )
		[[NSColor colorWithCalibratedRed:0.3 green:0.6 blue:0.6 alpha:0.5] set];
	else
		[self dColorPen];
	
	[path moveToPoint:NSMakePoint( p[12], p[6])];
    [path curveToPoint:NSMakePoint(p[25], p[16]) 
            controlPoint1:NSMakePoint(p[3],p[10])
            controlPoint2:NSMakePoint(p[1],p[14])];
    [path curveToPoint:NSMakePoint(p[4], p[19]) 
            controlPoint1:NSMakePoint(p[5],p[17])
            controlPoint2:NSMakePoint(p[7],p[15])];
	[path curveToPoint:NSMakePoint(p[26], p[23]) 
            controlPoint1:NSMakePoint(p[10],p[9])
            controlPoint2:NSMakePoint(p[15],p[17])];
	[path closePath];
	[path fill];
	[path setLineWidth:iPenWidth];
	[path stroke];
	
	if( sw )
	{
		path = [NSBezierPath bezierPath];
		[path setLineWidth:iPenWidth];
		[[NSColor blueColor] set];
		[path moveToPoint:NSMakePoint( p[12], p[6])];
		[path curveToPoint:NSMakePoint(p[25], p[16]) 
			controlPoint1:NSMakePoint(p[3],p[10])
			controlPoint2:NSMakePoint(p[1],p[14])];
		[path stroke];
		path = [NSBezierPath bezierPath];
		[path setLineWidth:iPenWidth];
		[[NSColor orangeColor] set];
		[path moveToPoint:NSMakePoint( p[25], p[16])];
		[path curveToPoint:NSMakePoint(p[4], p[19]) 
            controlPoint1:NSMakePoint(p[5],p[17])
            controlPoint2:NSMakePoint(p[7],p[15])];
		[path stroke];
		path = [NSBezierPath bezierPath];
		[path setLineWidth:iPenWidth];
		[[NSColor purpleColor] set];
		[path moveToPoint:NSMakePoint( p[4], p[19])];
		[path curveToPoint:NSMakePoint(p[26], p[23]) 
            controlPoint1:NSMakePoint(p[10],p[9])
            controlPoint2:NSMakePoint(p[15],p[17])];
		[path stroke];
	}
}

#pragma mark - Draw Icon

- (BOOL)drawDraw:(char *)f
{
	BOOL ret = YES;
    int i;
	NSPoint pos;
    CGFloat p[12] = { 1,10,13,24,
                     34,35,48,54,
                     59,60,84,104 };
    if( 1 <= NSWidth(iRect) )
    {
        p[0] = 128 / NSWidth(iRect);
        for( i = 1; i < 12; i++ )
            p[i] /= p[0];
    }
    
	f += 2;
	if( MY_CMP( f, "Plot" ) )
	{
		[self setOnShadow];
		[self dFCircle:NSMakePoint( NSMidX(iRect), NSMidY(iRect) -p[1]) size:p[2]];
		[self setOffShadow];
		[self dCross:NSMakePoint( NSMidX(iRect), NSMidY(iRect) -p[1])];
	}
	else if( MY_CMP( f, "FreeLine" ) )
	{
		[self setOnShadow];
		[self dFreeLine];
		[self setOffShadow];
		[self dCross:NSMakePoint(p[3],p[3])];
		[self dCross:NSMakePoint(p[11],p[10])];
	}
	else if( MY_CMP( f, "Trace" ) )
	{
		[self setOnShadow];
		[self dTrace];
		[self setOffShadow];
		[self dCross:NSMakePoint( p[3], p[3])];
		[self dCross:NSMakePoint( p[7], p[10])];
		[self dCross:NSMakePoint( p[10], p[3])];
	}
	else if( MY_CMP( f, "Box" ) )
	{
		[self setOnShadow];
		[self dBox:NSMakeRect(p[4],p[3],p[9],p[9])];
		[self setOffShadow];
		[self dCrossLDRU:NSMakeRect(p[4],p[3],p[9],p[9])];
	}
	else if( MY_CMP( f, "FillBox" ) )
	{
		[self setOnShadow];
		[self dColorMain];
		NSRectFill( NSMakeRect(p[4],p[3],p[9],p[9]) );
		[self setOffShadow];
		[self dCrossLDRU:NSMakeRect(p[4],p[3],p[9],p[9])];
	}
	else if( MY_CMP( f, "Circle" ) )
	{
		[self setOnShadow];
		[self dCircle:NSMakePoint( NSMidX(iRect), NSMidY(iRect)-p[1]) size:p[9]];
		[self setOffShadow];
		[self dCrossLDRU:NSMakeRect(p[4],p[3],p[9],p[9])];
	}
	else if( MY_CMP( f, "FCircle" ) )
	{
		[self setOnShadow];
		[self dFCircle:NSMakePoint( NSMidX(iRect), NSMidY(iRect)-p[1]) size:p[9]];
		[self setOffShadow];
		[self dCrossLDRU:NSMakeRect(p[4],p[3],p[9],p[9])];
	}
	else if( MY_CMP( f, "AllLineX" ) )
    {
		[self dDashBox:NSMakeRect(p[4],p[5],p[8],p[8])];
		[self setOnShadow];
		[self dAllLineX:NSMakeRect(p[4],p[3],p[9],p[9])];
		[self setOffShadow];
    }
	else if( MY_CMP( f, "AllLineY" ) )
    {
		[self dDashBox:NSMakeRect(p[4],p[5],p[8],p[8])];
		[self setOnShadow];
		[self dAllLineY:NSMakeRect(p[4],p[3],p[9],p[9])];
		[self setOffShadow];
    }
    else if( MY_CMP( f, "AllLine" ) )
	{
		[self dDashBox:NSMakeRect(p[4],p[5],p[8],p[8])];
		[self setOnShadow];
		[self dAllLine:NSMakeRect(p[4],p[3],p[9],p[9])];
		[self setOffShadow];
	}
	else if( MY_CMP( f, "Tri" ) )
	{
		[self setOnShadow];
		pos = [self dNAngle:3];
		[self setOffShadow];
		[self dCross:pos];
		[self dCross:NSMakePoint( NSMidX(iRect), NSMidY(iRect) -p[1])];
	}
	else if( MY_CMP( f, "Rect" ) )
	{
		[self setOnShadow];
		pos = [self dNAngle:4];
		[self setOffShadow];
		[self dCross:pos];
		[self dCross:NSMakePoint( NSMidX(iRect), NSMidY(iRect) -p[1])];
	}
	else if( MY_CMP( f, "Pent" ) )
	{
		[self setOnShadow];
		pos = [self dNAngle:5];
		[self setOffShadow];
		[self dCross:pos];
		[self dCross:NSMakePoint( NSMidX(iRect), NSMidY(iRect) -p[1])];
	}
	else if( MY_CMP( f, "Hexi" ) )
	{
		[self setOnShadow];
		pos = [self dNAngle:6];
		[self setOffShadow];
		[self dCross:pos];
		[self dCross:NSMakePoint( NSMidX(iRect), NSMidY(iRect) -p[1])];
	}
	else if( MY_CMP( f, "Hisi" ) )
	{
		[self dDashBox:NSMakeRect(p[4],p[3],p[9],p[9])];
		[self setOnShadow];
		[self dNAngle:-4];
		[self setOffShadow];
		[self dCrossLDRU:NSMakeRect(p[4],p[3],p[9],p[9])];
	}
	else if( MY_CMP( f, "nAngles" ) )
	{
		iRect = NSOffsetRect( iRect, -p[3], -p[3] );
		[self dNAngle:7];
		iRect = NSOffsetRect( iRect, p[6], p[6] );
		[self dNAngle:8];
	}
	else if( MY_CMP( f, "Paint2" ) )
	{
		[self dPaint:1];
	}
	else if( MY_CMP( f, "Paint" ) )
	{
		[self dPaint:0];
	}
    else ret = NO;
    
    return ret;
}

#pragma mark - Edit Icon

- (BOOL)drawEdit:(char *)f
{
    BOOL ret = YES;
    
	f += 2;
	if( MY_CMP( f, "Move" ) )
	{
	}
	else if( MY_CMP( f, "Copy" ) )
	{
	}
    else ret = NO;
    
    return ret;
}

#pragma mark - Palette Icon

- (BOOL)drawPalette:(char *)f
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark - Weaving Icon

- (BOOL)drawWeaving:(char *)f
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark - Carpet Icon

- (BOOL)drawCarpet:(char *)f
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark - Jacquard Lace Icon

- (BOOL)drawJLace:(char *)f
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark - Raschel Lace Icon

- (BOOL)drawRLace:(char *)f
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark - Simulate Icon

- (BOOL)drawSimulate:(char *)f
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark - Main Menu Icon

/* 32 x 32 */
- (BOOL)drawMainMenu:(char *)f
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	BOOL ret = YES;
	int a, b, x, y, w, n;
	a = 5; b = 15;
	f += 2;
	
    [NSBezierPath setDefaultLineCapStyle:NSButtLineCapStyle];
    [NSBezierPath setDefaultLineJoinStyle:NSMiterLineJoinStyle];
	[[NSColor colorWithCalibratedRed:0.0 green:0.8 blue:0.8 alpha:0.8] set];

	if( MY_CMP( f, "ORIGIN_LU" ) )
	{
		/* 32 x 32 */
		[path setLineWidth:iPenWidth];
		[path moveToPoint:NSMakePoint( a, a )];
		[path lineToPoint:NSMakePoint( a +b, a )];
		[path moveToPoint:NSMakePoint( a, a )];
		[path lineToPoint:NSMakePoint( a, a +b )];
		[path stroke];
		[self dCross:NSMakePoint( a, a ) ];
	}
	else if( MY_CMP( f, "ORIGIN_LD" ) )
	{
		/* 32 x 32 */
		[path setLineWidth:iPenWidth];
		[path moveToPoint:NSMakePoint( a, 32 -a )];
		[path lineToPoint:NSMakePoint( a, 32 -(a +b) )];
		[path moveToPoint:NSMakePoint( a, 32 -a )];
		[path lineToPoint:NSMakePoint( a +b, 32 -a )];
		[path stroke];
		[self dCross:NSMakePoint( a, 32 -a ) ];
	}
	if( MY_CMP( f, "ORIGIN_RU" ) )
	{
		/* 32 x 32 */
		[path setLineWidth:iPenWidth];
		[path moveToPoint:NSMakePoint( 32 -a, a )];
		[path lineToPoint:NSMakePoint( 32 -(a +b), a )];
		[path moveToPoint:NSMakePoint( 32 -a, a )];
		[path lineToPoint:NSMakePoint( 32 -a, a +b )];
		[path stroke];
		[self dCross:NSMakePoint( 32 -a, a ) ];
	}
	else if( MY_CMP( f, "ORIGIN_RD" ) )
	{
		a = 32 -a;
		[path setLineWidth:iPenWidth];
		[path moveToPoint:NSMakePoint( a, a )];
		[path lineToPoint:NSMakePoint( a -b, a )];
		[path moveToPoint:NSMakePoint( a, a )];
		[path lineToPoint:NSMakePoint( a, a -b )];
		[path stroke];
		[self dCross:NSMakePoint( a, a ) ];
	}
    else if( MY_CMP( f, "PALETTE_OPEN" ) )
    {
    	[[NSColor darkGrayColor] set];
		NSRectFill( NSMakeRect(0,0,33,26) );
    }
    else if( MY_CMP( f, "PALETTE_CLOSE" ) )
    {
    }
    else if( MY_CMP( f, "SUTEKAKE_SUTE" ) )
    {
        w = 4;
        n = 5;
        x = 32 - (w * n);
        x /= 2;
        y = 32 - x +3 -w;
        for( a = 0; a < n; a++ )
        {
            [self dPlot:NSMakeRect(x, y, w, w)];
            if( !a || (a +1) == n )
                [self dCross:NSMakePoint( x +2, y +1 ) ];

            x += w;
            y -= w;
        }
    }
    else if( MY_CMP( f, "SUTEKAKE_KAKE" ) )
    {
        w = 4;
        n = 5;
        x = 32 - (w * n);
        x /= 2;
        y = 32 - x +3 -w;
        x += w; n--;
        for( a = 0; a < n; a++ )
        {
            [self dPlot:NSMakeRect(x, y, w, w)];
            x += w;
            y -= w;
        }
        w = 4;
        n = 5;
        x = 32 - (w * n);
        x /= 2;
        y = 32 - x +3 -w;
        for( a = 0; a < n; a++ )
        {
            [self dPlot:NSMakeRect(x, y, w, w)];
            if( !a || (a +1) == n )
                [self dCross:NSMakePoint( x +2, y +1 ) ];
            x += w;
            y -= w;
        }
    }
    else if( MY_CMP( f, "EFFECTIGNORE_NONE") )
    {
        [path setLineWidth:iPenWidth];
        [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.9] set];
        NSRectFill( NSMakeRect(12,7,10,3) );

    }
    else if( MY_CMP( f, "EFFECTIGNORE_EFFECT") )
    {
        [path setLineWidth:0];
        [path moveToPoint:NSMakePoint(10, 8)];
        [path lineToPoint:NSMakePoint(15,14)];
        [path lineToPoint:NSMakePoint(26, 3)];
        [path lineToPoint:NSMakePoint(15,12)];
        [path lineToPoint:NSMakePoint(12, 7)];
        [path closePath];
        [path fill];
    }
    else if( MY_CMP( f, "EFFECTIGNORE_IGNORE") )
    {
        [[NSColor darkGrayColor] set];
        [path setLineWidth:2];
        [path moveToPoint:NSMakePoint(12,4)];
        [path lineToPoint:NSMakePoint(21,13)];
        [path moveToPoint:NSMakePoint(12,13)];
        [path lineToPoint:NSMakePoint(21,4)];
        [path stroke];

    }
    else if( MY_CMP( f, "INFO_OPEN" ) )
    {
    	[[NSColor darkGrayColor] set];
		NSRectFill( NSMakeRect(0,0,33,26) );
    }
    else if( MY_CMP( f, "INFO_CLOSE" ) )
    {
    }
    else
        ret = NO;
    
    return ret;
}

#pragma mark - func

- (void)drawRect:(NSRect)r func:(char *)f
{
	iRect = r;
	iPenWidth = 3;
	
	NSGraphicsContext *gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
    // [gc setShouldAntialias:NO];

	switch( *f )
	{
	case 'D':
		[self drawDraw:f]; break;
	case 'E':
		[self drawEdit:f]; break;
	case 'P':
		[self drawPalette:f]; break;
	case 'W':
		[self drawWeaving:f]; break;
	case 'C':
		[self drawCarpet:f]; break;
	case 'J':
		[self drawJLace:f]; break;
	case 'R':
		[self drawRLace:f]; break;
	case 'S':
		[self drawSimulate:f]; break;
	case 'M':
		[self drawMainMenu:f]; break;
	}
    [gc restoreGraphicsState];
}

- (BOOL)hasIcon:(char *)f
{
    BOOL ret = NO;
    
    if( f == nil ) return ret;
    
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(128, 128)];
    [image lockFocus];
	switch( *f )
	{
        case 'D':
            ret = [self drawDraw:f]; break;
        case 'E':
            ret = [self drawEdit:f]; break;
        case 'P':
            ret = [self drawPalette:f]; break;
        case 'W':
            ret = [self drawWeaving:f]; break;
        case 'C':
            ret = [self drawCarpet:f]; break;
        case 'J':
            ret = [self drawJLace:f]; break;
        case 'R':
            ret = [self drawRLace:f]; break;
        case 'S':
            ret = [self drawSimulate:f]; break;
        case 'M':
            ret = [self drawMainMenu:f]; break;
	}
    [image release];
    
    return ret;
}

@end
