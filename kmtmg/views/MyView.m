#import "MyView.h"
#import "MyScrollwithOtherView.h"
#import <OpenGL/OpenGL.h>
#import "../MyDefines.h"
#import "../menuTool/MyDrawButton.h"
#import "../panels/MySelect4.h"
#import "../panels/MyTopImage.h"

@implementation MyView

@synthesize keyScroll;

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil)
	{
		// Add initialization code here
		[self setFrame:NSMakeRect( frameRect.origin.x, frameRect.origin.y, 100, 100 )];
        keyScroll = NO;
    }
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)acceptsTouchEvents
{
    return YES;
}

- (BOOL)setPostsFrameChangedNotifications
{
    return YES;
}

#pragma mark - Drawing

- (CGFloat) gridBold:(float)f
{
    CGFloat w = 1.6;
    /*
    if( 4 < f )
    {
        w += ((f -4) / 3);
        w += 0.3 * ((int)(f -4) % 3);
    }*/
    
    return w;
}

- (void) drawGrid:(NSRect)rect
{
    NSInteger type = mvd.gridType;
    if( type == MVD_GRID_NODISP ) return;
    
    NSPoint pixel = mvd.pixel;
    if( (NSInteger)pixel.x < 3 || (NSInteger)pixel.y < 3 ) return;
    
    NSInteger i;
    CGFloat f, r, g, b, a;
    NSBezierPath *path, *boldpath;
    NSPoint min, max, st, ed;
    
    min.x = NSMinX(rect);
    min.y = NSMinY(rect);
    max.x = NSMaxX(rect);
    max.y = NSMaxY(rect);
    
    path = [NSBezierPath bezierPath];
    boldpath = [NSBezierPath bezierPath];
    
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    CGContextRef cg = [gc graphicsPort];
    
    [mvd.gridColor getRed:&r green:&g blue:&b alpha:&a];
    [[NSColor colorWithCalibratedRed:r green:g blue:b alpha:a] set];
    
    NSPoint noSpace = [mvd noSpace];
    NSPoint bold = mvd.gridBoldFat;
    if( 2 < (NSInteger)pixel.y )
    {
        f = 0.3;
        // if( pixel.y < 6.0 )
        //	f = 0.3;
        // else if( 10.0 < pixel.y )
        //	f = 0.7;
        // rgb 
        f = min.y;
        if( f <= noSpace.y )
        {
            f = noSpace.y;
            i = 1;
            for( ; min.y < f; --i )
                f -= pixel.y;
        }
        else
        {
            f -= noSpace.y;
            i = (NSInteger)f / (NSInteger)pixel.y;
            f = i * pixel.y;
            f += noSpace.y;
        }
        CGContextSetLineWidth(cg, 1.0);
        st.x = min.x; ed.x = max.x;
        if( 3.0 < pixel.y && type == MVD_GRID_ALL )
        {
            st.y = f;     ed.y = f;
            for( ; st.y <= max.y; st.y += pixel.y, ed.y += pixel.y )
            {
                CGContextMoveToPoint(cg, st.x, st.y);
                CGContextAddLineToPoint(cg, ed.x, ed.y);
                CGContextStrokePath(cg);
            }
        }
        
        [gc setShouldAntialias:YES];
        CGContextSetLineWidth(cg, [self gridBold:pixel.y]);
        f = noSpace.y + (NSInteger)pixel.y * i;
        ++i;
        st.y = f;     ed.y = f;
        for( ; st.y <= max.y; st.y += pixel.y, ed.y += pixel.y, ++i )
        {
            if( i == 1 || !((i-1) % (NSInteger)bold.y) )
            {
                CGContextMoveToPoint(cg, st.x, st.y);
                CGContextAddLineToPoint(cg, ed.x, ed.y);
                CGContextStrokePath(cg);
            }
        }
        [gc setShouldAntialias:NO];
    }
    
    if( 2 < (NSInteger)pixel.x )
    {
        f = 0.3;
        f = min.x;
        if( f <= noSpace.x )
        {
            f = noSpace.x;
            i = 1;
            for( ; min.x < f; --i )
                f -= pixel.x;
        }
        else
        {
            f -= noSpace.x;
            i = (NSInteger)f / (NSInteger)pixel.x;
            f = i * pixel.x;
            f += noSpace.x;
        }
        CGContextSetLineWidth(cg, 1.0);
        st.y = min.y; ed.y = max.y;
        if( 3.0 < pixel.x && type == MVD_GRID_ALL )
        {
            st.x = f; ed.x = f;
            for( ; st.x <= max.x; st.x += pixel.x, ed.x += pixel.x )
            {
                CGContextMoveToPoint(cg, st.x, st.y);
                CGContextAddLineToPoint(cg, ed.x, ed.y);
                CGContextStrokePath(cg);
            }
        }
        
        [gc setShouldAntialias:YES];
        CGContextSetLineWidth(cg, [self gridBold:pixel.x]);
        f = noSpace.x + (NSInteger)pixel.x * i;
        ++i;
        st.x = f; ed.x = f;
        for( ; st.x <= max.x; st.x += pixel.x, ed.x += pixel.x, ++i )
        {
            if( i == 1 || !((i-1) % (NSInteger)bold.x) )
            {
                CGContextMoveToPoint(cg, st.x, st.y);
                CGContextAddLineToPoint(cg, ed.x, ed.y);
                CGContextStrokePath(cg);
            }
        }
    }
}

