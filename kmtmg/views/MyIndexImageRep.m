//
//  MyIndexImageRep.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/02.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "MyIndexImageRep.h"
#import "MyColorData.h"
#import "../MyDefines.h"
#import "../panels/MyInfo.h"

@implementation MyIndexImageRep

@synthesize palette;
@synthesize data;

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        palette = nil;
        data = nil;
        bAccepted = NO;
    }
    
    return self;
}

- (id)initWithPaletteArray:(NSMutableArray *)array size:(NSSize)size;
{
    bAccepted = NO;
    
    palette = array;
    // MyLog(@"Palette:%d", [palette count]);
    
    [self setSize:size];
    NSInteger i, length;
    length = size.width * size.height;
    
    data = malloc( length );
    for( i = 0; i < length; i++ )
        data[i] = 255;
    /*
    
    NSRect main = [[NSScreen mainScreen] frame];
    if ( main.size.width < size.width && main.size.height < size.height )
        dispImage = [[NSImage alloc] initWithSize:main.size];
    else if ( main.size.width < size.width && size.height <= main.size.height )
        dispImage = [[NSImage alloc] initWithSize:NSMakeSize(main.size.width, size.height)];
    else if ( size.width <= main.size.width && main.size.height < size.height )
        dispImage = [[NSImage alloc] initWithSize:NSMakeSize(size.width, main.size.height)];
    else
    */
    
    
    return self;
}

- (void)dealloc
{
    [preDispImage release];
    [dispImage release];
    free(data);
    data = nil;
    
    [super dealloc];
}

NSString    *MIICodeKeyData = @"data";
NSString    *MIICodeKeyDispImage = @"dispImage";
NSString    *MIICodeKeyPreDispImage = @"preDispImage";
NSString    *MIICodeKeyPreImgRect = @"preImgRect";
NSString    *MIICodeKeyScrollImg = @"scrollImg";

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    NSUInteger ret, length;
    length = ([self size].width * [self size].height);
    const uint8_t *p = [decoder decodeBytesForKey:MIICodeKeyData returnedLength:&ret];
    
    data = malloc( length );
    if( ret < length ) length = ret;
    
    memcpy(data, p, length);
    
    dispImage = [decoder decodeObjectForKey:MIICodeKeyDispImage];
    preDispImage = [decoder decodeObjectForKey:MIICodeKeyPreDispImage];
    preImgRect = [decoder decodeRectForKey:MIICodeKeyPreImgRect];
    scrollImg = [decoder decodeRectForKey:MIICodeKeyScrollImg];
    [dispImage retain];
    [preDispImage retain];
    
    bAccepted = YES;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeBytes:data length:(NSUInteger)([self size].width * [self size].height) forKey:MIICodeKeyData];
    [encoder encodeObject:dispImage forKey:MIICodeKeyDispImage];
    [encoder encodeObject:preDispImage forKey:MIICodeKeyPreDispImage];
    [encoder encodeRect:preImgRect forKey:MIICodeKeyPreImgRect];
    [encoder encodeRect:scrollImg forKey:MIICodeKeyScrollImg];
}

- (void)setPaletteArray:(NSMutableArray *)array
{
    if( bAccepted == NO ) return;
    
    palette = array;
}

#pragma mark - Convert

- (void)convertImageFromBitmapRep:(NSBitmapImageRep *)bitmap
{
    NSInteger i, x, y, w, h;
    w = [self size].width;
    h = [self size].height;
    NSColor *color, *chkColor;
    unsigned char *p;
/*
    for( y = 0; y < h; y++ )
    {
        p = data + w * y;
        for( x = 0; x < w; x++ )
        {
            chkColor = [bitmap colorAtX:x y:y];
            for( i = 0; i < 255; i++ )
            {
                color = [palette objectAtIndex:i];
                if( [chkColor redComponent] == [color redComponent] &&
                   [chkColor greenComponent] == [color greenComponent] &&
                   [chkColor blueComponent] == [color blueComponent] )
                    break;
            }
            p[x] = i;
        }
    }
 */
}

#pragma mark - Data Access

- (void)testpattern
{
    unsigned char *p;
    NSInteger i, y, w, h;
    w = [self size].width;
    h = [self size].height;
    
    i = 0;
    for( y = 0; y < h; y++ )
    {
        p = data + w * y;
        p[(y % w)] = i++;
        i %= 255;
    }
}

- (void)setIndexData:(unsigned char *)index
{
    unsigned char *s, *d;
    NSInteger i, y, w, h;
    w = [self size].width;
    h = [self size].height;
    
    i = 0;
    for( y = 0; y < h; y++ )
    {
        s = index + w * y;
        d = data + w * y;
        memcpy( d, s, w);
    }
}

