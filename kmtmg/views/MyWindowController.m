
//
//  MyWindowController.m
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyWindowController.h"
#import "../menuTool/ToolBarController.h"
#import "../MyDefines.h"
#import <IoCGS/MyOS.h>
#import "../panels/MyPalette.h"
#import "../panels/MyInfo.h"
#import "../funcs/MyDrawingManager.h"
#import "../funcs/MyEditingManager.h"
#import "MyColorData.h"
#import "MyLayerWindow.h"
#import "MyLayerView.h"
#import "MyRubberView.h"
#import "../panels/MySelect4.h"
#import "../panels/MyTopSsk.h"

@implementation MyWindowController

static char *origin[4] = { "M_ORIGIN_LU", "M_ORIGIN_LD", "M_ORIGIN_RU", "M_ORIGIN_RD" };
static char *kakesute[2] = { "M_SUTEKAKE_SUTE", "M_SUTEKAKE_KAKE"};
static char *effectIgnore[3] = { "M_EFFECTIGNORE_NONE", "M_EFFECTIGNORE_EFFECT", "M_EFFECTIGNORE_IGNORE" };

@synthesize mvd;
@synthesize oView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        mvd = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [mvd release];
    [super dealloc];
}

#pragma mark - View Data

- (void)resizeWithoutData:(BOOL)enabled
{
	NSSize size = mvd.size;
	NSPoint po = mvd.pixel;
	NSRect m = [[NSScreen mainScreen] visibleFrame];
	size.width *= po.x;
	size.height *= po.y;
	po.x = m.size.width;
    po.y = m.size.height; // (CGFloat)MVD_NOSPACE_DEFAULT;
	size.width += po.x * 2;
	size.height += po.y * 2;
	
	NSClipView *cv = [oScrollView contentView];
	NSRect r = [cv frame];
    r.size.width -= [oLRSplit dividerThickness];
    r.size.height -= [oUDSplit dividerThickness];
    
	if( size.width < NSWidth(r) )
	{
		// Disappeared NScroll for Update HSV
		[oScrollView updateScrolledHSView:0.0];
	}
	if( size.height < NSHeight(r) )
	{
		// Disappeared NScroll for Update VSV
		[oScrollView updateScrolledVSView:0.0];
	}
	
	if( size.width < VIEW_MIN_W )
	{
		po.x = (int)(VIEW_MIN_W -size.width) /2 +100;
		size.width = VIEW_MIN_W;
	}
	if( size.height < VIEW_MIN_H )
	{
		po.y = (int)(VIEW_MIN_H -size.height) /2 +100;
		size.height = VIEW_MIN_H;
	}
	mvd.noSpace = po;
    mvd.frameSize = size;
	
	// Maxinum Size Setting
	size = [NSScrollView
            frameSizeForContentSize:mvd.frameSize
            hasHorizontalScroller:[oScrollView hasHorizontalScroller]
            hasVerticalScroller:[oScrollView hasVerticalScroller]
            borderType:[oScrollView borderType] ];
	
	// Modified for MyScrollView Window Layout
	po = [oScrollView frame].origin;
	size.width += po.x;
	size.height += po.y; // SCROLLH_TOOL_H; // Check at IB and Pixie.app
	
	if( size.width < WINDOW_MIN_W )
		size.width = WINDOW_MIN_W;
	if( size.height < WINDOW_MIN_H )
		size.height = WINDOW_MIN_H;
    size.width += [oLRSplit dividerThickness];
    size.height += [oUDSplit dividerThickness];
    
    r.origin = NSZeroPoint;
    r.size = size;
    r = [NSWindow frameRectForContentRect:r
                                styleMask:[[self window] styleMask] ];
    [[self window] setMaxSize:r.size];
	
	// Check Screen Size
	if( r.size.width < m.size.width &&
        r.size.height < m.size.height )
	{
		[[self window] setContentSize:r.size];
	}
	else
	{
        // Split
        m.size.width -= [oLRSplit dividerThickness];
        m.size.height -= [oUDSplit dividerThickness];
		if( r.size.width < m.size.width )
			m.size.width = r.size.width;
		if( r.size.height < m.size.height )
			m.size.height = r.size.height;
        if( enabled == YES )
            [[self window] setFrame:m display:YES];
	}
    if( enabled == YES )
        [[self window] center];
    
    [oView setFrameSize:mvd.frameSize];
    MyLog(@"%@", NSStringFromSize(mvd.frameSize));
    
	po = mvd.pixel;
    CGFloat line, page, scale;
    line = 50; page = 200;
    scale = mvd.scale.x;
    if( 0 < scale && scale < 1 )
    {
        line *= (int)(1.0f / scale);
        page *= (int)(1.0f / scale);
    }
    else if( 5 < scale )
    {
        line /= 10;
        page /= 10;
    }
    line *= po.x;
    page *= po.x;
	[oScrollView setLineScroll:line]; // LineScroll: 5 pixel
	[oScrollView setPageScroll:page];// PageScroll:20 pixel
}