- (void) drawData
{    
    if( NSWidth(iUpdateRect) < 1 || NSHeight(iUpdateRect) < 1 )
        return;
    
    if( [mvd hasImage] == YES )
    {
        // MyLog( @"drawImageAt:%@ from:%@",NSStringFromRect(iUpdateDisp), NSStringFromRect(iUpdateRect) );
        // CGContextRef context = [[NSGraphicsContext currentContext]graphicsPort];
        // CGContextScaleCTM( context, -1.0, 1.0 );
        // From 10.6 :[image setFlipped:[iData originUp]] -> [image lockFocusFlipped:[iData originUp]] @MyData
        // MyLog( @"originUp:%d", [iData originUp] );
        
        // [[iData image] drawInRect:iUpdateDisp fromRect:iUpdateRect operation:NSCompositeSourceOver fraction:1.0];
        
        
        MyTopImage *topImage;
        for( topImage in [mvd topImages] )
        {
            [topImage drawDispRect:iUpdateDisp imageRect:iUpdateRect fraction:mvd.backgroundFraction pixel:mvd.pixel];
        }
        
        if ( keyScroll == YES )
        {
            [mvd drawScrollDispRect:iUpdateDisp imageRect:iUpdateRect];
            keyScroll = NO;
        }
        else
            [mvd drawDispRect:iUpdateDisp imageRect:iUpdateRect];
    }
}

- (void) updateRect:(NSRect)r
{
	NSSize size = [mvd size];
	NSPoint no = [mvd noSpace];
	NSPoint p = [mvd pixel];
	iUpdateRect = NSOffsetRect( r, -no.x, -no.y );
	CGFloat x, y, w, h;
	x = NSMinX(iUpdateRect);
	y = NSMinY(iUpdateRect);
	w = NSWidth(iUpdateRect);
	h = NSHeight(iUpdateRect);
	
	if( x < 0 )
	{
		w += x;
		x = 0;
	}
	if( 0 < p.x )
	{
		x /= p.x;
		w = (w +p.x *2) / p.x;
	}
	if( y < 0 )
	{
		h += y;
		y = 0;
	}
	if( 0 < p.y )
	{
		y /= p.y;
		h = (h +p.y *2) / p.y;
	}
	
	iUpdateRect = NSMakeRect( x, y, w, h );
	/* Integrate adjust */
	NSInteger i;
	i = iUpdateRect.origin.x;
	iUpdateRect.origin.x = i;
	i = iUpdateRect.origin.y;
	iUpdateRect.origin.y = i;
	i = iUpdateRect.size.width;
	iUpdateRect.size.width = i;
	i = iUpdateRect.size.height;
	iUpdateRect.size.height = i;
	
	if( size.width < NSMaxX(iUpdateRect) )
		iUpdateRect.size.width = size.width -NSMinX( iUpdateRect );
	
	if( size.height < NSMaxY(iUpdateRect) )
		iUpdateRect.size.height = size.height -NSMinY( iUpdateRect );
	
	iUpdateDisp = iUpdateRect;
	iUpdateDisp.origin.x *= p.x;
	iUpdateDisp.size.width *= p.x;
	
	/*
	 if( [iData originUp] == YES )
	{
		iUpdateDisp.origin.y = size.height - iUpdateDisp.origin.y +1;
	}*/
	iUpdateDisp.origin.y *= p.y;
	iUpdateDisp.size.height *= p.y;
	
	iUpdateDisp = NSOffsetRect( iUpdateDisp, no.x, no.y );
}


