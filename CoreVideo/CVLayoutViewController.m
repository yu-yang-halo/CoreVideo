//
//  CVLayoutViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/16.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVLayoutViewController.h"
#import "VideoViewController.h"
#import "PlayListViewController.h"
#import "CVWebViewController.h"
#import "CVDisplayViewController.h"
#import "CVModuleProtocol.h"
#import "AppColorManager.h"
#import "GpsViewController.h"

@interface CVLayoutViewController ()<CVModuleProtocol>{
    VideoViewController     *videoVC ;
    CVWebViewController     *webVC ;
    PlayListViewController  *playlistVC;
    CVDisplayViewController *displayVC;
    GpsViewController       *gpsVC;
    
    
    NSRect globalView1Rect;
    NSRect globalView0Rect;
    
    NSRect leftView1Rect;
    NSRect leftView0Rect;
    
    NSRect rightView1Rect;
    NSRect rightView0Rect;
    
}
@property (weak) IBOutlet NSSplitView *globalSplitView;
@property (weak) IBOutlet NSSplitView *leftSplitView;
@property (weak) IBOutlet NSSplitView *rightSplitView;
@property (weak) IBOutlet NSView *gmapWebView;


@property (weak) IBOutlet NSView *playListView;
@property (weak) IBOutlet NSView *videoView;
@property (weak) IBOutlet NSView *displayView;
@property (weak) IBOutlet NSView *mapInfoView;




@end

@implementation CVLayoutViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    
    
    [self.view.layer setBackgroundColor:[[AppColorManager appBackgroundColor] CGColor]];
    
    // Do view setup here.
    
    displayVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"displayVC"];
    
    webVC      =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"webVC"];
    webVC.distanceDelegate=displayVC;
    
    gpsVC=[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"gpsVC"];
    
    
    
    
    
    
    videoVC    =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"videoVC"];
    videoVC.zoomInDelegate=self;
    videoVC.gpsDelegate=webVC;
    videoVC.speedDelegate=displayVC;
    videoVC.gpsInfoDelegate=gpsVC;
    
    playlistVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"playlistVC"];
    
    //leftRect0:x:0.000000 y:0.000000 w:1013.000000 h:422.000000 leftRect1:x:0.000000 y:0.000000 w:1013.000000 h:328.000000 rightRect0:x:0.000000 y:0.000000 w:266.000000 h:423.000000 rightRect1:x:0.000000 y:0.000000 w:266.000000 h:327.000000
    
    
  
    
    
    [self.videoView addSubview:videoVC.view];
    [self.playListView addSubview:playlistVC.view];
    [self.mapInfoView addSubview:gpsVC.view];
    [self.displayView addSubview:displayVC.view];
    [self.gmapWebView addSubview:webVC.view];
    
    
    
    //[self updateViewLetfView0:_videoView view1:_displayView rightView0:_mapView view1:_playListView];
    
    [[[_globalSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1014,760)];
    [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,266,760)];
    [[[_globalSplitView subviews] objectAtIndex:2] setFrame:NSMakeRect(0,0,266,760)];
    
    [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1014,540)];
    [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,1014,220)];
    
    [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,266,323)];
    [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,266,437)];
    
    
    
    

    [_globalSplitView  setDelegate:self];
    [_leftSplitView    setDelegate:self];
    [_rightSplitView   setDelegate:self];
    
    

    
}

- (void)splitViewWillResizeSubviews:(NSNotification *)notification{
   // NSLog(@"splitViewWillResizeSubviews %@",notification.userInfo);
    
}
- (void)splitViewDidResizeSubviews:(NSNotification *)notification{
   // NSArray *splitViews = [self.globalSplitView subviews];
    
    NSArray *leftViews  = [self.leftSplitView subviews];
    NSArray *rightViews = [self.rightSplitView subviews];
    
    NSView *map_webView=[[_globalSplitView subviews] objectAtIndex:2];
    
    
    
    NSView *leftView0=[leftViews objectAtIndex:0];
    NSView *leftView1=[leftViews objectAtIndex:1];
    
    NSView *rightView0=[rightViews objectAtIndex:0];
    NSView *rightView1=[rightViews objectAtIndex:1];
    
   
    [self updateViewLetfView0:leftView0 view1:leftView1 rightView0:rightView0 view1:rightView1 webView:map_webView];


    
    
}


-(void)updateViewLetfView0:(NSView *)leftView0 view1:(NSView *)leftView1 rightView0:(NSView *)rightView0 view1:(NSView *)rightView1 webView:(NSView *)map_webView{
    
    [self updateViewLetfRect0:leftView0.bounds rect1:leftView1.bounds rightRect0:rightView0.bounds rect1:rightView1.bounds mapRect:map_webView.bounds];
}

-(void)updateViewLetfRect0:(NSRect)leftRect0 rect1:(NSRect)leftRect1 rightRect0:(NSRect)rightRect0 rect1:(NSRect)rightRect1 mapRect:(NSRect)mRect{
    
    //NSLog(@"leftRect0:%@ leftRect1:%@ rightRect0:%@ rightRect1:%@",[self nsRectToString:leftRect0],[self nsRectToString:leftRect1],[self nsRectToString:rightRect0],[self nsRectToString:rightRect1]);
    
    
    [videoVC.view setFrame:leftRect0];
    [displayVC.view setFrame:leftRect1];
    
    [playlistVC.view setFrame:rightRect1];
    [gpsVC.view setFrame:rightRect0];
    
    
    
    [webVC.view setFrame:mRect];
    
    [webVC.webview setFrame:webVC.view.bounds];
    
}

-(NSString *)nsRectToString:(NSRect)rect{
    return [NSString stringWithFormat:@"x:%f y:%f w:%f h:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view NS_AVAILABLE_MAC(10_6){
    return YES;
}


-(void)zoomInVideoPlayWindow:(NSInteger)state{
    if(state==0){
        
        globalView1Rect=[[[_globalSplitView subviews] objectAtIndex:1] bounds];
        globalView0Rect=[[[_globalSplitView subviews] objectAtIndex:0] bounds];
   
        leftView1Rect=[[[_leftSplitView subviews] objectAtIndex:1] bounds];
        leftView0Rect=[[[_leftSplitView subviews] objectAtIndex:0] bounds];
        
        rightView1Rect=[[[_rightSplitView subviews] objectAtIndex:1] bounds];
        rightView0Rect=[[[_rightSplitView subviews] objectAtIndex:0] bounds];
        
        
        [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSZeroRect];
        
        [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSZeroRect];
        
    }else{
        [[[_globalSplitView subviews] objectAtIndex:1] setFrame:globalView1Rect];
        [[[_globalSplitView subviews] objectAtIndex:0] setFrame:globalView0Rect];
        
        [[[_leftSplitView subviews] objectAtIndex:1] setFrame:leftView1Rect];
        [[[_leftSplitView subviews] objectAtIndex:0] setFrame:leftView0Rect];
        
        [[[_rightSplitView subviews] objectAtIndex:1] setFrame:rightView1Rect];
        [[[_rightSplitView subviews] objectAtIndex:0] setFrame:rightView0Rect];
       
    }
}


@end