- (void)checkUpdateData
{
    [oScrollView setNeedsDisplay:YES];
	[oView checkUpdateData];
	[oHSview checkUpdateData];
	[oVSview checkUpdateData];
    
    oRubberView.scrollStart = oScrollView.startPosition;
    [oRubberView setNeedsDisplay:YES];
}


- (NSPoint)startPositionFromCenter:(NSPoint)center
{
    NSRect cr = [[oScrollView contentView] frame];

    NSPoint po;
    po.x = center.x - (cr.size.width / 2);
    po.y = center.y - (cr.size.height / 2);
    po.x += (CGFloat)mvd.noSpace.x;
    po.y += (CGFloat)mvd.noSpace.y;
    
    return po;
}

- (void)setMyViewData
{
	MyLog( @"setMyViewData:%@ ",[self className] );
	
	[oScrollView setMyViewData:mvd hsv:oHSview vsv:oVSview];
    [oScrollView setDocumentView:oView];
	[oView setMyViewData:mvd];
    [self resizeWithoutData:YES];
}


- (void)windowDidLoad
{
    [super windowDidLoad];
        
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    MyLog( @"windowDidLoad:%@ ",[self className] );
        
    [oOrigin setFuncName:origin[1] menuName:@"原点"];
    [self setMyViewData];
	[oOrigin setFuncName:origin[mvd.originType] menuName:NULL];
        
    NSPoint center = NSMakePoint(mvd.size.width / 2, mvd.size.height / 2);

    center = [self startPositionFromCenter:center];
    [oScrollView updateScrolledStartPosition:center];
    
	// [oGridColor setColor:[iData gridColor]];
        
    [oKakeSute setFuncName:kakesute[mvd.sutekake] menuName:@""];
    [oEffectIgnoreSrc setFuncName:effectIgnore[0] menuName:@""];
    [oEffectIgnoreDst setFuncName:effectIgnore[0] menuName:@""];
    
    [[ConfigController sharedManager] setMenuStatus:YES];
    
    oCursorWindow.type = LAYER_CURSOR;
    oCursorWindow.view = oScrollView;
    oCursorWindow.split = oUDSplit;
    [self.window addChildWindow:oCursorWindow ordered:NSWindowAbove];
    [oCursorWindow windowSizeChanged:nil];
    [[NSNotificationCenter defaultCenter] addObserver:oCursorWindow
                                             selector:@selector(windowSizeChanged:)
                                                 name:NSWindowDidResizeNotification object:[self window]];
    
    oRubberWindow.type = LAYER_RUBBER;
    oRubberWindow.view = oScrollView;
    oRubberWindow.split = oUDSplit;
    [self.window addChildWindow:oRubberWindow ordered:NSWindowAbove];
    [oRubberWindow windowSizeChanged:nil];
    [[NSNotificationCenter defaultCenter] addObserver:oRubberWindow
                                             selector:@selector(windowSizeChanged:)
                                                 name:NSWindowDidResizeNotification object:[self window]];
    
    oCursorView.mvd = mvd;
    oRubberView.mvd = mvd;
    oScrollView.oCursor = oCursorView;
    oScrollView.oRubber = oRubberView;
    
    [oRubberView setRubberType:RUBBER_NONE];
    
    [mvd setTopSsk:oTopSsk];
    
    [self checkUpdateData];
}

