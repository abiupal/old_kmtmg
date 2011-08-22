//
//  MyDrawingManager.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/08.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyDrawingManager.h"
#import "../views/MyViewData.h"
#import "../MyDefines.h"
#import "../views/MyLayerView.h"
#import "../views/MyRubberView.h"
#import "myDrawing.h"
#import "../panels/MySelect4.h"
#import "../menuTool/MyDrawButton.h"
#import "../panels/MyInfo.h"
#import "myDrawing.h"

static MyDrawingManager *sharedMyDrawingManager = NULL;

@implementation MyDrawingManager

@synthesize view;

#pragma mark - Singleton

+ (MyDrawingManager *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyDrawingManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyDrawingManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyDrawingManager == Nil )
		{
			sharedMyDrawingManager = [super allocWithZone:zone];
			return sharedMyDrawingManager;
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
        memset(&myi, 0, sizeof(myi));
    }
    
    return self;
}

#pragma mark - MYID

- (NSRect)myid_initFromRect:(NSRect)rect
{
    NSRect offsetRect = NSOffsetRect(rect, -(rect.origin.x -1), -(rect.origin.y -1));
    myi.MyIdType = kImage_Temp;
    myi.w = offsetRect.size.width + mvd.penDot.width +1;
    myi.h = offsetRect.size.height + mvd.penDot.height +1;
    myi.sx = offsetRect.origin.x;
    myi.sy = offsetRect.origin.y;
    myi.ex = myi.sx + offsetRect.size.width;
    myi.ey = myi.sy + offsetRect.size.height;
    myi.d = malloc( myi.w * myi.h );
    if( myi.d != nil )
    {
        memset(myi.d, 0, myi.w * myi.h);
    }
    
    return offsetRect;
}

- (void)myid_clear
{
    if( myi.d != nil ) free(myi.d);
    myi.d = nil;
    myi.MyIdType = kImage_Unknown;
}

- (void)myid_plotX:(NSInteger)x y:(NSInteger)y
{
    if (myi.MyIdType != kImage_Temp)
    {
        [self plotX:x y:y];
        return;
    }
    
    x--; y--;
    unsigned char *p = myi.d + myi.w * y + x;
    *p = 1;
}

#pragma mark - Drawing

- (void)plot_sub
{
    int n = -1;
    if( myd.dst.effectIgnoreType )
    {
        n = myDraw_get( &myd.dst, pos.x -1, pos.y -1 );
        if( n != -1 && myd.dst.effectIgnoreType == MVD_IGNORE_DST )
            n += 256;
    }
    if( n != -1 )
    {
        if( n < 256 && myd.dst.allow[n] <= 0 ) return;
        else if( myd.dst.allow[n] < 0 ) return;
    }
    
    
    if( [mvd drawPlot:pos] == YES )
    {
        [view setNeedsDisplayInRect:[mvd plotDisplayRect:pos]];
    }
}

- (void)plot
{
    int x, y;
    NSPoint tmp = pos;
    
    for( y = 0; y < mvd.penDot.height; y++ )
    {
        pos.x = tmp.x;
        for( x = 0; x < mvd.penDot.width; x++ )
        {
            [self plot_sub];
            pos.x++;
        }
        pos.y++;
    }
    pos = tmp;
}

- (void)plotX:(NSInteger)x y:(NSInteger)y
{
    pos.x = x; pos.y = y;
    if ( mvd.penDot.width == 1 && mvd.penDot.height == 1 )
    {
        [self plot_sub];
    }
    else
    {
        [self plot];
    }
}

