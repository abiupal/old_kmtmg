//
//  MyWindowController.h
//  kmtmg
//
//  Created by 武村 健二 on 11/02/09.
//  Copyright 2011 wHITEgODDESS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyViewData.h"
#import "MyScrollwithOtherView.h"
#import "MyHScrollView.h"
#import "MyVScrollView.h"
#import "MyView.h"
#import "../menuTool/MyDrawButton.h"

@class MyPalette;
@class MyInfo;
@class MyDrawingManager;
@class MyEditingManager;
@class MyLayerWindow;
@class MyCursorView;
@class MyRubberView;
@class MyTopSsk;

@interface MyWindowController : NSWindowController {
    IBOutlet MyHScrollView *oHSview;
    IBOutlet MyScrollwithOtherView *oScrollView;
    IBOutlet MyView *oView;
    IBOutlet MyVScrollView *oVSview; 
    IBOutlet NSSplitView *oLRSplit, *oUDSplit;
    IBOutlet MyDrawButton *oOrigin, *oKakeSute, *oPalette, *oEffectIgnoreSrc, *oEffectIgnoreDst;
    IBOutlet MyLayerWindow *oCursorWindow, *oRubberWindow;
    IBOutlet MyCursorView *oCursorView;
    IBOutlet MyRubberView   *oRubberView;
    IBOutlet MyTopSsk *oTopSsk;
    
@private
    MyDrawingManager *draw;
    MyEditingManager *edit;
    
    MyPalette *palette;
    MyInfo *info;

    MyViewData *mvd;
}

- (IBAction)pOrigin:(id)sender;
- (IBAction)pPalette:(id)sender;
- (IBAction)pKakeSute:(id)sender;
- (IBAction)pEffectIgnoreSrc:(id)sender;
- (IBAction)pEffectIgnoreDst:(id)sender;

- (void)setMyViewData;
- (void)setScale:(CGFloat)f autoPosition:(BOOL)flag;
- (void)setPenColorFromPaletteNo:(NSInteger)palNo;
- (void)pressPaletteNo:(NSInteger)palNo pos:(NSPoint)pos;
- (void)functionCommand:(char *)cmd;
- (void)setCenterFromInfoAutoCenter:(BOOL)flag;
- (void)checkUpdateData;

@property(assign) MyViewData *mvd;
@property(readonly,assign) MyView *oView;

@end
