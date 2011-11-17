//
//  NSMutableAttributedString+MyModify.h
//  kmtmg
//
//  Created by 武村 健二 on 11/10/27.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (MyModify)

- (void)changeColorString:(NSColor *)col;
- (void)changeStringColor:(NSColor *)col withFont:(NSFont *)font;

@end
