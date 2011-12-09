
#import "MyScrollView.h"
#import "MyViewData.h"
#import "../panels/MyInfo.h"
#import "NSMutableAttributedString+MyModify.h"

@implementation MyScrollView


- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil)
	{
		iBase = 0;
		iInc = 1;
		iGap = 10;
		/* 9->15, 12->12  */
		iFont = [[MyInfo sharedManager] scrollerFont];
		iColor = [[NSColor whiteColor] retain] ;
		iType = SCROLL_H;
	}
	return self;
}

- (void)dealloc
{
	[iColor release];
    [super dealloc];
}

- (void)setMyViewData:(MyViewData *)data scrollBar:(NSScroller *)scroll;
{
	iData = data;
    iScroll = scroll;
}

#pragma mark -

- (void)setBaseData:(CGFloat)base inc:(CGFloat)inc;
{
	iBase = base;
	iInc = inc;
	[self checkUpdateData];
}

- (NSSize)drawNum:(CGFloat)n pos:(NSPoint)pos
{
	NSMutableAttributedString *string;
	NSSize size;
	
	if( iType == SCROLL_V )
	{
		string = [[[NSMutableAttributedString alloc] 
			initWithString:[NSString stringWithFormat:@"%5d", (int)n]]
			autorelease];
	}
	else if( n < 10 )
	{
		string = [[[NSMutableAttributedString alloc] 
			initWithString:[NSString stringWithFormat:@"%d", (int)n]]
			autorelease];
	}
	else if( n < 100 )
	{
		string = [[[NSMutableAttributedString alloc] 
			initWithString:[NSString stringWithFormat:@"%2d", (int)n]]
			autorelease];
	}
	else if( n < 1000 )
	{
		string = [[[NSMutableAttributedString alloc] 
			initWithString:[NSString stringWithFormat:@"%3d", (int)n]]
			autorelease];
	}
	else if( n < 10000 )
	{
		string = [[[NSMutableAttributedString alloc] 
			initWithString:[NSString stringWithFormat:@"%4d", (int)n]]
			autorelease];
	}
	else
	{
		string = [[[NSMutableAttributedString alloc] 
			initWithString:[NSString stringWithFormat:@"%5d", (int)n]]
			autorelease];
	}

    [string changeStringColor:iColor withFont:iFont];
	
	size = [string size];
    /*
	if( iType == SCROLL_H )
	{
		switch( iData.originType )
		{
		case MVD_ORIGIN_LU:
		case MVD_ORIGIN_LD:
			pos.x -= size.width;
			break;
		}
	}
	else*/
    if( iType == SCROLL_V )
        pos.y -= size.height;
    else
        pos.x -= size.width;
    
	[string drawAtPoint:pos];
	
	return size;
}

- (CGFloat)displayNumber:(CGFloat)n
{
	NSInteger base = iBase;
	
	NSSize size = [iData size];
	if( iType == SCROLL_V )
	{
		switch( iData.originType )
		{
		case MVD_ORIGIN_RU:
		case MVD_ORIGIN_LU:
			base = (NSInteger)(size.height) -base;
			n *= -1; break;
		}
	}
	else
	{
		switch( iData.originType )
		{
		case MVD_ORIGIN_RU:
		case MVD_ORIGIN_RD:
			base = (NSInteger)(size.width) -base;
			n *= -1; break;
		}
	}
	n += base;
    	
	return n;
}

- (void)checkUpdateData
{
	[self setNeedsDisplay:YES];
    // MyLog( @"checkUpdateData:%@", [self description] );
}


@end