- (void)line
{
	int ix,iy,lx,ly,sy,ey,sx,ex ;
	double resio ;
	NSInteger osx, osy, oex, oey, tmp;
	osx = pre.x; osy = pre.y;
	oex = pos.x; oey = pos.y;
    NSPoint keepPos = pos;
	
	if ( osx == oex ) 
	{
		if ( oey <= osy ) 
		{
            tmp = osy; osy = oey; oey = tmp;
        }
        for ( iy = osy ; iy <= oey ; ++iy ) 
        {
            [self plotX:osx y:iy];
        }
    }
	else if ( osy == oey )
	{
		if ( oex <= osx ) 
		{
            tmp = osx; osx = oex; oex = tmp;
        }
        for ( ix = osx ; ix <= oex ; ++ix )
        {
            [self plotX:ix y:osy];
        }
    }
	else
	{
		if( osx > oex )
		{
			tmp = osx; osx = oex; oex = tmp;
			tmp = osy; osy = oey; oey = tmp;
		}
        [self plotX:osx y:osy];
        
		lx = oex - osx + 1 ;
		if ( osy <= oey )
		{
			ly = oey -osy + 1 ;
 			if( lx >= ly )
			{
				resio = ly ;
				resio /= lx ;
				sy = 0 ;
				for ( ix = 0 ; ix < lx ; ix++ )
				{
					ey = ( ix + 0.5 ) * resio ;
					if( !mvd.sutekake )
					{
						[self plotX:osx +ix y:osy +ey];
					}
					else
					{
						for( iy = sy ; iy <= ey ; ++iy )
						{
                            [self plotX:osx +ix y:osy +iy];
						}
					 	if( sy < ey ) { sy = ey ; }
                    }
                }
            }
			else
			{
				resio = lx ;
				resio /= ly;
				sx = 0 ;
				for( iy = 0 ; iy < ly ; iy++ )	
				{
					ex = ( iy + 0.5 ) * resio ;			
					if( !mvd.sutekake )
					{
                        [self plotX:osx +ex y:osy +iy];
                    }
					else
					{
						for( ix = sx ; ix <= ex ; ++ix )
						{
                            [self plotX:osx +ix y:osy +iy];
                        }
						if( sx < ex ) { sx = ex ; }
                    }
                }
            }
        }
		else
		{
			ly = osy - oey + 1 ;
			if( lx >= ly )
			{
				resio = ly ;
				resio /= lx;
				sy = 0 ;
				for( ix = 0 ; ix < lx ; ++ix )
				{
					ey = ( ix + 0.5 ) * resio ;
					if( !mvd.sutekake )
					{
                        [self plotX:osx +ix y:osy -ey];
                    }
					else
					{
						for( iy = sy ; iy <= ey ; ++iy )
						{
                            [self plotX:osx +ix y:osy -iy];
                        }
						if( sy < ey ) { sy = ey ; }
                    }
                }
            }
			else
			{
				resio = lx ;
				resio /= ly ;
				sx = 0 ;
				for( iy = 0 ; iy < ly ; ++iy )
				{
					ex = ( iy + 0.5 ) * resio ;
					if( !mvd.sutekake )
					{
                        [self plotX:osx +ex y:osy -iy];
                    }	
					else
					{
						for( ix = sx ; ix <= ex ; ++ix )
						{
                            [self plotX:osx +ix y:osy -iy];
                        }
						if( sx < ex ) { sx = ex ; }
                    }
                }
            }
        }
        [self plotX:oex y:oey];
    }
    
    pos = keepPos;
}

- (void)rect
{
    NSPoint st = pre;
    NSPoint ed = pos;
    
    pre = st;
    pos = NSMakePoint(ed.x, st.y);
    [self line];
    pre = pos;
    pos = ed;
    [self line];
    pre = pos;
    pos = NSMakePoint(st.x, ed.y);
    [self line];
    pre = pos;
    pos = st;
    [self line];
    
    pre = st;
    pos = ed;
}

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

- (void)fillRect
{
    NSRect rect = [self rectFromPosition];
    NSInteger i = 0;
    pre.x = rect.origin.x;
    pos.x = pre.x + rect.size.width -1;
    for ( i = 0; i < rect.size.height; i++ )
    {
        pre.y = i + rect.origin.y;
        pos.y = i + rect.origin.y;
        [self line];
    }
}

- (void)paint2
{
    
}

- (void)paint
{
    myDraw_dispatch( &myd );
    [view setNeedsDisplay:YES];
}

#pragma mark - Circle

enum { CIRCLE_EVEN = 1, CIRCLE_ODD, EVEN_X, EVEN_Y, EVEN_XY };
NSInteger circle_cx, circle_cy, circle_sw;