- (NSInteger)indexAtPosition:(NSPoint)pos
{
    unsigned char *p = data;
    NSSize size = [self size];
    
    if( pos.x < 1 || size.width < pos.x ) return -1;
    if( pos.y < 1 || size.height < pos.y ) return -1;
    
    pos.x--;
    pos.y--;
    
    p += ((int)pos.y * (int)size.width) + (int)pos.x;
    
    return (NSInteger)*p;
}

- (void)setInfoColorFromDataPosition:(NSPoint)pos
{
    int n = [self indexAtPosition:pos];
    MyColorData *col = [palette objectAtIndex:n];
    [[MyInfo sharedManager] posColor:[NSColor colorWithCalibratedRed:col->r green:col->g blue:col->b alpha:col->a] palNo:n +1];
}

- (MYID)myIdWithType:(OSType)type
{
    MYID mi;
    
    memset( &mi, 0, sizeof(mi) );
    
    mi.MyIdType = type;
    mi.d = data;
    mi.w = [self size].width;
    mi.h = [self size].height;
    
    return mi;
}

- (MYID)myIdSrc
{
    return [self myIdWithType:kImage_Source];
}

- (MYID)myIdDst
{
    return [self myIdWithType:kImage_Destinate];
}

#pragma mark - Drawing

enum { MVD_ORIGIN_LU =  0, MVD_ORIGIN_LD, MVD_ORIGIN_RU, MVD_ORIGIN_RD, MVD_ORIGIN_MAX };

