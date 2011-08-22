//
//  IoSKY.m
//  kmtmg
//
//  Created by 武村 健二 on 11/07/19.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import "IoSKY.h"
#import "../MyDefines.h"
#import "skyIndex.h"
#import <IoCGS/MyOS.h>
#import "../views/MyIndexImageRep.h"
#import "../views/MyColorData.h"

@implementation IoSKY

@synthesize imageSize, meterSize;
@synthesize canUse;

#pragma mark - Singleton

#pragma mark - Palette

const unsigned char colorLevel[4][4] = {
    {   0,  64,  96, 128 },
    { 120, 138, 156, 169 },
    { 192, 169, 186, 216 },
    { 255, 200, 216, 240 },
};

- (void) sky_palette
{
    memset(l64, 0, sizeof(l64) );
	int n, l,r,g,b;
    for( l = 0 ; l < 4 ; l++ )
    {
        for( b = 0 ; b < 4 ; b++ )
        {
            for( g = 0 ; g < 4 ; g++ )
            {
                for( r = 0 ; r < 4 ; r++ )
                {
                    n = (16 * b + 4 * g + r) * 3 + l * 192 ;
                    l64[n +0] = colorLevel[r][l] ;
                    l64[n +1] = colorLevel[g][l] ;
                    l64[n +2] = colorLevel[b][l] ;
                    /*
                     rgba = [[MyFloatRGBA alloc] initWithIntRed:colorLevel[r][l]
                     green:colorLevel[g][l]
                     blue:colorLevel[b][l]];
                     [palette addObject:rgba];
                     [rgba release];
                     */
                }
            }
        }
    }
}

- (int)endianCheck:(int)n size:(int)byteSize
{
	long l;
	short s;
	
	if( cpu ) return n;
	
	l = s = 0;
	switch( byteSize )
	{
        case 2:
            s = (short)n;
            n = (short)((s << 8) & 0xff00) + ((s >> 8) & 0xff);
            break;
        case 4:
            l = n;
            n = ((l << 24) & 0xff000000);
            n += ((l << 8) & 0xff0000);
            n += ((l >> 8) & 0xff00);
            n += ((l >> 24) & 0xff);
            break;
	}
	
	return n;
}

- (void)readSizeInIndex
{
	c_index idx;
	
	if( index == nil )
	{
		canUse = NO;
		return;
	}
	
	memset( &idx, 0, sizeof(idx) );
	memcpy( &idx, [index bytes], [index length]);
	
	imageSize.width = [self endianCheck:idx.patx12 size:2];
	imageSize.height = [self endianCheck:idx.paty12 size:2];
	if( idx.version == 0x52 )
	{
		imageSize.width += idx.patx3;
		imageSize.width += idx.paty3;
	}
    
	meterSize.width = (idx.mtrx[1] * 256) + idx.mtrx[0];
    if( meterSize.width < 0 )
    {
        meterSize = NSZeroSize;
    }
    else if (carpet == YES) {
        meterSize.height = meterSize.width;
        meterSize.width = imageSize.width;
        imageSize.height -= meterSize.height;
    }
    else
    {
        meterSize.height = imageSize.height;
        imageSize.width -= meterSize.width;
    }
    
    
}

#pragma mark - Setter

- (void)inputDes:(unsigned char *)p
{
    des = [[NSMutableData dataWithCapacity:imageSize.width * imageSize.height] retain];
    int i = 0;
    for( i = 0; i < imageSize.height; i++ )
    {
        [des appendBytes:p length:imageSize.width];
        p += (NSInteger)(imageSize.width);
    }
    p = (unsigned char *)[des bytes];
    for( i = 0; i < imageSize.height * imageSize.width; i++, p++ )
    {
        if( 215 < *p )
            *p -= 192;
    }
}

