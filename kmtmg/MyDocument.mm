//
//  MyDocument.m
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <IoCGS/MyOS.h>
#import <IoCGS/StorageCGS.h>
#import "MyDocument.h"
#import "panels/NewDocumentController.h"
#import "panels/MyInfo.h"
#import "MyDefines.h"
#import "io/IoSKY.h"
#import "panels/MySelect4.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        mvc = nil;
        mvd = nil;
    }
    return self;
}

- (void)dealloc
{
    [mvd release];
    
    [super dealloc];
}

- (void)makeWindowControllers
{
    if( mvd == nil )
    {
        NewDocumentController *ndc = [NewDocumentController sharedManager];
        BOOL ret = [ndc open];
        if( ret == NO )
        {
            [self close];
            return;
        }
        mvd = [[MyViewData alloc] init];
        [ndc setNewDocumentSetting:mvd];
    }
    if( mvd != nil )
    {
        mvc = [[[MyWindowController alloc] initWithWindowNibName:@"MyDocument"] retain];
        [self addWindowController:mvc];
        [mvc setShouldCloseDocument:YES];
        
        mvc.mvd = [mvd retain];
        mvd.undoManager = [self undoManager];
    }
}

- (BOOL)hasUndoManager
{
    return YES;
}

#pragma mark - SKY

- (BOOL) loadSKY:(NSURL *)url
{
    IoSKY *io = [[IoSKY alloc] init];
    BOOL ret = [io loadFromURL:url carpet:NO];
    
    if( ret == YES )
    {
        if( mvd == nil )
            mvd = [[MyViewData alloc] init];
        [mvd setImageWithData:[io des] size:[io imageSize] palette:[io l64] colorNum:256];
    }
    
    [io release];
    
    return ret;
}

- (BOOL) saveSKY:(NSURL *)url
{
    IoSKY *io = [[IoSKY alloc] initWithData:mvd.indexImage meter:0 carpet:NO];    
    BOOL ret = io.canUse;
    if( ret == YES )
    {
        ret = [io saveToURL:url];
    }
    
    [io release];

    return ret;
}

#pragma mark - CGS

/*
// Alloc:mvd
// mvd: setImageWithSize, setImageWithExtend, setImageWithData */
- (BOOL) loadCGS:(NSURL *)url
{
    BOOL ret = FALSE;
    
    StorageCGS *storage = [[StorageCGS alloc] initWithCheckFddDrive:FALSE existFDD:FALSE parentWindow:nil];
    if( [storage loadCgsII:url] )
    {
        NSSize s = [storage size];
        unsigned char *p, *line, *data = (unsigned char *)malloc( s.width * s.height );
        if( data == nil ) goto END_LOADCGS;
        
        if( mvd == nil )
            mvd = [[MyViewData alloc] init];
        [mvd setImageWithSize:s];
        
        p = data;
        NSUInteger x, y;
        for( y = 0; y < (NSUInteger)s.height; y++ )
        {
            line = [storage xlineByY:y];
            if( 0xffff < y )
            {
                line[9] = (y >> 16) & 0xff;
                line[10] = (y >> 24) & 0xff;
            }
            else line[9] = 0;
            [mvd setImageWithExtendByY:y cgs:line];

            line += 11;
            for( x = 0; x < (int)s.width; x++ )
            {
                if( (line[x / 8]) & bitMask[x % 8] )
                    p[x] = 0;
                else
                    p[x] = 63;
            }
            p += (int)s.width;
        }
        [mvd setImageWithData:data];
        free( data );
        ret = TRUE;
    }
END_LOADCGS:
    [storage release];
    
    return ret;
}

#pragma mark - Load / Save


- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError
{
	BOOL readSuccess = NO;
	
	// NSImage *image = nil;
	if( [inTypeName isEqualToString:@"STDImageDocumentType"] == YES )
	{
		MyLog( @"read Standard Image" );
        mvd = [[MyViewData alloc] init];
        readSuccess = [mvd setImageFromURL:inAbsoluteURL];
	}
	else if( [inTypeName isEqualToString:@"JTSSKYImageDocumentType"] == YES )
	{
		MyLog( @"read JTS-SKY Image" );
        readSuccess = [self loadSKY:inAbsoluteURL];
	}
    else if( [inTypeName isEqualToString:@"JTSCGSDataImage"] == YES )
    {
		MyLog( @"read JTS-CGS Image" );
        readSuccess = [self loadCGS:inAbsoluteURL];
    }
    else if( [inTypeName isEqualToString:@"KmtmgDocumentType"] == YES )
    {
        MyLog( @"read kmtmg Document" );
        NSData *data = [NSData dataWithContentsOfURL:inAbsoluteURL];
        if( data != nil )
        {
            MyViewData *readMvd = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if( readMvd != nil )
            {
                [mvd release];
                mvd = [readMvd retain];
                readSuccess = YES;
            }
        }
    }/*
	else if( [typeName isEqualToString:@"JTSMayerImageDocumentType"] == YES )
	{
		MyLog( @"read Mayer-SU/EJ Image" );
	}
	else if( [typeName isEqualToString:@"JTSDATImageDocument"] == YES )
	{
		MyLog( @"read JTS-DAT Image" );
		Dat *dat = [[Dat alloc] initWithData:data];
		data = [dat tiff];
		[dat release];
		image = [[NSImage alloc] initWithData:data];
	}
	else if( [typeName isEqualToString:@""] == YES )
	{
	}
	*/
	if( readSuccess == NO )
	{
		*outError = [[[NSError alloc] initWithDomain:@"MyCustomErrorDomain"
                                                code:-1
                                            userInfo:nil] autorelease];
	}
    else
    {
        mvd.undoManager = [self undoManager];
    }
	return readSuccess;
}

- (BOOL) writeSafelyToURL:(NSURL *)inAbsoluteURL
             ofType:(NSString *)inTypeName 
   forSaveOperation:(NSSaveOperationType)saveOperation
              error:(NSError **)outError
{
    BOOL writeSuccess = NO;
    
    if( [inTypeName isEqualToString:@"JTSSKYImageDocumentType"] == YES )
	{
		MyLog( @"write JTS-SKY Image" );
        writeSuccess = [self saveSKY:inAbsoluteURL];
	}
    else if( [inTypeName isEqualToString:@"KmtmgDocumentType"] == YES )
    {
        MyLog( @"write kmtmg Document" );
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mvd];
        if( data != nil )
        {
            writeSuccess = [data writeToURL:inAbsoluteURL 
                                    options:NSDataWritingAtomic 
                                      error:[[MyOS sharedManager] error]];
            mvd.bSaved = writeSuccess;
        }
    }

    return writeSuccess;
}

#pragma mark - functions

- (void)addBackgroundImage
{
    NSArray *fileTypes = [NSArray arrayWithObjects:@"bmp",@"BMP",@"png",@"PNG",@"jpg",@"jpeg",@"JPG",@"JPEG",@"tif",@"tiff",@"TIF", @"TIFF",nil];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    
    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setAllowedFileTypes:fileTypes];
    NSInteger result = [oPanel runModal];
    if (result == NSOKButton)
    {
        [mvd addBackgroundImageURL:[oPanel URL]];
        [mvc checkUpdateData];
        [[MyInfo sharedManager] setImageFraction:mvd.backgroundFraction];
    }
}

- (void)addCGSDataImage
{
    NSArray *fileTypes = [NSArray arrayWithObject:@"cgs"];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    
    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setAllowedFileTypes:fileTypes];
    NSInteger result = [oPanel runModal];

    if (result == NSOKButton)
    {
        [self loadCGS:[oPanel URL]];
        [mvc checkUpdateData];
    }
}

- (void)functionCommand:(char *)cmd
{
    MyLog(@"MyDocument func:%s", cmd );
    
    if( MY_CMP(cmd, "M_AddView") )
    {
        [self addBackgroundImage];
    }
    else if( MY_CMP(cmd, "M_LOADCGS2") )
    {
        [self addCGSDataImage];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"func:%s", cmd];
        [[MyOS sharedManager] alertMessage:str info:[self className]];
    }

}

- (void)saveDocument:(id)sender
{
    NSURL *url = [self fileURL];
    if( url == nil )
    {
        [[MyPalette sharedManager] close];
    }
    
    [super saveDocument:sender];
}

- (void)saveDocumentAs:(id)sender
{
    [[MyPalette sharedManager] close];
    
    [super saveDocumentAs:sender];
}

@end
