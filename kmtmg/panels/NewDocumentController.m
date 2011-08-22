#import "NewDocumentController.h"
#import "MyDocument.h"
#import "../MyDefines.h"

@implementation NewDocumentController

@synthesize bNewDocument;

static NewDocumentController *sharedNewDocumentControllerManager = NULL;

#pragma mark - Singleton

+ (NewDocumentController *)sharedManager
{
	@synchronized(self)
	{
		// MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedNewDocumentControllerManager == Nil )
			[[self alloc] init];
	}
	
	return sharedNewDocumentControllerManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedNewDocumentControllerManager == Nil )
		{
			sharedNewDocumentControllerManager = [super allocWithZone:zone];
			return sharedNewDocumentControllerManager;
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

- (id)getObjectName:(char *)name tag:(int)n
{
	NSArray *a = [[oPanel contentView] subviews];
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
}

- (void)checkSetData
{
	NSButton *btn = [self getObjectName:"NSButton" tag:10];
	
	if( 1.0 <= iWidth && 1.0 <= iHeight && 0 < [iName length])
		[btn setEnabled:YES];
	else
		[btn setEnabled:NO];
	
}

- (IBAction)background:(id)sender
{
	[iBackground autorelease];
	iBackground = [[sender color] retain];
	[self checkSetData];
}

- (IBAction)disclogure:(id)sender
{
}

- (IBAction)height:(id)sender
{
	iHeight = [sender floatValue];
	[self checkSetData];
}

- (IBAction)name:(id)sender
{
	if( iName != nil )
		[iName release];
	iName = [sender stringValue];
	[iName retain];
	[self checkSetData];
}

- (void)alertDidEnd:(NSAlert *)alert
         returnCode:(int)returnCode 
        contextInfo:(void *)contextInfo
{
	MyLog( @"%d",returnCode);
}

- (IBAction)cancel:(id)sender
{
    [oPanel setTag:NO];
}

- (IBAction)set:(id)sender
{
	[self name:[self getObjectName:"NSTextField" tag:1000]];
	[self width:[self getObjectName:"NSTextField" tag:1001]];
	[self height:[self getObjectName:"NSTextField" tag:1002]];
	[self background:[self getObjectName:"NSColorWell" tag:1003]];
	
	if( [[self getObjectName:"NSButton" tag:10] isEnabled] == YES )
    {
        [oPanel setTag:YES];
    }
	else
	{
		NSMutableString *alertMessage = [NSMutableString stringWithFormat:@""];
		
		if( iWidth < 1.0 )
			[alertMessage appendFormat:@"Width is 1 pixel under."];
		if( iHeight < 1.0 )
			[alertMessage appendFormat:@"Height is 1 pixel under."];
		if( [iName length] < 1 )
			[alertMessage appendFormat:@"Name is nothing!!"];
		 
		NSAlert *alert = [NSAlert alertWithMessageText:@"alertWithMessageText" 		defaultButton:@"Confirm" 
			alternateButton:nil //@"alternateButton"
			otherButton:nil //@"otherButton" 
			informativeTextWithFormat:alertMessage];
        
		[alert beginSheetModalForWindow:oPanel
			modalDelegate:self
			didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
			contextInfo:nil];
	}
}

- (IBAction)width:(id)sender
{
	iWidth = [sender floatValue];
	[self checkSetData];
}

- (id)init
{
	self = [super init];
	if( self != nil )
	{
        [NSBundle loadNibNamed: @"NewDocumentPanel" owner:self];
		iWidth = iHeight = 0;
		iName = nil;
		iBackground = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		[iBackground retain];
	}
	
	return self;
}

- (void)dealloc
{
	MyLog( @"dealloc:%@ ",[self className] );
	
	if( iName != nil )
		[iName release];
	[iBackground release];
	[super dealloc];
}


- (BOOL) open
{    
    bNewDocument = [NSApp runModalForWindow:oPanel];
    
    return bNewDocument;
}

- (void) setNewDocumentSetting:(MyViewData *)mvd
{
    [mvd setSize:NSMakeSize(iWidth, iHeight)];
    [mvd setName:iName];
	[mvd setBackground:iBackground];
    
    [mvd setImageWithSize:[mvd size]];
    
    mvd.bEnabled = YES;
}



@end
