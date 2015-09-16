//
//  CVWebViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWebViewController.h"

@interface CVWebViewController ()

@end

@implementation CVWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor purpleColor] CGColor]];
    
    
    self.webview=[[WebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_webview];
    
    //[self autolayoutWebview];
    
    NSString *gpsPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"gpslocation.html"];
    
 
    
    [[self.webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gpsPath]]];
    
}

-(void)autolayoutWebview{

    [[NSLayoutConstraint constraintWithItem:self.webview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.webview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
}

@end