- (void)drawImage:(NSRect)img 
           origin:(NSInteger)originType 
  backgroundColor:(NSInteger)ignoreColor 
     drawFraction:(CGFloat)fraction
{
    [[NSGraphicsContext currentContext] saveGraphicsState];
    CGContextRef cg = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetBlendMode(cg,kCGBlendModeCopy);

    MyColorData *col;
    NSInteger x, y, w, h, maxH, maxW;
    int d;
    CGRect rect;
    CGFloat startX, startY;
    unsigned char *p;
    BOOL revR, revU;
    
	if( originType == MVD_ORIGIN_LU || originType == MVD_ORIGIN_RU )
		revU = YES;
    else
        revU = NO;
    if( originType == MVD_ORIGIN_RD || originType == MVD_ORIGIN_RU )
		revR = YES;
    else
        revR = NO;
    
    startX = startY = 0;
    if( NSEqualRects(scrollImg, NSZeroRect) == NO )
    {
        if( preImgRect.origin.y < img.origin.y )
        {
            img.origin.y += scrollImg.size.height;
            img.size.height -= scrollImg.size.height;
            startY = scrollImg.size.height;
        }
        else if( img.origin.y < preImgRect.origin.y )
        {
            img.size.height -= scrollImg.size.height;
        }
        else if( preImgRect.origin.x < img.origin.x )
        {
            img.origin.x += scrollImg.size.width;
            img.size.width += scrollImg.size.width;
            startX = scrollImg.size.width;
        }
        else if( img.origin.x < preImgRect.origin.x )
        {
            img.size.width -= scrollImg.size.width;
        }
    }
    
    w = [self size].width;
    h = [self size].height;
    
    // MyLog(@"drawImage >> rect:%@, size:%@", NSStringFromRect(img), NSStringFromSize(img.size) );
    
    rect.origin.y = startY;
    rect.size.height = 1;
    maxH = NSMaxY(img);
    maxW = NSMaxX(img);
    for( y = img.origin.y ; y < maxH; y++ )
    {
        if( revU == YES )
            p = data + w * (h -y -1);
        else
            p = data + w * y;
        
        
        rect.origin.x = startX;
        rect.size.width = 1;
        if( revR == YES )
        {
            x = w -1 -(NSInteger)img.origin.x;
            d = p[x--];
            for( ; 0 <= x; x-- )
            {
                if( d == p[x] )
                {
                    rect.size.width++;
                    continue;
                }
                if( 0 <= d && d <= 255 && d != ignoreColor )
                {
                    col = [palette objectAtIndex:d];
                    CGContextSetRGBFillColor( cg, col->r, col->g, col->b, fraction );
                    CGContextFillRect( cg, rect );
                }
                rect.origin.x += rect.size.width;
                d = p[x];
                rect.size.width = 1;
            }
        }
        else
        {
            x = (int)img.origin.x;
            d = p[x++];
            for( ; x < maxW; x++ )
            {
                if( d == p[x] )
                {
                    rect.size.width++;
                    continue;
                }
                if( 0 <= d && d <= 255 && d != ignoreColor )
                {
                    col = [palette objectAtIndex:d];
                    CGContextSetRGBFillColor( cg, col->r, col->g, col->b, fraction );
                    CGContextFillRect( cg, rect );
                }
                rect.origin.x += rect.size.width;
                d = p[x];
                rect.size.width = 1;
            }
        }
        if( 1 <= rect.size.width && 0 <= d && d <= 255 && d != ignoreColor )
        {
            col = [palette objectAtIndex:d];
            CGContextSetRGBFillColor( cg, col->r, col->g, col->b, fraction );
            CGContextFillRect( cg, rect );
        }
        rect.origin.y++;
    }
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

- (void)checkDispRect:(NSRect *)disp imageRect:(NSRect *)img
{
    NSPoint scale;
    scale.x = disp->size.width / img->size.width;
    scale.y = disp->size.height / img->size.height;
    if( 0 < img->origin.x )
    {
        img->origin.x--;
        img->size.width++;
        disp->origin.x -= scale.x;
        disp->size.width += scale.x;
    }
    if( 0 < img->origin.y )
    {
        img->origin.y--;
        img->size.height++;
        disp->origin.y -= scale.y;
        disp->size.height += scale.y;
    }
}

- (void)drawDispRect:(NSRect)disp 
           imageRect:(NSRect)img 
              origin:(NSInteger)originType 
          background:(BOOL)bkImage
        drawFraction:(CGFloat)fraction
{
    [self checkDispRect:&disp imageRect:&img];
    scrollImg = NSZeroRect;
    
    dispImage = [[NSImage alloc] initWithSize:img.size];
    
    [dispImage setCacheMode:NSImageCacheNever];

    [dispImage lockFocus];
    
    int ignoreColor = -1;
    if( bkImage == YES ) ignoreColor = 255;
    
    [self drawImage:img origin:originType backgroundColor:ignoreColor drawFraction:fraction];
    
    [dispImage unlockFocus];
    
    [dispImage drawInRect:disp fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    [preDispImage release];
    preDispImage = [dispImage retain];
    preImgRect = img;
    
    [dispImage release];
    dispImage = nil;
}

- (void)drawScrollDispRect:(NSRect)disp
                 imageRect:(NSRect)img 
                    origin:(NSInteger)originType
                background:(BOOL)bkImage
              drawFraction:(CGFloat)fraction
{
    NSRect d, i;
    d = disp, i = img;
    [self checkDispRect:&disp imageRect:&img];

    if( NSIntersectsRect( preImgRect, img ) == NO )
    {
        [self drawDispRect:d imageRect:i origin:originType background:bkImage drawFraction:fraction];
        return;
    }

    scrollImg = NSIntersectionRect( preImgRect, img );
    // MyLog(@"%@", NSStringFromRect(scrollRect));
    
    dispImage = [[NSImage alloc] initWithSize:img.size];
    
    [dispImage setCacheMode:NSImageCacheNever];
    
    [dispImage lockFocus];

    scrollImg = NSOffsetRect(scrollImg, -preImgRect.origin.x, -preImgRect.origin.y );
    CGFloat x, y;
    x = y = 0;
    if( img.origin.y < preImgRect.origin.y )
    {
        y = preImgRect.origin.y - img.origin.y;
    }
    else if( img.origin.x < preImgRect.origin.x )
    {
        x = preImgRect.origin.x - img.origin.x;
    }
    [preDispImage drawInRect:NSMakeRect(x, y, scrollImg.size.width, scrollImg.size.height)
                    fromRect:scrollImg 
                   operation:NSCompositeSourceOver
                    fraction:1.0];
    
    int ignoreColor = -1;
    if( bkImage == YES ) ignoreColor = 255;
    
    [self drawImage:img origin:originType backgroundColor:ignoreColor];

    [dispImage unlockFocus];
    
    [dispImage drawInRect:disp fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:fraction];
    
    [preDispImage release];
    preDispImage = [dispImage retain];
    preImgRect = img;
    
    [dispImage release];
    dispImage = nil;
}

- (BOOL)drawPlot:(NSPoint)po paletteIndex:(NSInteger)no
{
    NSInteger width = [self size].width;
    if( po.x < 1 || width < po.x ) return NO;
    if( po.y < 1 || [self size].height < po.y ) return NO;
    
    po.x--; po.y--;
    unsigned char *p = data + (NSInteger)po.y * width;
    p += (NSInteger)po.x;
    
    if( *p == no ) return NO;
    
    *p = no;
    
    return YES;
}

@end
