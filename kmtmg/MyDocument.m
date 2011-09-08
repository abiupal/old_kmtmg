//
//  MyDocument.m
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <IoCGS/MyOS.h>
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
    }
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

#pragma mark - Load / Save


- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError
{
	BOOL readSuccess = NO;
	
	NSImage *image = nil;
	if( [inTypeName isEqualToString:@"STDImageDocumentType"] == YES )
	{
		MyLog( @"read Standard Image" );
		image = [[NSImage alloc] initWithContentsOfURL:inAbsoluteURL];
        if( image != nil )
        {
            [image setCacheMode:NSImageCacheNever];
            mvd = [[MyViewData alloc] init];
            [mvd setImageFromStandard:image];
            [image release];
            readSuccess = YES;
        }
	}
	else if( [inTypeName isEqualToString:@"JTSSKYImageDocumentType"] == YES )
	{
		MyLog( @"read JTS-SKY Image" );
        readSuccess = [self loadSKY:inAbsoluteURL];
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
		MyLog( @"read JTS-SKY Image" );
        writeSuccess = [self saveSKY:inAbsoluteURL];
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
		NSImage *image = [[NSImage alloc] initWithContentsOfURL:[oPanel URL]];
        [mvd addBackgroundImage:image];
        [image release];
        [mvc checkUpdateData];
        [[MyInfo sharedManager] setImageFraction:mvd.backgroundFraction];
    }
}

- (void)functionCommand:(char *)cmd
{
    MyLog(@"MyDocument func:%s", cmd );
    
    if( MY_CMP(cmd, "M_AddView") )
    {
        [self addBackgroundImage];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"func:%s", cmd];
        [[MyOS sharedManager] alertMessage:str info:[self className]];
    }

}

- (void)saveDocument:(id)sender
{
    [[MyPalette sharedManager] close];
    
    // Temporary
    [self setFileType:@"JTSSKYImageDocumentType"];
    [super saveDocument:sender];
}

@end
