//
//  MyColoringManager.m
//  kmtmg
//
//  Created by 武村 健二 on 12/01/10.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "MyColoringManager.h"
#import "../MyDefines.h"
#import "../views/MyLayerView.h"
#import "../views/MyRubberView.h"
#import "../panels/MyReduceColor.h"
#import "../panels/MyNumberInput.h"

MyColoringManager *sharedMyColoringManager = NULL;

#define LIMIT_S 0.18
#define LIMIT_V 0.25

@implementation MyColoringManager

#pragma mark - Singleton

+ (MyColoringManager *)sharedManager
{
	@synchronized(self)
	{
		MyLog( @"sharedManager:%@ ",[self className] );
		
		if( sharedMyColoringManager == Nil )
			[[self alloc] init];
	}
	
	return sharedMyColoringManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if( sharedMyColoringManager == Nil )
		{
			sharedMyColoringManager = [super allocWithZone:zone];
			return sharedMyColoringManager;
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
    if (self) {
        // Initialization code here.  
        buffer = NULL;
        allocSize = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [self cleanup];
    [super dealloc];
}

- (void)allocMyBufferSize:(NSUInteger)size
{
    if( buffer != NULL && allocSize < size )
        [self cleanup];

    if( buffer == NULL )
    {
        buffer = malloc( size );
        if( buffer != NULL )
            allocSize = size;
        else
            return;
    }
    
    memset( buffer, 0, allocSize );
}

- (void)cleanup
{
    if( buffer != NULL && 0 < allocSize )
    {
        free( buffer );
        buffer = NULL;
        allocSize = 0;
    }
}

- (unsigned char *)palette
{
    return buffer;
}

#pragma  mark - funcs

- (void)setRubberMode
{
    /*
    if( MY_CMP(funcCommand, "TS_RESIZE_") )
    {
        [rubber setRubberType:RUBBER_RECT];
    }
    else */
        [rubber setRubberType:RUBBER_NONE];
    
}

- (void)setCommand:(char *)cmd data:(MyViewData *)d rubber:(MyRubberView *)rv
{
    [super setCommand:cmd data:d rubber:rv];
    
    [self setRubberMode];
}

- (BOOL)moveCommandCheck
{
    BOOL ret = NO;
    
    if( MY_CMP(funcCommand, "TS_RESIZE_") )
        ret = YES;
    
    return ret;
}


- (void) dispatch
{
    BOOL cancel = YES;
    
    if( MY_CMP(funcCommand, "TS_RESIZE_") )
    {

    }
    
    if( cancel ) 
        [self cancel];
}


#pragma mark - Cancel

- (void)cancel
{
    [rubber cancel];
}

#pragma mark - Left Mouse

- (void)mouseDown:(NSPoint)po
{
    if( [super mouseDown:po] == NO ) return;
}

- (void)mouseUp:(NSPoint)po
{
    if( [super mouseUp:po] == NO )
        goto END_MOUSEUP;
    
    if( NSEqualPoints( [rubber startPoint], NSZeroPoint ) == NO )
    {
        pre = [rubber startPoint];
        [self dispatch];
    }
    else
        [rubber setPosition:pos];
    
    
END_MOUSEUP:
    [super mouseFinishedUp];
}

- (void)mouseDragged:(NSPoint)po
{
    if( [super mouseDragged:po] == NO ) return;
    
    pre = pos;
}

#pragma mark - Right Mouse

- (void)rightMouseDown:(NSPoint)po
{
    if( [super rightMouseDown:po] == NO ) return;
}


- (void)rightMouseUp:(NSPoint)po
{
    if( [super rightMouseUp:po] == NO ) return;
}

#pragma mark - Others Mouse

- (void)mouseMoved:(NSPoint)po
{    
    if( [self moveCommandCheck] == YES )
    {
        [rubber setEndPosition:po];
    }
}

#pragma mark - Internal Functions

- (CGFloat)maxRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
	CGFloat max = r;
	if( max < g ) max = g;
	if( max < b ) max = b;
	
	return max;
}
- (CGFloat)minRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
	CGFloat min = r;
	if( min < g ) min = g;
	if( min < b ) min = b;
	
	return min;
}
- (void)getHS_Red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
	CGFloat max = [self maxRed:r green:g blue:b];
	CGFloat min = [self minRed:r green:g blue:b];
	CGFloat c = max -min;
	
	gV = max;
	if( gV == 0.0 )
	{
		gH = gS = 0.0;
		return;
	}
	
	gS = c / max;
	if( max == r )
		gH = (g -b) / c;
	else if( max == g )
		gH = (b -r) / c + 2.0;
	else if( max == b )
		gH = (r -g) / c + 4.0;
	
	gH *= 60.0;
	if( gH < 0.0 ) gH += 360.0;
}

