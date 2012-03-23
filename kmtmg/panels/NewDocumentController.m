#import "NewDocumentController.h"
#import "MyDocument.h"
#import "../MyDefines.h"
#import "NSMatrix+MyModify.h"

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

#define MAX_WIDTH 40000
#define MAX_HEIGHT 40000
enum { TYPE_HEIGHT = 1, TYPE_NAME = 2, TYPE_WIDTH };

- (void)checkSetData:(NSInteger)type
{
	NSButton *btn = [oPanel getObjectName:"NSButton" tag:10];
	
	if( 1.0 <= iWidth &&  iWidth <= MAX_WIDTH &&
        1.0 <= iHeight && iHeight <= MAX_HEIGHT &&
       0 < [iName length])
    {
		[btn setEnabled:YES];
    }
	else
    {
		[btn setEnabled:NO];
        
		NSMutableString *alertMessage = [NSMutableString stringWithFormat:@""];
		
        if (type == TYPE_WIDTH) 
        {
            if( iWidth < 1.0 )
                [alertMessage appendFormat:@"Width is 1 pixel under."];
            if( MAX_WIDTH < iWidth )
                [alertMessage appendFormat:@"Maximum Width is 40000 pixel."];
        }
        if( type ==TYPE_HEIGHT )
        {
            if( iHeight < 1.0 )
                [alertMessage appendFormat:@"Height is 1 pixel under."];
            if( MAX_HEIGHT < iHeight )
                [alertMessage appendFormat:@"Maximum Height is 40000 pixel."];
        }
        if( type == TYPE_NAME )
        {
            if( [iName length] < 1 )
                [alertMessage appendFormat:@"Name is nothing!!"];
        }
        
        if( 0 < [alertMessage length] )
        {
        
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
	
}

- (IBAction)background:(id)sender
{
	[iBackground autorelease];
	iBackground = [[sender color] retain];
	// [self checkSetData];
}

- (IBAction)height:(id)sender
{
	iHeight = [sender floatValue];
	[self checkSetData:TYPE_HEIGHT];
}

- (IBAction)name:(id)sender
{
	if( iName != nil )
		[iName release];
	iName = [sender stringValue];
	[iName retain];
	[self checkSetData:TYPE_NAME];
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
	[self name:[oPanel getObjectName:"NSTextField" tag:1000]];
	[self width:[oPanel getObjectName:"NSTextField" tag:1001]];
	[self height:[oPanel getObjectName:"NSTextField" tag:1002]];
	[self background:[oPanel getObjectName:"NSColorWell" tag:1003]];
	
    [oPanel setTag:YES];
}

- (IBAction)width:(id)sender
{
	iWidth = [sender floatValue];
	[self checkSetData:TYPE_WIDTH];
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
    [selectedPalette changeColorString:[NSColor whiteColor]];

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
