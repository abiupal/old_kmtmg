//
//  MyUndoRecordData.h
//  kmtmg
//
//  Created by 武村 健二 on 12/07/11.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUndoRecordData : NSObject

@property(nonatomic) NSPoint po;
@property(nonatomic) unsigned char d;

-(id)initWithPoint:(NSPoint)po data:(unsigned char)d;

@end