/* Input Value:0-255 */
- (BOOL)checkBlackWhiteWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
    BOOL ret = NO;
    
	r /= 255; g /= 255; b /= 255;
    [self getHS_Red:r green:g blue:b];
	
	if( gV < LIMIT_V ) ret = YES;
	if( gS < LIMIT_S ) ret = YES;
	
	return ret;
}

#pragma mark - Functions

- (void)inputRGB:(unsigned char **)rgb
{
    rgb[1][0] = rgb[0][0];
    rgb[1][1] = rgb[0][1];
    rgb[1][2] = rgb[0][2];
}

#define DIFFRED( A ) (A[0][0] - A[1][0]) * (A[0][0] - A[1][0])
#define DIFFGRN( A ) (A[0][1] - A[1][1]) * (A[0][1] - A[1][1])
#define DIFFBLU( A ) (A[0][2] - A[1][2]) * (A[0][2] - A[1][2])

- (BOOL)reduceColorBitmapRep:(NSBitmapImageRep *)bitmap reduced:(NSMutableData *)dst
{
    BOOL ret = NO;
    NSUInteger length = 768 + (256 * 256 * sizeof(NSInteger));
    NSInteger i, j, x, y, cNum, flg = 0;
    NSInteger min_sa[2], tmp_sa, num_sa[2], ra, ga, ba;
    NSInteger *sa, stepx, stepy;
    unsigned char *p = [bitmap bitmapData];
    unsigned char baseNum = 0;
    unsigned char *rgb[2], *d;
    
    ra = 33; ga = 32; ba = 35;
        
    /* ready to alloc */
    [self allocMyBufferSize:length];
    if( allocSize < length )
        return ret;    
    sa = (NSInteger *)&buffer[768];
    
    /* Makeup Palette Data : START
    // add used palette data for Black and White */
    switch ( bwNum ) {
        case 2: i = 255; break;
        case 3: i = 128; break;
        case 4: i = 85; break;
        case 5: i = 64; break;
    }
    for( cNum = 0; cNum < bwNum -1; cNum++ )
    {
        rgb[0] = &buffer[cNum * 3];
        rgb[0][0] = rgb[0][1] = rgb[0][2] = cNum * i;
    }
    if( 2 < bwNum )
    {
        rgb[0] = &buffer[cNum * 3];
        rgb[0][0] = rgb[0][1] = rgb[0][2] = 255;
        cNum++;
    }
    bwNum = cNum;
    
    NSSize size = [bitmap size];
    NSInteger spp = [bitmap samplesPerPixel];
    stepy = ((int)size.height + 999) / 1000;
    stepx = ((int)size.width + 999) / 1000;
    /* Progress start */
    for( y = 0; y < size.height; y += stepy )
    {
        p = [bitmap bitmapData] + ((int)(size.height) -(y +1)) * (int)[bitmap bytesPerRow];
        for( x = 0; x < size.width; x += stepx, p += (stepx * spp) )
        {
            if( bwNum && [self checkBlackWhiteWithRed:(CGFloat)p[0] green:(CGFloat)p[1] blue:(CGFloat)p[2] ] == YES )
                continue;
            if( cNum < colNum )
            {/* add used palette data for color */
                flg = 1;
                for( i = bwNum; i < cNum; i++ )
                {
                    rgb[0] = &buffer[i * 3];
                    if( p[0] == rgb[0][0] && p[1] == rgb[0][1] && p[2] == rgb[0][2] )
                    {
                        flg = 0;
                        continue;
                    }
                }
                if( flg )
                {
                    rgb[0] = p;
                    rgb[1] = &buffer[cNum * 3];
                    [self inputRGB:&rgb];
                    cNum++;
                }
            }
            else
            {/* adjust picked color with used palette  START */
                rgb[0] = &buffer[colNum * 3];
                rgb[0][0] = p[0]; rgb[0][1]= p[1]; rgb[0][2] = p[2];
                min_sa[0] = 200000;
                for( i = bwNum; i < colNum ; i++ )
                {
                    rgb[0] = &buffer[i * 3];
                    for( j = i +1; j <= colNum; j++ )
                    {
                        if( flg || (!flg && j == colNum) )
                        {
                            rgb[1] = &buffer[j * 3];
                            tmp_sa  = (DIFFRED(rgb) * ra) /100;
                            tmp_sa += (DIFFGRN(rgb) * ga) /100;
                            tmp_sa += (DIFFBLU(rgb) * ba) /100;
                            sa[(256 * i) +j-i-1] = tmp_sa ;
                        }
                        tmp_sa = sa[(256 * i) +j-i-1];
                        if( tmp_sa < min_sa[0] )
                        {
                            min_sa[0] = tmp_sa;
                            num_sa[0] = i;
                            num_sa[1] = j;
                        }
                    }
                }
                flg = 0;
                min_sa[0] = min_sa[1] = 200000;
                for( i = bwNum; i <= colNum; i++ )
                {
                    if( i != num_sa[0] && i != num_sa[1] )
                    {                    
                        j = num_sa[0];
                        if( i < j )
                            tmp_sa = sa[(256 * i) +j-i-1];
                        else
                            tmp_sa = sa[(256 * j) +i-j-1];
                        if (tmp_sa < min_sa[0])
                            min_sa[0] = tmp_sa;
                    
                        j = num_sa[1];
                        if( i < j )
                            tmp_sa = sa[(256 * i) +j-i-1];
                        else
                            tmp_sa = sa[(256 * j) +i-j-1];
                        if (tmp_sa < min_sa[1])
                            min_sa[1] = tmp_sa;
                    }
                }
                
                if( min_sa[0] <= min_sa[1] )
                    j = num_sa[0];
                else
                    j = num_sa[1];
                rgb[0] = &buffer[colNum * 3];
                rgb[1] = &buffer[j * 3];
                [self inputRGB:&rgb];
                
                for( i = bwNum; i < j; i++ )
                {
                    rgb[0] = &buffer[i * 3];
                    tmp_sa  = (DIFFRED(rgb) * ra) /100;
                    tmp_sa += (DIFFGRN(rgb) * ga) /100;
                    tmp_sa += (DIFFBLU(rgb) * ba) /100;
                    sa[(256 * i) +j-i-1] = tmp_sa ;
                }
                for( i = j; i < colNum; i++ )
                {
                    rgb[0] = &buffer[i * 3];
                    tmp_sa  = (DIFFRED(rgb) * ra) /100;
                    tmp_sa += (DIFFGRN(rgb) * ga) /100;
                    tmp_sa += (DIFFBLU(rgb) * ba) /100;
                    if( i-j-1 < 0 ) continue;
                    
                    sa[(256 * j) + i-j-1] = tmp_sa ;
                }
            } /* adjust picked color with used palette  END */
        } /* for (x) */
        /* Progress update */
    }
    /* Progress end */
    
    /* r[],g[],b[]
    // Makeup Palette Data :END */

    CGFloat bwBase = 1.0;
    if( 0 < bwNum ) bwBase /= bwNum;
    d = [dst mutableBytes];
    for( y = 0; y < size.height; y++ )
    {
        p = [bitmap bitmapData] + ((int)(size.height) -(y +1)) * (int)[bitmap bytesPerRow];
        memset( d, 0, (int)size.width );
        for( x = 0; x < size.width; x++, p += spp )
        {
            if( bwNum && [self checkBlackWhiteWithRed:(CGFloat)p[0] green:(CGFloat)p[1] blue:(CGFloat)p[2] ] == YES )
            { /* black and white */
                j = gV / bwBase;
            }
            else
            {
                min_sa[0] = 0xffff;
                for( i = bwNum; i < colNum ; i++ )
                {
                    rgb[0] = &buffer[i * 3];
                    rgb[1] = p;
                    tmp_sa  = DIFFRED(rgb);
                    tmp_sa += DIFFGRN(rgb);
                    tmp_sa += DIFFBLU(rgb);
                    if( tmp_sa < min_sa[0] )
                    {
                        min_sa[0] = tmp_sa;
                        j = i;
                    }
                }
            }
            d[x] = j + baseNum;
        }
        d += (int)size.width;
    }
    
    ret = YES;
    
    return ret;
}

