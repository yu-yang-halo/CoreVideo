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


@interface CVLayoutViewController ()<ZoomIODelegate>{
    VideoViewController     *videoVC ;
    CVWebViewController     *webVC ;
    PlayListViewController  *playlistVC;
    CVDisplayViewController *displayVC;
    
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

@property (weak) IBOutlet NSView *playListView;
@property (weak) IBOutlet NSView *videoView;
@property (weak) IBOutlet NSView *displayView;
@property (weak) IBOutlet NSView *mapView;




@end

@implementation CVLayoutViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do view setup here.
    
    displayVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"displayVC"];
    
    webVC      =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"webVC"];
    webVC.distanceDelegate=displayVC;
    
    
    
    videoVC    =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"videoVC"];
    videoVC.delegate=self;
    videoVC.gpsMapdelegate=webVC;
    videoVC.speeddelegate=displayVC;
    
    playlistVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"playlistVC"];
  
    
    
    [self.videoView addSubview:videoVC.view];
    [self.playListView addSubview:playlistVC.view];
    [self.mapView addSubview:webVC.view];
    [self.displayView addSubview:displayVC.view];
    
    
    [self updateViewLetfView0:_videoView view1:_displayView rightView0:_mapView view1:_playListView];
    
    
    

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
    
    
    NSView *leftView0=[leftViews objectAtIndex:0];
    NSView *leftView1=[leftViews objectAtIndex:1];
    
    NSView *rightView0=[rightViews objectAtIndex:0];
    NSView *rightView1=[rightViews objectAtIndex:1];
    
   
    [self updateViewLetfView0:leftView0 view1:leftView1 rightView0:rightView0 view1:rightView1];


    
    
}


-(void)updateViewLetfView0:(NSView *)leftView0 view1:(NSView *)leftView1 rightView0:(NSView *)rightView0 view1:(NSView *)rightView1{
    
    [self updateViewLetfRect0:leftView0.bounds rect1:leftView1.bounds rightRect0:rightView0.bounds rect1:rightView1.bounds];
}

-(void)updateViewLetfRect0:(NSRect)leftRect0 rect1:(NSRect)leftRect1 rightRect0:(NSRect)rightRect0 rect1:(NSRect)rightRect1{
    
    [videoVC.view setFrame:leftRect0];
    [displayVC.view setFrame:leftRect1];
    
    [playlistVC.view setFrame:rightRect1];
    [webVC.view setFrame:rightRect0];
    
    
    [webVC.webview setFrame:webVC.view.bounds];
    
    
    
}


- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view NS_AVAILABLE_MAC(10_6){
    return YES;
}


-(void)zoomIOView:(NSInteger)state{
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


