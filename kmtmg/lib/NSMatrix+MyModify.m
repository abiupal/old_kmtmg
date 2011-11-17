//
//  NSMatrix+MyModify.m
//  kmtmg
//
//  Created by 武村 健二 on 11/10/27.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "NSMatrix+MyModify.h"
#import "NSMutableAttributedString+MyModify.h"

@implementation NSMatrix (MyModify)

- (void)changeColorString:(NSColor *)col
{
    NSInteger x, y, r, c;
    r = [self numberOfRows];
    c = [self numberOfColumns];
    
    NSButton *btn = nil;
    for (y = 0; y < r; y++)
    {
        for( x = 0; x < c; x++ )
        {
            btn = [self cellAtRow:y column:x];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:[btn attributedTitle]];
            [attString changeColorString:col];
            [btn setAttributedTitle:attString];
            [attString release];
        }
    }
}

@end