/* Return NSData:with retain */
- (NSData *)reduceColorImage:(NSImage *)src rect:(NSRect)srcRect size:(NSSize)dstSize
{
    NSMutableData *dst = [[NSMutableData dataWithLength:(int)dstSize.width * (int)dstSize.height] retain];

    NSInteger spp = 4;
    unsigned char *pixel = malloc( (int)dstSize.width * (int)dstSize.height * spp );
    /* Bitmap Format changed to 32 bit RGBA */
    NSBitmapImageRep *bitmapWhoseFormatIKnow = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&pixel
                                                                                       pixelsWide:(int)dstSize.width
                                                                                       pixelsHigh:(int)dstSize.height
                                                                                    bitsPerSample:8
                                                                                  samplesPerPixel:spp
                                                                                         hasAlpha:YES
                                                                                         isPlanar:NO
                                                                                   colorSpaceName:NSCalibratedRGBColorSpace
                                                                                     bitmapFormat:0
                                                                                      bytesPerRow:(int)dstSize.width * spp
                                                                                     bitsPerPixel:8 * spp];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapWhoseFormatIKnow]];
    
    NSRect dstRect = NSMakeRect(0, 0, dstSize.width, dstSize.height);
    [src drawInRect:dstRect
           fromRect:srcRect
          operation:NSCompositeCopy
           fraction:1.0f
     respectFlipped:NO
              hints:nil];
    
    [NSGraphicsContext restoreGraphicsState];
    
    // [[bitmapWhoseFormatIKnow representationUsingType:NSBMPFileType properties:nil] writeToFile:@"/tmp/kenji.bmp" atomically:YES];
    
    MyReduceColor *mrc = [MyReduceColor sharedManager];
    [mrc openWithImage:bitmapWhoseFormatIKnow];
    
    MyNumberInput *mni = [MyNumberInput sharedManager];
    bwNum = [mni openWithMin:1 max:5 string:"Dividing Number of Black and White"];
    colNum = [mni openWithMin:2 max:255 string:"Reduced Total Color Number"];
    if( bwNum == 2 ) bwNum = 0;

    
    if( [self reduceColorBitmapRep:bitmapWhoseFormatIKnow reduced:dst] == NO )
    {
        // Error
        [dst release];
        dst = nil;
    }
    
    [bitmapWhoseFormatIKnow release];
    free(pixel);
    
    return dst;
}

- (NSData *)reduceColorImage:(NSImage *)src size:(NSSize)dstSize
{    
    return [self reduceColorImage:src rect:NSMakeRect(0, 0, src.size.width, src.size.height) size:dstSize];
}

@end
