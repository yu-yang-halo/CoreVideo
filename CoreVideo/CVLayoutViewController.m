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



@interface CVLayoutViewController (){
    VideoViewController     *videoVC ;
    CVWebViewController     *webVC ;
    PlayListViewController  *playlistVC;
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
    videoVC    =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"videoVC"];
    webVC      =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"webVC"];
    playlistVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"playlistVC"];
    
    
    [self.videoView addSubview:videoVC.view];
    [self.playListView addSubview:playlistVC.view];
    [self.displayView addSubview:webVC.view];
  
    
    [videoVC.view setFrame:_videoView.frame];
    [playlistVC.view setFrame:_playListView.frame];
    [webVC.view setFrame:_displayView.frame];
    
    [self updateViewLayoutV1:_playListView hview0:_videoView hview1:_displayView];
    
    

    [_horizontalSplitView setDelegate:self];
    [_verticalSplitView   setDelegate:self];
    

    
}

- (void)splitViewWillResizeSubviews:(NSNotification *)notification{
    NSLog(@"splitViewWillResizeSubviews %@",notification.userInfo);
    
}
- (void)splitViewDidResizeSubviews:(NSNotification *)notification{
    NSLog(@"splitViewDidResizeSubviews %@",notification.userInfo);
    
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
    [videoVC.view setFrame:hview0.bounds];
    //[videoVC.view.layer setPosition:hview0.layer.position];
    
    
    [playlistVC.view setFrame:verView1.bounds];
    //[playlistVC.view.layer setPosition:verView1.layer.position];
    
    [webVC.view setFrame:hview1.bounds];
    //[webVC.view.layer setPosition:hview1.layer.position];
    
    [webVC.webview setFrame:webVC.view.bounds];
    //[webVC.webview.layer setPosition:webVC.view.layer.position];
    
}


- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view NS_AVAILABLE_MAC(10_6){
    return NO;
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