- (void)windowDidBecomeMain:(NSNotification *)aNotification
{    
    palette = [MyPalette sharedManager];
    info = [MyInfo sharedManager];
    
    draw = [MyDrawingManager sharedManager];
    if( [draw isEnabled] == NO ) draw = nil;
    else if( strlen( [draw funcCommand] ) )
    {
        draw.view = oView;
        [draw setCommand:[draw funcCommand] data:mvd rubber:oRubberView];
    }
    
    edit = [MyEditingManager sharedManager];
    if( [edit isEnabled] == NO ) edit = nil;
    else if( strlen( [edit funcCommand] ) )
        [edit setCommand:[edit funcCommand] data:mvd rubber:oRubberView];

    
    if( [[self window] isEqual:palette.currentWindow] == NO )
    {
        palette.currentButton = oPalette;
        palette.currentWindow = [self window];
        palette.scroll.keyWindow = [self window];
        [palette setPaletteArray:[mvd palette]];
        [palette drawIcon];
        
        if( [mvd effectIgnoreSrc] || [mvd effectIgnoreDst] )
            [palette setEffectIgnore:mvd.palette];
    }
    
    
    if( [[self window] isEqual:info.currentWindow] == NO )
    {
        info.currentButton = oInfo;
        info.currentInfoView = oInfoView;
        info.currentWindow = [self window];
        info.scroll.keyWindow = [self window];
        [info setImageFraction:mvd.backgroundFraction];
        info.dotSize = mvd.penDot;
        info.ratio = mvd.ratio;
        [info setScale:mvd.scale.x];
        
        [self setPenColorFromPaletteNo:mvd.penColorNo];
        
        [info drawIcon];
    }
    
    // [self showWindow:nil];

        
    MyLog( @":%@ %@",[self className], mvd.name );
}

- (void)windowDidResignMain:(NSNotification *)aNotification
{
    palette.currentButton = nil;
    palette.currentWindow = nil;
    palette.scroll.keyWindow = nil;
    palette = nil;
    info.currentWindow = nil;
    info.scroll.keyWindow = nil;
    info = nil;
    draw = nil;
    edit = nil;
    
    MyLog( @":%@ %@",[self className], mvd.name );
}


- (void)windowWillClose:(NSNotification *)notification
{
    [self windowDidResignMain:nil];
    
    [[self window] removeChildWindow:oCursorWindow];
    [[self window] removeChildWindow:oRubberWindow];
    [oCursorWindow close];
    [oRubberWindow close];
    
    [self autorelease];
}
 

#pragma mark - Setter

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)name
{
    NSSize size = [mvd size];
    if ( name != nil ) {
        NSArray *a = [name componentsSeparatedByString:@"."];
        NSString *newName = [a objectAtIndex:0];
        if( mvd.name == nil || (mvd.bSaved == YES && [mvd.name isEqualToString:newName] == NO) )
        {
            mvd.name = newName;
            mvd.bSaved = NO;
        }
        
    }

    NSString *string = [NSString stringWithFormat:@"%@ - %.0f x %.0f", [mvd name], size.width, size.height];
    return [super windowTitleForDocumentDisplayName:string];
}

- (void)setCenterViewFromImagePosition:(NSPoint)center
{
    center.x *= mvd.pixel.x;
    center.y *= mvd.pixel.y;
    
    [self resizeWithoutData:NO];
    
    center = [self startPositionFromCenter:center];
    [oScrollView updateScrolledStartPosition:center];
    
    [self checkUpdateData];
}
- (void)setCenterFromInfoAutoCenter:(BOOL)flag
{
    NSPoint center;
    if( flag == YES )
    {
        center = info.prePosition;
        if( center.x < 0 || center.y < 0 ) flag = NO;
        if( mvd.size.width < center.x ||
            mvd.size.height < center.y ) flag = NO;
    }
    
    if( flag == NO )
        center = [oView centerPositionUpdateRect];
    
    [self setCenterViewFromImagePosition:center];
}

