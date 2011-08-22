#import "MyHScrollView.h"
#import "../MyDefines.h"

@implementation MyHScrollView

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
    BOOL originRight = [iData originRight];
    
	i = 0;
	x = iData.startPosition.x;
    // MyLog( @"iBase:%.3f", iBase );
    
	y = rect.size.height /3;
	
	[[NSColor whiteColor] set];
	path = [NSBezierPath bezierPath];
	for( ; x < rect.size.width; )
	{
		n = [self displayNumber:i];
        if( 0.0f <= iBase )
        {
            if( originRight == YES )
                n--;
            else
                n++;
        }
        
		if( (!(n % 10) && n) || !n )
		{
           //  MyLog(@"x:%.3f, n:%3d", x, n);
            [gc setShouldAntialias:YES];
			size = [self drawNum:n pos:NSMakePoint(x,y) ];
            [gc setShouldAntialias:NO];
			[path moveToPoint:NSMakePoint( x, 1 )];
			[path lineToPoint:NSMakePoint( x, y +3 )];
			
			if( iInc < (size.width + iGap))
			{
                for( n = 1; (n * iInc) < (size.width + iGap); n++ );
				i += n;
                n *= iInc;
				x += n;
			}
			else
			{
				x += iInc;
				i++;
			}
		}
		else
		{
			i++;
			x += iInc;
		}
	}
	[path stroke];
    
    [gc restoreGraphicsState];
}


@end
