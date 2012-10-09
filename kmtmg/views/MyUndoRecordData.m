//
//  MyUndoRecordData.m
//  kmtmg
//
//  Created by 武村 健二 on 12/07/11.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "MyUndoRecordData.h"

@implementation MyUndoRecordData

@synthesize po = _po, d = _d;

-(id)initWithPoint:(NSPoint)po data:(unsigned char)d
{
    self = [super init];
    if( self != nil )
    {
        self.po = po;
        self.d = d;
    }
}

@end