- (void)setScale:(CGFloat)f autoPosition:(BOOL)flag
{
	if( f < 0.03125 )
		f = 0.03125;
	else if( 20.0 < f ) 
		f = 20.0;
	
	if( f < 1.0 )
	{
		int i = 2;
		for( ;(f * i) < 1.0; i += 2 )
			;
	}
	
	if( mvd.scale.x == f ) return;
        
    [info setScale:f];

    [mvd setScale:NSMakePoint(f,f)];
    
    [self setCenterFromInfoAutoCenter:flag];
}

- (void)setScalePlus:(BOOL)flag
{
	CGFloat n = mvd.scale.x;
	if( n < 1.0 )
		n *= 2;
	else
		++n;
	[self setScale:n autoPosition:flag];
}

- (void)setScaleMinus:(BOOL)flag
{
    CGFloat n = mvd.scale.x;
	if( n <= 1.0 )
		n /= 2;
	else
		--n;
	[self setScale:n autoPosition:flag];
}

- (void)setPenColorFromPaletteNo:(NSInteger)palNo
{
    [mvd setPenFromPalette:palNo];
    
    if( info != nil )
        [info penColor:mvd.penColor palNo:palNo +1];
}

- (void)pressPaletteNo:(NSInteger)palNo pos:(NSPoint)pos
{    
    BOOL ret = NO;
    if( 0 < pos.x )
    {
        if( pos.y < 10 )
            ret = [mvd setEffectIgnoreFlagAtPaletteNo:palNo src:NO];
        else if( 20 < pos.y )
            ret = [mvd setEffectIgnoreFlagAtPaletteNo:palNo src:YES];
    }
    if( ret == YES )
        [palette setEffectIgnorePalNo:palNo colorData:[mvd.palette objectAtIndex:palNo]];
    else
        [self setPenColorFromPaletteNo:palNo];
}

#pragma mark - Action

- (IBAction)pOrigin:(id)sender
{
	int n;
	char *p =  [sender funcName] +2; // "M_" == 2
	
    MyLog(@"%s", p);
	if( !strncmp( p, "ORIGIN_LU", 9 ) )
		n = MVD_ORIGIN_LD;
	else if( !strncmp( p, "ORIGIN_LD", 9 ) )
		n = MVD_ORIGIN_RD;
	else if( !strncmp( p, "ORIGIN_RU", 9 ) )
		n = MVD_ORIGIN_LU;
	else if( !strncmp( p, "ORIGIN_RD", 9 ) )
		n = MVD_ORIGIN_RU;
    
	[mvd setOriginType:n];
    
	[oOrigin setFuncName:origin[mvd.originType] menuName:NULL];
	
	[self resizeWithoutData:NO];
	[self checkUpdateData];
}

- (IBAction)pPalette:(id)sender
{
    if( palette == nil ) return;
    
    [palette open];
}

- (IBAction)pInfo:(id)sender
{
    if( info == nil ) return;
    
    [info open];
}

- (IBAction)pKakeSute:(id)sender
{
    mvd.sutekake = mvd.sutekake ? 0 : 1;
    [oKakeSute setFuncName:kakesute[mvd.sutekake] menuName:@""];
}

- (void)pressEffectIgnore:(BOOL)b
{
    int n = 0;
    if( b == YES )
        n = [mvd effectIgnoreSrc];
    else
        n = [mvd effectIgnoreDst];
    
    switch( n )
    {
        case MVD_EFFECT_SRC:
        case MVD_EFFECT_DST:
            [mvd setIgnoreSrc:b]; break;
        case MVD_IGNORE_SRC:
        case MVD_IGNORE_DST:
            [mvd setEffectIgnoreClearWithCheckArraySrc:b];break;
        default:
            [mvd setEffectSrc:b]; break;
    }
}

- (IBAction)pEffectIgnoreSrc:(id)sender
{
    [self pressEffectIgnore:YES];
    
    switch ([mvd effectIgnoreSrc])
    {
        case MVD_EFFECT_SRC:
            [oEffectIgnoreSrc setFuncName:effectIgnore[1] menuName:Nil]; break;
        case MVD_IGNORE_SRC:
            [oEffectIgnoreSrc setFuncName:effectIgnore[2] menuName:Nil]; break;
        default:
            [oEffectIgnoreSrc setFuncName:effectIgnore[0] menuName:Nil]; break;
    }
    [palette setEffectIgnore:mvd.palette];
}

