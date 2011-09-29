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

NSString    *MTSCodeKeyImages = @"images";

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    images = [decoder decodeObjectForKey:MTSCodeKeyImages];
    [images retain];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:images forKey:MTSCodeKeyImages];
}

#pragma mark - func

- (NSMutableArray *)array
{
    return images;
}

- (MyTopSskCell *)cellAtIndex:(NSInteger)n
{
    NSArray *a = [[[collectionView subviews] objectAtIndex:n] subviews];
    MyTopSskCell *cell = [a objectAtIndex:0];
    
    return cell;
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

- (BOOL)changeVisible:(NSInteger)n
{
    MyTopSskCell *cell = [self cellAtIndex:n];
    
    if( cell == nil ) return NO;
    
    cell.unvisible = (cell.unvisible ? NO : YES);
    [cell setNeedsDisplay:YES];
    
    return YES;
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

@synthesize unvisible;

- (id)init
{
    self = [super init];

    return self;
}

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
    
    // NSDictionary *dic = [images objectAtIndex:tsv.selected];
    
    return [tsv topMenu:unvisible];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    
    if( unvisible == YES )
    {
        [[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.3 alpha:0.5] set];
        [NSBezierPath fillRect:[self frame]];
        [[NSColor redColor] set];
        NSBezierPath *bp = [NSBezierPath bezierPath];
        [bp setLineWidth:10.0f];
        [bp moveToPoint:NSMakePoint(32, 32)];
        [bp lineToPoint:NSMakePoint(96, 96)];
        [bp moveToPoint:NSMakePoint(32, 96)];
        [bp lineToPoint:NSMakePoint(96, 32)];
        [bp stroke];
    }
}

@end


