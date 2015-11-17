//
//  CVWindowController.m
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWindowController.h"
#import "AppDelegate.h"
const NSString *notification_full_screen=@"window_full_change";

@interface CVWindowController ()

@end

static CGFloat  winWidth=1280;
static CGFloat  winHeight=760;
@implementation CVWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    delegate.windowVC=self;
    NSRect mainScreen=[[NSScreen mainScreen] frame];
    
    winWidth=mainScreen.size.width*0.85;
    winHeight=mainScreen.size.height*0.85;
    
    NSLog(@"windowDidLoad...");
   
    NSString *appName= NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
    [self.window setTitle:appName];
    
    [self.window setMiniwindowTitle:appName];
    
    CGFloat screenW=[[NSScreen mainScreen] frame].size.width;
    CGFloat screenH=[[NSScreen mainScreen] frame].size.height;
    
    [self.window setFrame:NSMakeRect((screenW-winWidth)/2,(screenH-winHeight)/2, winWidth, winHeight) display:YES];
    
    
    [self.window setContentMaxSize:NSMakeSize(screenW,screenH)];
    [self.window setContentMinSize:NSMakeSize(winWidth,winHeight)];
    self.window.delegate=self;
    
   
    
}
- (void)windowWillLoad{
    NSLog(@"windowWillLoad...");
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification   NS_AVAILABLE_MAC(10_7){
    //NSLog(@"windowWillEnterFullScreen");
}
- (void)windowDidEnterFullScreen:(NSNotification *)notification   NS_AVAILABLE_MAC(10_7){
    NSLog(@"windowDidEnterFullScreen");
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_full_screen object:nil];
}
- (void)windowWillExitFullScreen:(NSNotification *)notification   NS_AVAILABLE_MAC(10_7){
    //NSLog(@"windowWillExitFullScreen");
}
- (void)windowDidExitFullScreen:(NSNotification *)notification{
    NSLog(@"windowDidExitFullScreen");
     [[NSNotificationCenter defaultCenter] postNotificationName:notification_full_screen object:nil];
}


@end