- (IBAction)pEffectIgnoreDst:(id)sender
{
    [self pressEffectIgnore:NO];
    switch ([mvd effectIgnoreDst])
    {
        case MVD_EFFECT_DST:
            [oEffectIgnoreDst setFuncName:effectIgnore[1] menuName:Nil]; break;
        case MVD_IGNORE_DST:
            [oEffectIgnoreDst setFuncName:effectIgnore[2] menuName:Nil]; break;
        default:
            [oEffectIgnoreDst setFuncName:effectIgnore[0] menuName:Nil]; break;
    }
    [palette setEffectIgnore:mvd.palette];
}

#pragma mark - Info

- (NSPoint)convertFromViewToImage:(NSPoint)po
{
    po = [oView convertPoint:po fromView:Nil];
    po.x = [mvd imageFromDisplayPositionX:po.x];
    po.y = [mvd imageFromDisplayPositionY:po.y];

    return po;
}

- (void)setPositionInfo:(NSPoint)po
{
    if( info != nil )
    {        
        [info textPosition:po];
        NSInteger n = [mvd indexFromDataPosition:po];
        if( 0 <= n )
        {
            MyColorData *col = [mvd.palette objectAtIndex:n];
            [info posColor:[NSColor colorWithCalibratedRed:col->r green:col->g blue:col->b alpha:col->a] palNo:n +1];
        }
        else
        {
            [info posColor:[NSColor clearColor] palNo:-1];
        }
    }
}

#pragma mark - Command

- (void) topSskCommand:(char *)cmd
{
    NSInteger n = 0;

    if( MY_CMP(cmd, "TS_REMOVE_" ) )
    {
        n = atoi( cmd +10 );
        [mvd removeBackgroundImage:n];
        [self checkUpdateData];
    }
    else if( MY_CMP(cmd, "TS_VISIBLE_") )
    {
        n = atoi( cmd +11 );
        [mvd changeVisibleBackgroundImage:n];
        [self checkUpdateData];
    }
    else
    {
        [edit setCommand:cmd data:mvd rubber:oRubberView];
    }
}

- (void) viewCommand:(char *)cmd
{
    CGFloat x, y;
    cmd += 2;
    
    x = y = -1;
    if( MY_CMP(cmd, "Scale_") )
    {
        cmd += 6;
        if( *cmd == 'P' )
        {
            [self setScalePlus:NO];
        }
        else if( *cmd == 'N' )
        {
            [self setScaleMinus:NO];
        }
        else if( MY_CMP(cmd, "Input") )
        {
            
        }
        else
        {
            x = (CGFloat)atof(cmd);
            if( 0 < x )
            {
                [self setScale:x autoPosition:NO];
            }
        }
    }
    else if( MY_CMP(cmd, "Ratio_") )
    {
        cmd += 6;
        
        x = (CGFloat)atof( cmd );
        if( 10.0f <= x )
            y = (CGFloat)atof( (cmd +3) );
        else
            y = (CGFloat)atof( (cmd +2) );
        
        if( 1 <= x && 1 <= y )
        {
            info.ratio = NSMakePoint(x, y);
            [mvd setRatio:info.ratio];
            [info updateInfo];
            [self setCenterFromInfoAutoCenter:NO];
        }
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"func:%s", cmd];
        [[MyOS sharedManager] alertMessage:str info:[self className]];
    }
}

- (void)testfunc
{
    MySelect4 *ms4 = [MySelect4 sharedManager];
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:4];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"test1" menu:"menu1"]];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"test2" menu:"menu2"]];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"test3" menu:"menu3"]];
    [a addObject:[[MyDrawButtonFuncMenu alloc] initWithData:"test4" menu:"menu4"]];
    
    [ms4 openWithArray:a];
}

