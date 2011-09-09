//
//  MyTopSsk.m
//  kmtmg
//
//  Created by 武村 健二 on 11/09/06.
//  Copyright (c) 2011 wHITEgODDESS. All rights reserved.
//

#import "MyTopSsk.h"
#import "../MyDefines.h"
#import "MyTopImage.h"
#import "MyTopSskView.h"

@implementation MyTopSsk

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        /* No retain / release NSMutableArray
        CFArrayCallBacks cb = kCFTypeArrayCallBacks;
        cb.retain = NULL;
        cb.release = NULL;
        
        images = (NSMutableArray *)CFArrayCreateMutable(kCFAllocatorDefault, 0, &cb);
         */
        images = [[NSMutableArray alloc] init];

    }
    
    return self;
}

- (void)dealloc
{
    [images release];
    
    [super dealloc];
}

- (NSMutableArray *)array
{
    return images;
}


- (void)addTopImage:(NSDictionary *)dic
{
    [arrayController addObject:dic];
    
    /*
    NSImage *img = [[images lastObject] objectForKey:@"image"];
    MyLog(@"%@, size:%@", [img name], NSStringFromSize( [img size] ));
    
    NSSavePanel *p = [NSSavePanel savePanel];
    if( [p runModal] )
    {
        [[img TIFFRepresentation] writeToURL:[p URL] atomically:NO];
    }*/
}

- (void)removeImageIndex:(NSInteger)n
{
    NSDictionary *dic = [images objectAtIndex:n];
    [arrayController removeObject:dic];
}


- (IBAction)pressTOP:(id)sender
{
    
}
- (IBAction)pressSSK:(id)sender
{
    
}

@end

#pragma mark - MyTopSskCell

@implementation MyTopSskCell

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    MyTopSskView *tsv = [[self superview] superview];
    NSArray *a = [tsv subviews];
    NSView *v;
    tsv.selected = 0;
    for( v in a )
    {
        if ( [v isEqual:[self superview]] == YES ) {
            break;
        }
        tsv.selected++;
    }
    
    return [tsv topMenu];
}


@end


