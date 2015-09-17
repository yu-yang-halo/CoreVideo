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



@interface CVLayoutViewController ()<ZoomIODelegate>{
    VideoViewController     *videoVC ;
    CVWebViewController     *webVC ;
    PlayListViewController  *playlistVC;
    
    NSRect originV0;
    NSRect originV1;
    NSRect originH0;
    NSRect originH1;
}
@property (weak) IBOutlet NSSplitView *verticalSplitView;
@property (weak) IBOutlet NSSplitView *horizontalSplitView;

@property (weak) IBOutlet NSView *playListView;
@property (weak) IBOutlet NSView *videoView;
@property (weak) IBOutlet NSView *displayView;




@end

@implementation CVLayoutViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_videoView setWantsLayer:YES];
    [_videoView.layer setBackgroundColor:[[NSColor redColor] CGColor]];
    
   
    [_playListView setWantsLayer:YES];
    [_playListView.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
    

    [_displayView setWantsLayer:YES];
    [_displayView.layer setBackgroundColor:[[NSColor blueColor] CGColor]];
    
    
    
    
    // Do view setup here.
    
    webVC      =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"webVC"];
    
    videoVC    =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"videoVC"];
    videoVC.delegate=self;
    videoVC.gpsMapdelegate=webVC;
    
    
    playlistVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"playlistVC"];
    
    
    [self.videoView addSubview:videoVC.view];
    [self.playListView addSubview:playlistVC.view];
    [self.displayView addSubview:webVC.view];
  
    
    
    [self updateViewLayoutV1:_playListView hview0:_videoView hview1:_displayView];
    
    

    [_horizontalSplitView setDelegate:self];
    [_verticalSplitView   setDelegate:self];
    

    
}

- (void)splitViewWillResizeSubviews:(NSNotification *)notification{
   // NSLog(@"splitViewWillResizeSubviews %@",notification.userInfo);
    
}
- (void)splitViewDidResizeSubviews:(NSNotification *)notification{
    //NSLog(@"splitViewDidResizeSubviews %@",notification.userInfo);
    
    NSArray *horizontalViews=[self.horizontalSplitView subviews];
    NSArray *verticalViews=[self.verticalSplitView subviews];
    
    
    NSView *verView0=[verticalViews objectAtIndex:0];
    //verView0 contains [hview0 hview1]
    NSView *hview0=[horizontalViews objectAtIndex:0];
    NSView *hview1=[horizontalViews objectAtIndex:1];
    
    
    NSView *verView1=[verticalViews objectAtIndex:1];
    

    [self updateViewLayoutV1:verView1 hview0:hview0 hview1:hview1];
    
    
    
}


-(void)updateViewLayoutV1:(NSView *)verView1 hview0:(NSView *)hview0 hview1:(NSView *)hview1{
    [self updateFrameRectV1:verView1.bounds hRect0:hview0.bounds hRect1:hview1.bounds];
}

-(void)updateFrameRectV1:(NSRect)verRect1 hRect0:(NSRect)hRect0 hRect1:(NSRect)hRect1{
    [videoVC.view setFrame:hRect0];
    [playlistVC.view setFrame:verRect1];
    [webVC.view setFrame:hRect1];
    
    
    
    [webVC.webview setFrame:webVC.view.bounds];
    
    
    
}


- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view NS_AVAILABLE_MAC(10_6){
    return YES;
}


-(void)zoomIOView:(NSInteger)state{
    if(state==0){
        originH0=_videoView.bounds;
        originH1=_displayView.bounds;
        originV0=_horizontalSplitView.bounds;
        originV1=_playListView.bounds;
        
        [[[_verticalSplitView subviews] objectAtIndex:1] setFrame:NSZeroRect];
        [[[_verticalSplitView subviews] objectAtIndex:0] setFrame:self.verticalSplitView.bounds];
        [[[_horizontalSplitView subviews] objectAtIndex:0] setFrame:self.verticalSplitView.bounds];
        [[[_horizontalSplitView subviews] objectAtIndex:1] setFrame:NSZeroRect];
        
    }else{
        [[[_verticalSplitView subviews] objectAtIndex:1] setFrame:originV1];
        [[[_horizontalSplitView subviews] objectAtIndex:0] setFrame:originH0];
        [[[_horizontalSplitView subviews] objectAtIndex:1] setFrame:originH1];
        [[[_verticalSplitView subviews] objectAtIndex:0] setFrame:originV0];
       
    }
}

-(void)autolayoutView{
   
    [[NSLayoutConstraint constraintWithItem:videoVC.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0] setActive:YES];
//    
//    [[NSLayoutConstraint constraintWithItem:videoVC.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:videoVC.view.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:videoVC.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:videoVC.view.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:videoVC.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:videoVC.view.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    
    
//    [[NSLayoutConstraint constraintWithItem:webVC.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.displayView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:webVC.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.displayView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:webVC.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.displayView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:webVC.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.displayView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
//
//   
//    [[NSLayoutConstraint constraintWithItem:playlistVC.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:playlistVC.view.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:playlistVC.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:playlistVC.view.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:playlistVC.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:playlistVC.view.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] setActive:YES];
//    [[NSLayoutConstraint constraintWithItem:playlistVC.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:playlistVC.view.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
   

}

@end