- (void)functionCommand:(char *)cmd
{    
    if( MY_CMP(cmd, "A_TOOLBAR" ) )
    {
        [[ToolBarController sharedManager] openToolBar];
        return;
    }
    else if( MY_CMP(cmd, "A_Cancel") )
    {
        if( draw != nil ) [draw cancel];
        else if( edit != nil ) [edit cancel];
        
        return;
    }
    else if( MY_CMP(cmd, "A_TEST") )
    {
        [self testfunc];
        return;
    }
    
    draw = [MyDrawingManager sharedManager];
    [draw disabled];
    edit = [MyEditingManager sharedManager];
    [edit disabled];
    
    if( MY_CMP(cmd, "M_" ) )
    {
        [[self document] functionCommand:cmd];
    }
    else if( MY_CMP(cmd, "D_" ) )
    {
        draw.view = oView;
        [draw setCommand:cmd data:mvd rubber:oRubberView];
    }
    else if( MY_CMP(cmd, "V_" ) )
    {
        [self viewCommand:(char *)cmd];
    }
    else if( MY_CMP(cmd, "TS_" ) )
    {
        [self topSskCommand:(char *)cmd];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"func:%s", cmd];
        [[MyOS sharedManager] alertMessage:str info:[self className]];
    }
    
    if( [draw isEnabled] == NO ) draw = nil;
    if( [edit isEnabled] == NO ) edit = nil;
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    if( draw != nil )
        [draw cancel];
    if( edit != nil )
        [edit cancel];
}

- (void)keyCharactor:(NSString *)str
{
    const char *p = [str UTF8String];
    
    if( *p == 'H' || *p == 'h' )
        [self setCenterViewFromImagePosition:NSMakePoint(1, 1)];
    else if( *p == 'E' || *p == 'e' )
        [self setCenterViewFromImagePosition:NSMakePoint(mvd.size.width, mvd.size.height)];
}

- (void)keyDown:(NSEvent *)e
{
	int n = [[e characters] intValue];
    unsigned short keycode = [e keyCode];
    NSString *charactors = [e characters];
    
	if( [e keyCode] == VKEY_ZERO )
		n = 10;
	MyLog( @"KeyDown:0x%04x > %@ > n:%d", keycode, charactors, n );
    
    if ( [charactors characterAtIndex:0] == '+' ) {
        keycode = VKEY_PLUS;
    }
	switch( keycode )
    {
    case VKEY_UP:
    case VKEY_DOWN:
    case VKEY_LEFT:
    case VKEY_RIGHT:
            oView.keyScroll = YES;
            break;
    }
	switch( keycode )
	{/*
      case VKEY_ESC: MyLog( @"ESC" ); break;
      case VKEY_SPACE: MyLog( @"SPACE" ); break;
      case VKEY_RETURN: MyLog( @"RETURN" ); break;
      case VKEY_TAB: MyLog( @"TAB" ); break;
      case VKEY_UP: MyLog( @"UP" ); break;
      case VKEY_DOWN: MyLog( @"DOWN" ); break;
      case VKEY_LEFT:	MyLog( @"LEFT" ); break;
      case VKEY_RIGHT: MyLog( @"RIGHT" ); break;
      case VKEY_PLUS:	MyLog( @"PLUS" ); break;
      case VKEY_MINUS: MyLog( @"MINUS" ); break;
      */
        case VKEY_ESC: [self functionCommand:"A_Cancel"]; break;
        case VKEY_SPACE: [self functionCommand:"A_TOOLBAR"]; break;
        case VKEY_UP:    [oScrollView upScrollLine]; break;
        case VKEY_DOWN:  [oScrollView downScrollLine]; break;
        case VKEY_LEFT:  [oScrollView leftScrollLine]; break;
        case VKEY_RIGHT: [oScrollView rightScrollLine]; break;
        case VKEY_PLUS:	 [self setScalePlus:YES]; break;
        case VKEY_MINUS: [self setScaleMinus:YES]; break;
        default:
            if( 0 < n )
                [self setScale:n autoPosition:YES];
            else
                [self keyCharactor:[e characters]];
            break;
	}
}

#pragma mark - Left Mouse