- (void)inputIndex
{
    c_index idx;
    memset( &idx, 0, sizeof(idx) );
    
    index = [[NSMutableData dataWithCapacity:sizeof(c_index)] retain];
    
    idx.patx = imageSize.width;
    idx.paty = imageSize.height;
    idx.patx12 = [self endianCheck:idx.patx size:2];
    idx.paty12 = [self endianCheck:idx.paty size:2];
    idx.version = 0x51;
    if (0xffff < idx.patx || 0xffff < idx.paty )
    {
        idx.version++;
        idx.patx3 = idx.patx / 0xffff;
        idx.paty3 = idx.paty / 0xffff;
    }
    idx.patx = idx.paty = 0;
    
    // Fixed Data
    idx.dots = 0x0101 ;
    // Program received signal SIGFPE, Arithmetic exception.
    // 0x08179e07 in draw_rline (id=0, wd=0, x=0, y=-8, width=1540, height=1110) at rule.c:134
    // 134				if(pix_x/zx%((ID[id]->bold>>8)&0xff) == 0)
    // (gdb) p ID[0]->bold
    // $4 = 17
    idx.bold = 0x0808 ;
    idx.orgx = [self endianCheck:1 size:2];
    idx.orgy = [self endianCheck:1 size:2];
    idx.zoomx = [self endianCheck:1 size:2];
    idx.zoomy = [self endianCheck:1 size:2];
    
    [index appendBytes:&idx length:sizeof(idx)];
}

- (void)inputPalette:(NSArray *)a
{
    MyColorData *rgba;
    int i = 0;
    for( rgba in a )
    {
        l64[i +0] = (int)(rgba->r * 255);
        l64[i +1] = (int)(rgba->g * 255);
        l64[i +2] = (int)(rgba->b * 255);
        i += 3;
        if( 648 <= i ) break;
    }
}

#pragma mark - Init

- (void)privateInit
{
    int i = 1;
    cpu = 0;
    cpu = *((char *)&i);
    index = nil;
    des = nil;
    meter = nil;
    canUse = NO;
    carpet = NO;
    [self sky_palette];
}

- (id)init
{
    self = [super init];
    if (self)
        [self privateInit];
    
    return self;
}