- (void)drawRect:(NSRect)rect
{
    if( mvd == nil ) return;
    
	NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
    [gc setShouldAntialias:NO];
	
	[[NSColor darkGrayColor] set];
    NSRectFill(rect);
    	
	// MyLog( @"OS > %@", NSStringFromRect(rect));
	[self updateRect:rect];
    
    if (NSWidth(iUpdateDisp) < 1 || NSHeight(iUpdateDisp) < 1) {
        goto END_DRAWRECT;
    }
	
    // MyLog( @"View:%@ real:%@", NSStringFromRect(iUpdateDisp), NSStringFromRect(iUpdateRect));
	
	// Background Color Rect
	[mvd.backgroundColor set];
	NSRectFill( iUpdateDisp );
	// Background Color Rect -END-
	
	
	NSPoint p = mvd.pixel;
	NSInteger oldInterpolation = -1;
    
	if( 1.0 <= p.x && 1.0 <= p.y )
		oldInterpolation = [gc imageInterpolation];
    
	if( oldInterpolation != -1 )
		[gc setImageInterpolation:NSImageInterpolationNone];
    
    [self drawData];
        
	if( oldInterpolation != -1 )
		[gc setImageInterpolation:oldInterpolation];
    
END_DRAWRECT:
	[self drawGrid:rect];
    

    [gc restoreGraphicsState];
}

#pragma mark - Setter

- (void) setMyViewData:(MyViewData *)data
{
	mvd = data;
    penColorNoForDoubleClick = data.penColorNo;
}

- (void)checkUpdateData
{
	[self setNeedsDisplay:YES];
	// [self setNeedsDisplayInRect:[self frame]];
}


- (NSPoint)centerPositionUpdateRect
{
    NSPoint mid;
    mid.x = NSMidX( iUpdateRect );
    mid.y = NSMidY( iUpdateRect );
    
    return mid;
}

- (void)cancelOperation:(id)sender
{
    [[[self window] windowController] cancelOperation:self];
}

#pragma mark - Selection

- (int)ms4_effectIgnoreSrcDst
{
    MySelect4 *ms4 = [MySelect4 sharedManager];
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:4];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"" menu:"Source"]];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"" menu:"Destinate"]];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"" menu:"Cancel"]];
    
    return [ms4 openWithArray:a];
}

#pragma mark - Right Mouse

- (void)rightMouseUp:(NSEvent *)e
{
    NSPoint po = [e locationInWindow];
    
    po = [self convertPoint:po fromView:Nil];
    po.x = [mvd imageFromDisplayPositionX:po.x];
    po.y = [mvd imageFromDisplayPositionY:po.y];
    
    NSInteger n = [mvd indexFromDataPosition:po];
    if ( 0 <= n )
    {
        MyLog(@":%d", [e clickCount]);
        switch ([e clickCount])
        {
            case 1:
                penColorNoForDoubleClick = mvd.penColorNo;
                [[[self window] windowController] pressPaletteNo:n pos:NSZeroPoint];
                break;
            case 2:{
                char s = [mvd effectIgnoreSrc];
                char d = [mvd effectIgnoreDst];
                if( s && d )
                {
                    switch( [self ms4_effectIgnoreSrcDst] )
                    {
                        case 0: d = 0; break;
                        case 1: s = 0; break;
                        default:
                            s = d = 0; break;
                    }
                }
                
                if( s )
                {
                    [[[self window] windowController] pressPaletteNo:penColorNoForDoubleClick pos:NSZeroPoint];
                    [[[self window] windowController] pressPaletteNo:n pos:NSMakePoint(1, 25)];
                }
                else if( d )
                {
                    [[[self window] windowController] pressPaletteNo:penColorNoForDoubleClick pos:NSZeroPoint];
                    [[[self window] windowController] pressPaletteNo:n pos:NSMakePoint(1, 5)];
                }
                break;}
            default:
                break;
        }
    }
}

@end