- (void)mouseDown:(NSEvent *)e
{    
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    if( draw != nil )
        [draw mouseDown:po];
    else if( edit != nil )
        [edit mouseDown:po];
}

- (void)mouseUp:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    if( draw != nil )
        [draw mouseUp:po];
    else if( edit != nil )
        [edit mouseUp:po];
}

- (void)mouseDragged:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    if( draw != nil )
        [draw mouseDragged:po];
    else if( edit != nil )
        [edit mouseDragged:po];
    
    [self setPositionInfo:po];
    
    [oScrollView autoscroll:e];
    
    [oCursorView setPosition:po];
}

#pragma mark - Right Mouse

- (void)rightMouseDown:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    if( draw != nil )
        [draw rightMouseDown:po];
    else if( edit != nil )
        [edit rightMouseDown:po];
}

- (void)rightMouseUp:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    if( draw != nil )
        [draw rightMouseUp:po];
    else if( edit != nil )
        [draw rightMouseUp:po];
}

#pragma mark - Others Mouse

- (void)mouseMoving:(NSPoint)po;
{    
    if( draw != nil )
    {
        oRubberView.scrollStart = oScrollView.startPosition;
        [draw mouseMoved:po];
    }
    else if( edit != nil )
    {
        oRubberView.scrollStart = oScrollView.startPosition;
        [edit mouseMoved:po];
    }
    
    [self setPositionInfo:po];
}

- (void)mouseMoved:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    [self mouseMoving:po];
    
    oCursorView.scrollStart = oScrollView.startPosition;
    [oCursorView setPosition:po];
}

#pragma mark - Touches

- (void)touchesMovedWithEvent:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];

    [self mouseMoving:po];
}

- (void)touchesEndedWithEvent:(NSEvent *)e
{
    NSPoint po = [self convertFromViewToImage:[e locationInWindow]];
    
    [self mouseMoving:po];
}

#pragma mark - SplitView

//
// NSSplitViewDelegate Protocol
// Need to connect self(File's Owner) and SplitView
//
/* Enforce our split view constraints when the window is resized.
 */
- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [sender adjustSubviews]; // first get default resize behavior
    if( sender == oUDSplit )
        [sender setPosition:NSMaxY([[[sender subviews] objectAtIndex:0] frame]) ofDividerAtIndex:0]; // then resize subject to constraints
    else
        [sender setPosition:NSMaxX([[[sender subviews] objectAtIndex:0] frame]) ofDividerAtIndex:0]; // then resize subject to constraints
}


/* Minimum width of the types list on the left.
*/
- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset
{
    CGFloat ret = 0;
    if( sender == oUDSplit )
        ret = NSHeight([oUDSplit bounds]);
    else
        ret = NSWidth([oLRSplit bounds]);
    
    ret -= [sender dividerThickness];
    ret -= SPLITVIEW_FIXED_WIDTH;
        
    return ret;
}

/* Maximum width of the types list on the left, by subtracting off the minimum width of the data view. If we're in ASCII and Hex mode we actually calculate this; otherwise we just use a reasonable width.
 */
- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset
{
    CGFloat ret = 0.0;
    if( sender == oUDSplit )
        ret = NSHeight([oUDSplit bounds]);
    else
        ret = NSWidth([oLRSplit bounds]);
    
    ret -= [sender dividerThickness];
    ret -= SPLITVIEW_FIXED_WIDTH;
    
    [oCursorWindow windowSizeChanged:nil];
    [oRubberWindow windowSizeChanged:nil];
    
    return ret;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{
    NSView *v = [[splitView subviews] objectAtIndex:1];
    
    if( [v isEqual:subview] == YES )
    {
        NSRect f = [v frame];
        if ( [splitView isVertical] == NO )
        {
            if( !f.size.height )
                f.size.height = 160;
            else
                f.size.height = 0;
            oCursorWindow.addy = f.size.height;
            oRubberWindow.addy = f.size.height;
        }
        else
        {
            if( !f.size.width )
                f.size.width = 160;
            else
                f.size.width = 0;
        }
        [v setFrame:f];
        return YES;
    }
    else 
        return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    return YES;
}


@end
