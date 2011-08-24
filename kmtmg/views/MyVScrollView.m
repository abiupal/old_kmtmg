#import "MyVScrollView.h"
#import "../MyDefines.h"

@implementation MyVScrollView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil)
	{
		iType = SCROLL_V;
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	[[NSColor darkGrayColor] set];
    NSRectFill(rect);
	
	NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
	CGFloat i, x, y;
	NSInteger n ;
	NSSize size;
	NSBezierPath *path;
	BOOL originUp = [iData originUp];
    
	i = 0;
	x = 15; // 9
	// x = 10.0; // 12
	y = iData.startPosition.y;
    // MyLog( @"iBase:%.3f", iBase );
	
	[[NSColor whiteColor] set];
	path = [NSBezierPath bezierPath];
	for( ; y < rect.size.height; )
	{
		n = [self displayNumber:i];
        if( iBase < 0.0f )
        {
            if( originUp == YES )
                n++;
            else
                n--;
        }
        
		if( (!(n % 10) && n) || !n )
		{
            // MyLog(@"y:%.3f, n:%3d", y, n);
			[gc setShouldAntialias:YES];
			size = [self drawNum:n pos:NSMakePoint(x,y) ];
			[gc setShouldAntialias:NO];
			[path moveToPoint:NSMakePoint( rect.size.width -x -10, y)];
			[path lineToPoint:NSMakePoint( rect.size.width, y)];
			
			if( iInc < (size.height + iGap))
			{
                for( n = 1; (n * iInc) < (size.height + iGap); n++ );
				i += n;
                n *= iInc;
				y += n;
			}
			else
			{
                i++;
				y += iInc;
			}
		}
		else
		{
			i++;
			y += iInc;
		}
	}
	[path stroke];
    [gc restoreGraphicsState];
}

@end