- (void)ellipse_PlotX:(NSInteger)x y:(NSInteger)y x1:(NSInteger)x1 y1:(NSInteger)y1
{
    if (circle_sw == EVEN_XY || circle_sw == EVEN_X )
        circle_cx--;
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy--;
    [self myid_plotX:circle_cx +x y:circle_cy +y1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy++;
    [self myid_plotX:circle_cx +x y:circle_cy -y1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_X )
        circle_cx++;
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy--;
    [self myid_plotX:circle_cx -x y:circle_cy +y1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy++;
    [self myid_plotX:circle_cx -x y:circle_cy -y1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_X )
        circle_cx--;
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy--;
    [self myid_plotX:circle_cx +y y:circle_cy +x1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy++;
    [self myid_plotX:circle_cx +y y:circle_cy -x1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_X )
        circle_cx++;
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy--;
    [self myid_plotX:circle_cx -y y:circle_cy +x1];
    
    if (circle_sw == EVEN_XY || circle_sw == EVEN_Y )
        circle_cy++;
    [self myid_plotX:circle_cx -y y:circle_cy -x1];
}

- (void)circleInRect:(NSRect)rect
{
    NSInteger r = rect.size.width;
    
    if( !(r % 2) )
        circle_sw = EVEN_XY;
    else
        circle_sw = 0;
    
    r /= 2;
    circle_cx = rect.origin.x + r;
    circle_cy = rect.origin.y + r;
    
    NSInteger x, y;
    x = r;
    y = 0;
    for( ; y <= x; )
    {
        [self ellipse_PlotX:x y:y x1:x y1:y];
        if((r -= (y++ << 1) +1) <= 0 )
        {
            r += --x << 1;
        }
    }
}

- (void)ellipseInRect:(NSRect)rect
{
    NSInteger rx = rect.size.width;
    NSInteger ry = rect.size.height;
    
    if( !(rx % 2) )
        circle_sw = EVEN_X;
    else
        circle_sw = 0;
    
    if( !(ry % 2) )
    {
        if( circle_sw == EVEN_X )
            circle_sw = EVEN_XY;
        else
            circle_sw = EVEN_Y;
    }
    
    
    rx /= 2; ry /= 2;
    circle_cx = rect.origin.x + rx;
    circle_cy = rect.origin.y + ry;
    
    NSInteger x, y, r;
    NSInteger x1, y1;
    if( ry < rx )
    {
        x = r = rx;
        y = 0;
        for( ; y <= x; )
        {
            x1 = (x * ry) / rx;
            y1 = (y * ry) / rx;
            [self ellipse_PlotX:x y:y x1:x1 y1:y1];
            if((r -= (y++ << 1) +1) <= 0 )
            {
                r += --x << 1;
            }
        }
    }
    else
    {
        x = r = ry;
        y = 0;
        for( ; y <= x; )
        {
            x1 = (x * rx) / ry;
            y1 = (y * rx) / ry;
            [self ellipse_PlotX:x1 y:y1 x1:x y1:y];
            if((r -= (y++ << 1) +1) <= 0 )
            {
                r += --x << 1;
            }
        }
    }
}

- (void)circleWithFill:(BOOL)fill
{
    NSRect rect = [self rectFromPosition];
 
    if( fill == NO )
    {
        if( rect.size.width == rect.size.height )
            [self circleInRect:rect];
        else
            [self ellipseInRect:rect];
    }
    else
    {
        NSRect offsetRect = [self myid_initFromRect:rect];
        
        if( rect.size.width == rect.size.height )
            [self circleInRect:offsetRect];
        else
            [self ellipseInRect:offsetRect];

        myi.sx = circle_cx +1;
        myi.sy = circle_cy +1;
        
        myDraw_paint( &myi, 1 );
        NSInteger x, y;
        for( y = 0; y < myi.h; y++ )
        {
            for( x = 0; x < myi.w; x++ )
            {
                if( myi.d[y * myi.w +x] )
                {
                    [self plotX:x +rect.origin.x y:y +rect.origin.y];
                }
            }
        }
        
        
        [self myid_clear];
    }
}

- (void)allLine
{
    NSSize size = mvd.size;
    NSRect r;
    switch (funcCommand[9]) {
        case 'X':
            pre.x = 1;
            pos.x = size.width;
            pre.y = pos.y;
            break;
        case 'Y':
            pre.y = 1;
            pos.y = size.height;
            pre.x = pos.x;
            break;
            
        case 'M':
            r = NSMakeRect(pre.x, pre.y, (pos.x -pre.x +1), (pos.y -pre.y +1));
            if( r.size.width < 1 ) r.size.width -= 2;
            if( r.size.height < 1 ) r.size.height -= 2;
            
            pos = r.origin;
            for( ; pos.x <= size.width && pos.y <= size.height; )
            {
                pos.x += r.size.width;
                pos.y += r.size.height;
            }
            if( 0 < r.size.width ) pos.x--;
            if( 0 < r.size.height ) pos.y--;
            
            pre = r.origin;
            for( ; 1 <= pre.x && 1 <= pre.y; )
            {
                pre.x -= r.size.width;
                pre.y -= r.size.height;
            }
            if( r.size.width < 1 ) pos.x++;
            if( r.size.height < 1 ) pos.y++;
            break;
            
        default:
            return;
            
    }
    [self line];
}

#pragma mark - func

- (void)select4Command:(char *)cmd
{
    NSInteger ret = -1;
    
    MySelect4 *ms4 = [MySelect4 sharedManager];
    NSMutableArray *a = nil;
    MyDrawButtonFuncMenu *dbfm = nil;
    
    if( MY_CMP(cmd, "D_AllLine") )
    {
        a = [[NSMutableArray alloc] initWithCapacity:4];
        [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"D_AllLineX" menu:"All X direction"]];
        [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"D_AllLineY" menu:"All Y direction"]];
        [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"D_AllLineM" menu:"All Mouse"]];
        [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"A_Cancel" menu:"Cancel"]];
    }
    
    if( a != nil )
    {
        memset( funcCommand, 0, sizeof(funcCommand));
        enabled = NO;
        ret = [ms4 openWithArray:a];
    }
    if( 0 <= ret && ret <= 3 )
    {
        dbfm = [a objectAtIndex:ret];
        if( MY_CMP([dbfm funcCommand], "A_Cancel") )
        {
            dbfm = nil;
            [[MyInfo sharedManager] setFunction:""];
        }
    }

    if( dbfm != nil )
    {
        strncat(funcCommand, [dbfm funcCommand], sizeof(funcCommand) -1);
        [[MyInfo sharedManager] setFunction:funcCommand];
        enabled = YES;
    }
    [a release];
}

