//
//  IoSKY.h
//  kmtmg
//
//  Created by 武村 健二 on 11/07/19.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyIndexImageRep;

@interface IoSKY : NSObject {
    NSMutableData *des, *index, *meter;
    unsigned char l64[768];
    NSSize imageSize, meterSize;
    int cpu;
	BOOL canUse, carpet;
}

- (unsigned char *)des;
- (unsigned char *)meter;
- (unsigned char *)l64;

- (id)initWithData:(MyIndexImageRep *)indexImage meter:(NSInteger)w carpet:(BOOL)flag;
- (BOOL)loadFromURL:(NSURL *)url carpet:(BOOL)flag;
- (BOOL)saveToURL:(NSURL *)url;

@property (readonly, assign) NSSize imageSize, meterSize;
@property (readonly) BOOL canUse;

@end
