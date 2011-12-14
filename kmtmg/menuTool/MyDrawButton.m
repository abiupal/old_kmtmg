#import "MyDrawButton.h"
#import "MyDefines.h"

@implementation MyDrawButtonFuncMenu

@synthesize menuString;

- (id)initWithData:(const char *)f menu:(const char *)m
{
    self = [super init];
    if( self != nil )
    {
        strncat( &funcCommand[0], f, sizeof(funcCommand) -1 );
        menuString = [[NSString alloc] initWithUTF8String:m];
    }
    
    return self;
}

- (void)dealloc
{
    [menuString release];
    
    [super dealloc];
}

- (char *)funcCommand
{
    return &funcCommand[0];
}

@end

@implementation MyDrawButton

- (BOOL)checkImageNumberInput
{
    char *f = iFuncName + 12;
    NSString *imgName = nil;
    
    NSString *tag = [NSString stringWithFormat:@"%s",f];
    imgName = [[NSBundle mainBundle] pathForResource:tag ofType:@"png"];
    
    if( imgName != nil )
        iImage = [[[NSImage alloc] initWithContentsOfFile:imgName] retain];
    
    return (iImage ? YES : NO);
}

-(void) awakeFromNib
{
	iIcon = [MyDrawIcon sharedManager];
}

-(void) dealloc
{
    [iImage release];
	[iMenuName release];
	[super dealloc];
}

-(void) drawTextMenu:(NSPoint)pos
{
	NSAttributedString *string = [[NSAttributedString alloc] 
			initWithString:iMenuName];
	NSSize size = [string size];
	pos.x -= size.width /2;
	if( !strncmp( iFuncName, "TOOLMODE",8 ) )
		pos.y -= size.height /2;
	else
		pos.y -= size.height *1.5;
	
	[iIcon setOnShadow];
	[string drawAtPoint:pos];
	[iIcon setOffShadow];
}

-(void) drawIcon:(NSRect)rect
{
    if( iImage != nil )
    {
        [iImage drawInRect:rect 
                  fromRect:NSZeroRect
                 operation:NSCompositeSourceOver
                  fraction:1.0
            respectFlipped:YES
                     hints:nil];
    }
	else
    {
        [iIcon drawRect:rect func:iFuncName];
        [self drawTextMenu:NSMakePoint( NSMidX(rect), NSHeight(rect))];
    }
}

-(void) drawRect:(NSRect)rect
{
	if( iMenuName == NULL ) return;
	
	[super drawRect:rect];
		
	rect = [self frame];
	rect.origin = NSMakePoint( 0, 0 );
	if( !strncmp( iFuncName, "TOOLMODE",8 ) )
		[self drawTextMenu:NSMakePoint( NSMidX(rect), NSMidY(rect))];
	else
		[self drawIcon:rect];
		
	// MyLog( @"drawRect:%@", iMenuName );
}

-(void) setFuncName:(char *)func menuName:(NSString *)menu
{
	iFuncName = func;
    
    if( func != nil )
    {
        if( MY_CMP(iFuncName, "NumberInput_") )
        {
            [self checkImageNumberInput];
        }
    }
	if( menu != Nil )
	{
        if( [menu isEqualToString:iMenuName] == NO )
        {
            [menu retain];
		// MyLog( @"setFuncName:%s, m:%@",func,menu );
            [iMenuName release];
            iMenuName = menu;
        }
	}
	if( func == NULL )
		[self setHidden:YES];
	else
		[self setHidden:NO];
    
	[self setNeedsDisplay:YES];
}

-(char *) funcName
{
	return iFuncName;
}

@end
