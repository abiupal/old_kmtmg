//
//  NSMutableAttributedString+MyModify.m
//  kmtmg
//
//  Created by 武村 健二 on 11/10/27.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "NSMutableAttributedString+MyModify.h"

@implementation NSMutableAttributedString (MyModify)

- (void)changeColorString:(NSColor *)col
{
    [self beginEditing];
    
    [self removeAttribute:NSForegroundColorAttributeName
                         range:NSMakeRange(0, [self length])];
	[self addAttribute:NSForegroundColorAttributeName
                      value:col
                      range:NSMakeRange(0, [self length])];
    
	[self endEditing];
}

- (void)changeStringColor:(NSColor *)col withFont:(NSFont *)font
{
    [self beginEditing];
    
	[self addAttribute:NSForegroundColorAttributeName
                 value:col
                 range:NSMakeRange(0, [self length])];
    
    [self addAttribute:NSFontAttributeName
                   value:font
                   range:NSMakeRange(0, [self length])];

	[self endEditing];
}

@end
