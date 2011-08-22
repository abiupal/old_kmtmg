#import "ToolBarController.h"
#import "../MyDefines.h"
#import "MyToolBar.h"

static ToolBarController *sharedToolBarControllerManager = NULL;

@implementation ToolBarController

+ (ToolBarController *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedToolBarControllerManager == Nil )
			[[self alloc] init];
	}
	
	return sharedToolBarControllerManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedToolBarControllerManager == Nil )
		{
			sharedToolBarControllerManager = [super allocWithZone:zone];
			return sharedToolBarControllerManager;
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
	if( self )
	{
		[[NSNotificationCenter defaultCenter] addObserver:self 
			selector: @selector(applicationWillFinishLaunching:)
			name: @"NSApplicationWillFinishLaunchingNotification"
			object:NSApp];
			
		cntlCfg = [ConfigController sharedManager];
	}
	return self;
}

- (void)dealloc
{
	MyLog( @"dealloc:%@ ",[self className] );
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

#pragma mark -

- (void)pressButton:(char *)funcName
{
	if( funcName != Nil )
		[oTool close];
    
	// MyLog( @"select func:%s", funcName );
	[cntlCfg function:funcName];
}

- (void)pressMode:(int)tag
{
	// MyLog( @"pressMode:Hidden:%d", [[oTool buttonMode:tag] isHidden]);
	int m = [cntlCfg maxPage:tag];
	// MyLog( @"pressMode >tag:%4d,MaxPage:%d", tag, m );
	
	// isHidden canNot use
	if( !m ) return;
	
	[cntlCfg setMode:tag];
	[oTool setPageMax:m];
	for( m = CFGMODE_NOSELECT; m < CFGMODE_MAX; ++m )
	{
		if( tag == m )
			[[oTool buttonMode:m] setState:NSOnState];
		else
			[[oTool buttonMode:m] setState:NSOffState];
	}
	[oTool setConfigArray:[cntlCfg tool:tag]];
}

#pragma mark -

- (void)openToolBar
{
	[self pressMode:[cntlCfg mode]];
    
	[NSApp runModalForWindow:oTool];
}

- (IBAction)aPage:(id)sender
{
	[oTool updatePage];
}


- (IBAction)aButton:(id)sender
{
	[self pressButton:[sender funcName]];
}

- (IBAction)aMode:(id)sender
{
	[self pressMode:[sender tag]];
}

#pragma mark -

- (void) applicationWillFinishLaunching:(NSNotification *)notification
{	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menuconfig" ofType:@"config"];
	[cntlCfg setPath:path];
	
	MyLog( @"applicationWillFinishLaunching:%@ ",[self className] );
    
	int m;
	ConfigData *d;
	for( m = CFGMODE_NOSELECT; m < CFGMODE_MAX; ++m )
	{
		if( 0 < [cntlCfg maxPage:m] )
		{
			d = [[cntlCfg tool:m] objectAtIndex:0];
			[[oTool buttonMode:m] setFuncName:"TOOLMODE" menuName:[d superMenu]];
		}
	}
	// Remove Notification
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: @"NSApplicationWillFinishLaunchingNotification"
                                                  object: NSApp];
}

@end
