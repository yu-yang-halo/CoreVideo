//
//  CVWindowController.m
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWindowController.h"
#import "AppDelegate.h"
@interface CVWindowController ()

@end

static CGFloat  winWidth=1280;
static CGFloat  winHeight=760;
@implementation CVWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    delegate.windowVC=self;
    
    NSLog(@"windowDidLoad...");
   
    NSString *appName= NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
    [self.window setTitle:appName];
   
    [self.window setMiniwindowTitle:appName];
    
    CGFloat screenW=[[NSScreen mainScreen] frame].size.width;
    CGFloat screenH=[[NSScreen mainScreen] frame].size.height;
    
    [self.window setFrame:NSMakeRect((screenW-winWidth)/2,(screenH-winHeight)/2, winWidth, winHeight) display:YES];
    
    
    [self.window setContentMaxSize:NSMakeSize(winWidth,winHeight)];
    [self.window setContentMinSize:NSMakeSize(winWidth,winHeight)];
    
}
- (void)windowWillLoad{
    NSLog(@"windowWillLoad...");
}


@end
