#import "MyScrollwithOtherView.h"
#import "MyScrollView.h"
#import "../MyDefines.h"
#import "MyLayerView.h"
#import "MyRubberView.h"
#import "../menuTool/MyDrawIcon.h"

@implementation MyScrollwithOtherView

@synthesize startPosition;
@synthesize oCursor, oRubber;

- (CGFloat) modf:(CGFloat)f mod:(CGFloat)m
{
	double ret, real, ip;
	
	// MyLog( @"f:%.3f %% m:%.3f",f,m );
	real = f;
	ret = ip = 0.0;
	ret = modf( real, &ip );
	
	if( (NSInteger)m == 0 )
		real = 0;
	else
		real = (NSInteger)ip % (NSInteger)m;
	
	real += ret;
	f = (CGFloat)real;
	// MyLog( @"ret:%.3f", f );
	
	return f;
}

- (void)dealloc
{
    [cursor release];
    [super dealloc];
}

- (void) setMyViewData:(MyViewData *)data hsv:(id)hv vsv:(id)vv
{
    oCursor = nil;
    oRubber = nil;
    directScroll = NO;
	iData = data;
	oHSview = hv;
	oVSview = vv;
	preScrollValue.x = -999.9f;
	preScrollValue.y = -999.9f;
    [hv setMyViewData:data scrollBar:[self horizontalScroller] ];
	[vv setMyViewData:data scrollBar:[self verticalScroller] ];
    
    [self setLineScroll:50];
    [self setPageScroll:200];
    
    [[self contentView] setCopiesOnScroll:NO];
    [self setScrollsDynamically:YES];
    
    cursor = [[NSCursor alloc] initWithImage:[[MyDrawIcon sharedManager] cursorImage] hotSpot:NSMakePoint(0, 0)];
}

#pragma mark - Scroll Bar

-(CGFloat) setHScroll:(NSPoint)pos
{
	NSRect cr = [[self contentView] frame];
	NSRect dr = [[self documentView] frame];
	NSInteger max = (dr.size.width -cr.size.width +1);
	if( pos.x < dr.origin.x )
		pos.x = dr.origin.x;
	if( max < pos.x )
		pos.x = max;
	[[self contentView] scrollToPoint:pos];
	
	[[self horizontalScroller] setDoubleValue:(pos.x / max)];
		
	return pos.x;
}

-(CGFloat) setVScroll:(NSPoint)pos
{
	NSRect cr = [[self contentView] frame];
	NSRect dr = [[self documentView] frame];
	NSInteger max = (dr.size.height -cr.size.height +1);
	if( pos.y < dr.origin.y )
		pos.y = dr.origin.y;
	if( max < pos.y )
		pos.y = max;
	[[self contentView] scrollToPoint:pos];

	[[self verticalScroller] setDoubleValue:(pos.y / max)];

	return pos.y;
}

#pragma mark - Scroll

-(void) upDownScroll:(NSScrollerPart)hit
{
	NSRect r = [[self contentView] documentVisibleRect];
    
    switch( hit )
    {
        case NSScrollerIncrementLine:
            r.origin.y += [self lineScroll];break;
        case NSScrollerDecrementLine:
            r.origin.y -= [self lineScroll];break;
        case NSScrollerIncrementPage:
            r.origin.y += [self pageScroll];break;
        case NSScrollerDecrementPage:
            r.origin.y -= [self pageScroll];break;
    }
	
	r.origin.y = [self setVScroll:r.origin];
	[self updateScrolledVSView:r.origin.y];
    startPosition.y = r.origin.y;
}

-(void) upScrollLine
{
	[self upDownScroll:NSScrollerIncrementLine];
}
-(void) downScrollLine
{
	[self upDownScroll:NSScrollerDecrementLine];
}
-(void) upScrollPage
{
	[self upDownScroll:NSScrollerIncrementPage];
}
-(void) downScrollPage
{
	[self upDownScroll:NSScrollerDecrementPage];
}

-(void) leftRightScroll:(NSScrollerPart)hit
{
	NSRect r = [[self contentView] documentVisibleRect];
    
    switch( hit )
    {
        case NSScrollerIncrementLine:
            r.origin.x += [self lineScroll];break;
        case NSScrollerDecrementLine:
            r.origin.x -= [self lineScroll];break;
        case NSScrollerIncrementPage:
            r.origin.x += [self pageScroll];break;
        case NSScrollerDecrementPage:
            r.origin.x -= [self pageScroll];break;
    }
	
	r.origin.x = [self setHScroll:r.origin];
	[self updateScrolledHSView:r.origin.x];
    startPosition.x = r.origin.x;
}

-(void) leftScrollLine
{
    [self leftRightScroll:NSScrollerDecrementLine];
}
-(void) rightScrollLine
{
    [self leftRightScroll:NSScrollerIncrementLine];
}
-(void) leftScrollPage
{
    [self leftRightScroll:NSScrollerDecrementPage];
}
-(void) rightScrollPage
{
    [self leftRightScroll:NSScrollerIncrementPage];
}

#pragma mark - Update

- (void) updateScrolledHSView:(CGFloat)x
{
	if( iData == NULL ) return;
	
	CGFloat pixel = iData.pixel.x;
	CGFloat i, n;
	int nospace;

	// MyLog( @"(H):%4.3f",[[self horizontalScroller] floatValue] );
	n = iData.noSpace.x;
	i = (x -n) / pixel;
	
	n = iData.noSpace.x;
    
	if( x < n )
	{
		nospace = 1;
		x = n -x;
		x = [self modf:x mod:pixel];
	}
	else
	{
		nospace = 0;
		x -= n;
		x = [self modf:x mod:pixel];
		x = pixel -x;
    }

	[iData setStartX:x isNoSpace:nospace];
	// MyLog( @"oHS:b%.4f p:%.4f st:%.4f", i, pixel, x );
	[oHSview setBaseData:i inc:pixel];
}