- (void)setRubberMode
{
    if ( MY_CMP(funcCommand, "D_Trace") ||
         MY_CMP(funcCommand, "D_AllLineM") )
    {
        [rubber setRubberType:RUBBER_LINE];
    }
    else if( MY_CMP(funcCommand, "D_Box") ||
             MY_CMP(funcCommand, "D_FillBox") )
    {
        [rubber setRubberType:RUBBER_RECT];
    }
    else if( MY_CMP(funcCommand, "D_Circle") ||
             MY_CMP(funcCommand, "D_FCircle") )
    {
        [rubber setRubberType:RUBBER_RECT | RUBBER_CIRCLE];
    }
    else
        [rubber setRubberType:RUBBER_NONE];

}

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv
{
    [super setCommand:cmd data:d rubber:rv];
    
    [self select4Command:cmd];
    
    [self setRubberMode];
}

- (BOOL)moveCommandCheck
{
    BOOL ret = NO;
    if( MY_CMP(funcCommand, "D_Trace") )
        ret = YES;
    else if( MY_CMP(funcCommand, "D_Box") )
        ret = YES;
    else if( MY_CMP(funcCommand, "D_FillBox") )
        ret = YES;
    else if( MY_CMP(funcCommand, "D_Circle") )
        ret = YES;
    else if( MY_CMP(funcCommand, "D_FCircle") )
        ret = YES;
    else if( MY_CMP(funcCommand, "D_AllLineM") )
        ret = YES;
    
    return ret;
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
    
    memset(&myd, 0, sizeof(myd));
    [mvd setMyDrawDst:&myd];

    if( MY_CMP(funcCommand, "D_FreeLine" ) )
    {
        [self plot];
    }
}

- (void)mouseUp:(NSPoint)po
{
    if( [super mouseUp:po] == NO )
        goto END_MOUSEUP;
    
    memset(&myd, 0, sizeof(myd));
    myd.cmd = &funcCommand[0];
    [mvd setMyDrawDst:&myd];
    myd.dst.sx = pos.x -1;
    myd.dst.sy = pos.y -1;
    
    if( MY_CMP(funcCommand, "D_Plot" ) )
    {
        [self plot];
    }
    else if( MY_CMP(funcCommand, "D_Trace") )
    {
        if( NSEqualPoints( [rubber startPoint], NSZeroPoint ) == NO )
        {
            pre = [rubber startPoint];
            [self line];
        }
        [rubber setPosition:pos];
    }
    else if( MY_CMP(funcCommand, "D_Box") ||
             MY_CMP(funcCommand, "D_FillBox") ||
             MY_CMP(funcCommand, "D_Circle") ||
             MY_CMP(funcCommand, "D_FCircle") )
    {
        if( NSEqualPoints( [rubber startPoint], NSZeroPoint ) == NO )
        {
            pre = [rubber startPoint];
            if( funcCommand[2] == 'F' && funcCommand[3] == 'i' )
                [self fillRect];
            else if (funcCommand[2] == 'B' )
                [self rect];
            else if (funcCommand[2] == 'F' )
                [self circleWithFill:YES];
            else
                [self circleWithFill:NO];
            
            [rubber cancel];
        }
        else
            [rubber setPosition:pos];
    }
    else if( MY_CMP(funcCommand, "D_AllLineX" ) ||
             MY_CMP(funcCommand, "D_AllLineY" ) )
    {
        [self allLine];
    }
    else if( MY_CMP(funcCommand, "D_AllLineM") )
    {
        if( NSEqualPoints( [rubber startPoint], NSZeroPoint ) == NO )
        {
            pre = [rubber startPoint];
            [self allLine];
            [rubber cancel];
        }
        else
            [rubber setPosition:pos];
    }
    else if( MY_CMP(funcCommand, "D_Paint2") )
    {
        [self paint2];
    }
    else if( MY_CMP(funcCommand, "D_Paint") )
    {
        [self paint];
    }

END_MOUSEUP:
    [super mouseFinishedUp];
}

- (void)mouseDragged:(NSPoint)po
{
    if( [super mouseDragged:po] == NO ) return;
    
    memset(&myd, 0, sizeof(myd));
    [mvd setMyDrawDst:&myd];

    if( MY_CMP(funcCommand, "D_FreeLine" ) )
    {
        [self line];
    }
    
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
