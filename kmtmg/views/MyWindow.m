#import "MyWindow.h"
#import "../MyDefines.h"

@implementation MyWindow

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void) awakeFromNib
{
    [self setAcceptsMouseMovedEvents:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayProfileChanged:)
                                                 name:NSApplicationDidChangeScreenParametersNotification object:nil];
}

- (BOOL)allowsConcurrentViewDrawing
{
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)acceptsTouchEvents
{
    return YES;
}

- (BOOL)displaysWhenScreenProfileChanges
{
    return YES;
}

- (void)displayProfileChanged:(NSNotification*)notification
{
    NSScreen *screen = [self screen];
    if( screen == nil )
        screen = [NSScreen mainScreen];
    
    NSRect main = [screen visibleFrame];
    MyLog(@"screen size:%@", NSStringFromRect(main));
    [self setMaxSize:main.size];
    
    NSRect mine = [self frame];
    
    if( main.size.width < mine.size.width )
        mine.size.width = main.size.width;
    if( main.size.height < main.size.height )
        mine.size.height = main.size.height;
    
    [self setFrame:mine display:YES];
    [self center];
}

@end
