#import "MyToolBar.h"
#import "configController.h"
#import "MyDrawButton.h"
#import "../MyDefines.h"
#import "ToolBarController.h"

@implementation MyToolBar

@synthesize tc;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)hideButtons
{
	int i;
	for( i = 1; i <= 8; ++i )
		[[self buttonFunc:i] setFuncName:NULL menuName:NULL];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    	
	cntlCfgs = Nil;
	[self hideButtons];
	
	/*
	NSArray *a = [[self contentView] subviews];
	NSString *s;
	NSButton *b;
	int i;
	for( i = 0; i < [a count]; ++i )
	{
		s = [[a objectAtIndex:i] className];
		if( !strncmp( [s UTF8String], "NSButton", 8 ) )
		{
			b = [a objectAtIndex:i];
			MyLog( @"[%2d] > Tag[%4d]:%@", i, [b tag], s );
		}
	}
	*/
}

/*
- (id)getObjectName:(char *)name tag:(int)n
{
	NSArray *a = [[self contentView] subviews];
	NSString *s;
	id obj;
	int i;
	for( i = 0; i < [a count]; ++i )
	{
		s = [[a objectAtIndex:i] className];
		if( !strncmp( [s UTF8String], name, strlen(name) ) )
		{
			obj = [a objectAtIndex:i];
			if( [obj tag] == n ) return obj;
		}
	}
	
	return Nil;
}*/

-(void) updatePageNumber:(int)i max:(int)m
{
	id obj = [self getObjectName:"NSTextField" tag:9098];
	
	[obj setStringValue:[NSString stringWithFormat:@"Page:%d/%d",i,m]];
}

#pragma mark -

- (MyDrawButton *)buttonMode:(int)mode
{
	if( mode < CFGMODE_NOSELECT )
		mode = CFGMODE_NOSELECT;
	if( CFGMODE_MAX <= mode )
		mode = CFGMODE_MAX;
		
	return (MyDrawButton *)[self getObjectName:"MyDrawButton" tag:mode];
}

- (MyDrawButton *)buttonFunc:(int)index
{
	if( index < 1 ) index = 1;
	if( 8 < index ) index = 8;
	
	return (MyDrawButton *)[self getObjectName:"MyDrawButton" tag:index];
}

-(void) updatePage
{
	int i;
	NSSlider *page = [self getObjectName:"NSSlider" tag:9099];
	ConfigData *d;
	
	[self hideButtons];
	for( i = 0; i < [cntlCfgs count]; ++i )
	{
		d = [cntlCfgs objectAtIndex:i];
		if( [d toolPage] != [page intValue] )
			continue;
		[[self buttonFunc:[d tool].index] setFuncName:[d func] menuName:[d menu]];
		[self updatePageNumber:[page intValue] max:[page maxValue]];
	}
}

-(void) setConfigArray:(NSArray *)array
{
	if( cntlCfgs != array )
	{
		cntlCfgs = array;
		[self updatePage];
	}
}

-(void) setPageMax:(int)m
{
	id obj = [self getObjectName:"NSSlider" tag:9099];
	[obj setMaxValue:m];
	[obj setNumberOfTickMarks:m];

	[self updatePageNumber:[obj intValue] max:[obj maxValue]];
}

-(NSString *)menuForFunc:(char *)func
{
	int i;
	ConfigData *d;
	
	for( i = 0; i < [cntlCfgs count]; ++i )
	{
		d = [cntlCfgs objectAtIndex:i];
		if( strncmp( [d func], func, strlen(func) ) )
			continue;
		return [d menu];
	}
	
	return Nil;
}

#pragma mark -

-(void) pageChange
{
	id obj = [self getObjectName:"NSSlider" tag:9099];
	
	if( [obj maxValue] == 1 ) return;
	
	int i = [obj intValue] +1;
	if( [obj maxValue] < i )
		i = 1;
		
	[obj setIntValue:i];
	[self updatePage];
}

- (void)pressSpaceKey
{
    [self pageChange];
}

- (void)pressTabKey
{
    [tc changeNextMode];
}

- (void)keyDown:(NSEvent *)e
{
	if( [e keyCode] == VKEY_ESC )
	{
		[self close];
	}
	else if( [e keyCode] == VKEY_SPACE )
	{
		[self pressSpaceKey];
	}
	else if( [e keyCode] == VKEY_TAB )
	{
		[self pressTabKey];
	}

}

@end