- (void) updateScrolledVSView:(CGFloat)y
{
	if( iData == NULL ) return;
	
	CGFloat pixel = iData.pixel.y;
	CGFloat i, n;
	int nospace;

	n = iData.noSpace.y;
	i = (y -n) / pixel;
    // MyLog( @"i:%.3f, pixel:%.3f", i, pixel );
		
	n = iData.noSpace.y;
    
	if( y < n )
	{
		nospace = 1;
        y = n -y;
        y = [self modf:y mod:pixel];
	}
	else
	{
		nospace = 0;
		y -= n;
        y = [self modf:y mod:pixel];
        y = pixel -y;
	}
    
	// y = [self modf:y mod:pixel];
    // MyLog( @"oVS:b%.4f p:%.4f st:%.4f", i, pixel, y );
	[iData setStartY:y isNoSpace:nospace];
	[oVSview setBaseData:i inc:pixel];
}


- (void) reflectScrolledClipView:(NSClipView *)aClipView
{
	// Need to update NSScroller
	[super reflectScrolledClipView:aClipView];
	
	if( iData == NULL ) return;
//	
	NSScroller *hs = [self horizontalScroller];
	NSScroller *vs = [self verticalScroller];
    
    /*
    if( directScroll == NO )
    {
        NSLog(@"directScroll NO");
        switch( [hs hitPart] )
        {
            case NSScrollerIncrementLine:
            case NSScrollerDecrementLine:
            case NSScrollerIncrementPage:
            case NSScrollerDecrementPage:
                directScroll = YES;
                [self leftRightScroll:[hs hitPart]];
                return;
        }
        switch( [vs hitPart] )
        {
            case NSScrollerIncrementLine:
            case NSScrollerDecrementLine:
            case NSScrollerIncrementPage:
            case NSScrollerDecrementPage:
                directScroll = YES;
                [self leftRightScroll:[vs hitPart]];
                return;
        }
    }
    else
    {
        NSLog(@"directScroll YES");
        switch( [hs hitPart] )
        {
            case NSScrollerIncrementLine:
            case NSScrollerDecrementLine:
            case NSScrollerIncrementPage:
            case NSScrollerDecrementPage:
                break;
            default:
                directScroll = NO;
                break;
        }
        switch( [vs hitPart] )
        {
            case NSScrollerIncrementLine:
            case NSScrollerDecrementLine:
            case NSScrollerIncrementPage:
            case NSScrollerDecrementPage:
                break;
            default:
                directScroll = NO;
                break;
        }
    }
    */
    
	NSPoint start;
	start.x = start.y = 0.0f;
	if( hs != NULL && vs != NULL )
	{
        // 0.0f - 1.0f
		start.x = [hs floatValue];
		start.y = [vs floatValue];
	}
	if( NSEqualPoints( start, preScrollValue ) != YES )
	{
		preScrollValue = start;
		NSRect cr = [aClipView frame];
		NSRect dr = [[self documentView] frame];
        NSInteger w = (dr.size.width -cr.size.width +1);
        NSInteger h = (dr.size.height -cr.size.height +1);
		start.x *= w;
		start.y = 1 -start.y;
		start.y *= h;
        NSInteger  tmp = (NSInteger)start.x;
        start.x = tmp;
		tmp = (NSInteger)start.y;
        start.y = tmp;
		// MyLog( @"reflect >> ScrollTo: %f, %f", start.x, start.y );
		// if( 0.0 <= start.x && start.x <= (dr.size.width -cr.size.width) && 0.0 <= start.y && start.y <= (dr.size.height -cr.size.height) )
        [aClipView scrollToPoint:start];
		// MyLog( @">> %@", NSStringFromRect( [aClipView documentVisibleRect]) );
		
		if( hs != NULL )
			[self updateScrolledHSView:start.x];
		
		if( vs != NULL )
			[self updateScrolledVSView:start.y];
        startPosition = start;
        
        if( oRubber != nil )
        {
            oCursor.scrollStart = start;
            [oCursor setNeedsDisplay:YES];
            oRubber.scrollStart = start;
            [oRubber setNeedsDisplay:YES];
        }

        // MyLog( @"visible:%@", NSStringFromRect( [aClipView documentVisibleRect] ) );
        
        // MyLog( @"start %@ / clip %@ / doc %@", NSStringFromPoint(startPosition), NSStringFromSize(cr.size), NSStringFromSize(dr.size) );
	}
	
}

#pragma mark - func

- (void) updateScrolledStartPosition:(NSPoint)start
{
    NSClipView  *aClipView = [self contentView];
    NSRect cr = [aClipView frame];
    NSRect dr = [[self documentView] frame];
    
    NSInteger w = (dr.size.width -cr.size.width +1);
    NSInteger h = (dr.size.height -cr.size.height +1);
    CGFloat f = start.x / w;
    [[self horizontalScroller] setDoubleValue:f ];
    f = start.y / h;
    f = 1.0f - f;
    [[self verticalScroller] setDoubleValue:f ];
    
    [aClipView scrollToPoint:start];
    [aClipView setNeedsDisplay:YES];
    // MyLog(@"aClipView >> setNeedsDisplay");
    
    [self updateScrolledHSView:start.x];
    [self updateScrolledVSView:start.y];
    startPosition = start;
}

- (void)resetCursorRects
{
    [self discardCursorRects];
    
	[cursor setOnMouseEntered:YES];
	[cursor setOnMouseExited:YES];
	[self addCursorRect:[self frame] cursor:cursor];
}

@end