- (id)initWithData:(MyIndexImageRep *)indexImage meter:(NSInteger)w carpet:(BOOL)flag
{
    self = [super init];
    if (self)
    {
        [self privateInit];
        carpet = flag;
        imageSize = [indexImage size];
        [self inputDes:indexImage.data];
                
        meterSize = imageSize;
        if( carpet == YES )
            meterSize.height = w;
        else
            meterSize.width = w;
        meter = [[NSMutableData dataWithCapacity:meterSize.width * meterSize.height] retain];
        
        [self inputIndex];
        [self inputPalette:indexImage.palette];
        
        if( des != nil && index != nil )
            canUse = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [index release];
    [des release];
    
    [super dealloc];
}

#pragma mark - Func

- (unsigned char *)des
{
    return (unsigned char *)[des bytes];
}

- (unsigned char *)meter
{
    return (unsigned char *)[meter bytes];
}

- (unsigned char *)l64
{
    return &l64[0];
}

- (BOOL)loadFromURL:(NSURL *)url carpet:(BOOL)flag
{
    NSString *basePath = [[url path] stringByDeletingPathExtension];
    NSString *extension = [url.lastPathComponent pathExtension];
    NSString *fileName;
    if( [extension isEqualToString:@"idx"] )
        fileName = [basePath stringByAppendingPathExtension:@"idx"];
    else
        fileName = [basePath stringByAppendingPathExtension:@"IDX"];

    [index release];
    [des release];
    [meter release];
    index = des = meter = nil;
    carpet = flag;
    
    index = [NSData dataWithContentsOfFile:fileName options:NSDataReadingUncached error:[[MyOS sharedManager] error]];
    if( index == nil )
    {
        [[MyOS sharedManager] alertError];
        goto END_LOADSKY;
    }
    [index retain];
    [self readSizeInIndex];
    if( imageSize.width < 1 || imageSize.height < 1 )
    {
        [[MyOS sharedManager] alertMessage:@"Width or Height is/are under 1 pixel." info:[self className]];
        goto END_LOADSKY;
    }
    
    if( [extension isEqualToString:@"idx"] )
        fileName = [basePath stringByAppendingPathExtension:@"des"];
    else
        fileName = [basePath stringByAppendingPathExtension:@"DES"];
    NSData *tmp = [NSData dataWithContentsOfFile:fileName options:NSDataReadingUncached error:[[MyOS sharedManager] error]];
    if( tmp == nil )
    {
        [[MyOS sharedManager] alertError];
        goto END_LOADSKY;
    }
    if( NSEqualSizes( meterSize, NSZeroSize ) == NO )
    {
        NSMutableData *buf = [[NSMutableData alloc] initWithCapacity:(NSInteger)(imageSize.width * imageSize.height)];
        int i;
        unsigned char *p = [tmp bytes];
        if( carpet == NO )
        {
            for( i = 0; i < imageSize.height; i++ )
            {
                [buf appendBytes:p length:imageSize.width];
                p += (NSInteger)(imageSize.width + meterSize.width);
            }
        }
        else
        {
            p += (NSInteger)(imageSize.width * meterSize.height);
            for( i = 0; i < imageSize.height; i++ )
            {
                [buf appendBytes:p length:imageSize.width];
                p += (NSInteger)(imageSize.width);
            }
        }
        des = [[NSData dataWithData:buf] retain];
        [buf release];
        buf = [[NSMutableData alloc] initWithCapacity:(NSInteger)(meterSize.width * meterSize.height)];
        p = [tmp bytes];
        if( carpet == NO )
        {
            p += (NSInteger)imageSize.width;
            for( i = 0; i < meterSize.height; i++ )
            {
                [buf appendBytes:p length:meterSize.width];
                p += (NSInteger)(imageSize.width + meterSize.width);
            }
        }
        else
        {
            for( i = 0; i < meterSize.height; i++ )
            {
                [buf appendBytes:p length:meterSize.width];
                p += (NSInteger)(imageSize.width);
            }
        }
        meter = [[NSData dataWithData:buf] retain];
        [buf release];
    }
    else
    {
        des = [tmp retain];
    }
    
    if( [extension isEqualToString:@"idx"] )
        fileName = [basePath stringByAppendingPathExtension:@"l64"];
    else
        fileName = [basePath stringByAppendingPathExtension:@"L64"];
    tmp = [NSData dataWithContentsOfFile:fileName options:NSDataReadingUncached error:[[MyOS sharedManager] error]];
    if( tmp == nil )
    {
        [[MyOS sharedManager] alertError];
        goto END_LOADSKY;
    }
    memcpy( l64, [tmp bytes], sizeof(l64) );
    
    canUse = YES;
    
END_LOADSKY:
    return canUse;
}

- (BOOL)saveToURL:(NSURL *)url
{
    NSString *basePath = [[url path] stringByDeletingPathExtension];
    NSString *extension = [url.lastPathComponent pathExtension];
    NSString *fileName;
    
    if( [extension isEqualToString:@"idx"] )
        fileName = [basePath stringByAppendingPathExtension:@"idx"];
    else
        fileName = [basePath stringByAppendingPathExtension:@"IDX"];
    BOOL ret = [index writeToFile:fileName options:NSDataWritingAtomic error:[[MyOS sharedManager] error]];
    if( ret == NO )
        goto END_SAVESKY;
        
    if( [extension isEqualToString:@"idx"] )
        fileName = [basePath stringByAppendingPathExtension:@"des"];
    else
        fileName = [basePath stringByAppendingPathExtension:@"DES"];
    ret = [des writeToFile:fileName options:NSDataWritingAtomic error:[[MyOS sharedManager] error]];
    if( ret == NO )
        goto END_SAVESKY;
    
    ret = NO;
    NSData *tmp = [NSData dataWithBytes:&l64[0] length:sizeof(l64)];
    if( tmp == nil )
        goto END_SAVESKY;
    
    if( [extension isEqualToString:@"idx"] )
        fileName = [basePath stringByAppendingPathExtension:@"l64"];
    else
        fileName = [basePath stringByAppendingPathExtension:@"L64"];
    ret = [tmp writeToFile:fileName options:NSDataWritingAtomic error:[[MyOS sharedManager] error]];
 
END_SAVESKY:
    if( ret == NO )
        [[MyOS sharedManager] alertError];
    
    return ret;
}



@end
