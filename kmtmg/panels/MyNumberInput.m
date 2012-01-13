//
//  MyNumberInput.m
//  kmtmg
//
//  Created by 武村 健二 on 11/12/13.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyNumberInput.h"
#import "../MyDefines.h"
#import "../menuTool/MyDrawButton.h"
#import "MyPanel.h"

@implementation MyNumberInput

enum { 
    NI_Return = 100, NI_RangeText,
    NI_NumberUp = 201, NI_NumberDown,
    NI_PrevButton = 801, NI_Minus,
    NI_BackSpace = 901, NI_AllClear,
    NI_ZeroZero = 999,
    NI_0,NI_1,NI_2,NI_3,NI_4,
    NI_5,NI_6,NI_7,NI_8,NI_9,
};

char *funcTag[] = {
    "NumberInput_0","NumberInput_1","NumberInput_2","NumberInput_3","NumberInput_4",
    "NumberInput_5","NumberInput_6","NumberInput_7","NumberInput_8","NumberInput_9",
};

#define MNI_INIT_VALUE -9999999
#define MNI_MAX_VALUE 99999999
#define MNI_INPUTED_MAX_VALUE 9999999

static MyNumberInput *sharedMyNumberInputManager = NULL;

#pragma mark - Singleton

+ (MyNumberInput *)sharedManager
{
	@synchronized(self)
	{
		// MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyNumberInputManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyNumberInputManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyNumberInputManager == Nil )
		{
			sharedMyNumberInputManager = [super allocWithZone:zone];
			return sharedMyNumberInputManager;
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
    if (self)
    {
        [NSBundle loadNibNamed: @"NumberInput" owner:self];
        
        prevValue = -9999999;
        
        MyDrawButton *mdb = [panel getObjectFromTag:NI_Return];
        [mdb setFuncName:"NumberInput_RT" menuName:@"RT"];
        mdb = [panel getObjectFromTag:NI_NumberUp];
        [mdb setFuncName:"NumberInput_Up" menuName:@"Up"];
        mdb = [panel getObjectFromTag:NI_NumberDown];
        [mdb setFuncName:"NumberInput_Down" menuName:@"Down"];
        mdb = [panel getObjectFromTag:NI_Minus];
        [mdb setFuncName:"NumberInput_Minus" menuName:@"Minus"];
        mdb = [panel getObjectFromTag:NI_BackSpace];
        [mdb setFuncName:"NumberInput_BS" menuName:@"BS"];
        mdb = [panel getObjectFromTag:NI_AllClear];
        [mdb setFuncName:"NumberInput_AC" menuName:@"AC"];
        mdb = [panel getObjectFromTag:NI_ZeroZero];
        [mdb setFuncName:"NumberInput_ZZ" menuName:@"00"];
        NSString *menu;
        for( int i = 0; i < 10; i++ )
        {
            mdb = [panel getObjectFromTag:NI_0 +i];
            menu = [NSString stringWithFormat:@"%d",i];
            [mdb setFuncName:funcTag[i] menuName:menu];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controlTextDidChange:)
                                                     name: NSControlTextDidChangeNotification object:number];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

#pragma mark - data

- (void)inputButton:(char)c
{
    NSInteger n = [number integerValue];
    for( ; MNI_MAX_VALUE < n; )
    {
        n /= 10;
    }
    if( MNI_INPUTED_MAX_VALUE < n )
    {
        NSBeep();
        return;
    }
    
    if( 0x30 <= c && c <= 0x39 )
    {
        n *= 10;
        n += c - 0x30;
    }
    else if( c == 'u' )
        n++;
    else if( c == 'd' )
        n--;
    else if( c == '-' )
        n *= -1;
    else if( c == 'b' )
        n /= 10;
    else if( c == 'z' )
        n *= 100;
    
    if( c == 'a' )
        [number setStringValue:@""];
    else
        [number setIntegerValue:n];
}

#pragma mark - func

- (IBAction)prev:(id)sender
{
    [number setIntegerValue:prevValue];
}

- (IBAction)press:(id)sender
{
    switch ([sender tag])
    {
        case NI_Return:
        {
            NSUInteger i = [[number stringValue] length];
            if( i < 1 || 8 < i )
                NSBeep();
            else
            {
                prevValue = [number integerValue];
                [panel setTag:prevValue];
            }
            break;
        }
        case NI_NumberUp:
            [self inputButton:'u'];
            break;
        case NI_NumberDown:
            [self inputButton:'d'];
            break;
        case NI_Minus:
            [self inputButton:'-'];
            break;
        case NI_BackSpace:
            [self inputButton:'b'];
            break;
        case NI_AllClear:
            [self inputButton:'a'];
            break;
        case NI_ZeroZero:
            [self inputButton:'z'];
            break;
            
        case NI_0:
        case NI_1:
        case NI_2:
        case NI_3:
        case NI_4:
        case NI_5:
        case NI_6:
        case NI_7:
        case NI_8:
        case NI_9:
            [self inputButton:(char)([sender tag] -NI_0 + 0x30)];
            break;
    }
}

#pragma mark - Notification

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    prevValue = [number integerValue];
}

#pragma mark - Open

- (NSInteger)openWithMin:(CGFloat)min max:(CGFloat)max string:(const char *)msg
{
    NSString *str = [NSString stringWithFormat:@"%d 〜 %d",(int)min, (int)max];
    [range setStringValue:str];
    [message setStringValue:[NSString stringWithUTF8String:msg]];
    
    NSButton *btn = [panel getObjectFromTag:NI_PrevButton];
    if( prevValue != MNI_INIT_VALUE )
    {
        str = [NSString stringWithFormat:@"%d",(int)prevValue];
        [btn setEnabled:YES];
    }
    else
    {
        str = [NSString stringWithUTF8String:"No Value"];
        [btn setEnabled:NO];
    }
    [prevLabel setStringValue:str];

    NSNumber *value = [NSNumber numberWithFloat:min];
    [formatter setMinimum:value];
    value = [NSNumber numberWithFloat:max];
    [formatter setMaximum:value];
    [number setFormatter:formatter];
    
    [self inputButton:'a'];
    
    panel.tag = MNI_INIT_VALUE;
    return [NSApp runModalForWindow:panel];
}

@end
