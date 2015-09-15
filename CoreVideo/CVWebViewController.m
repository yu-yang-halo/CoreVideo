//
//  CVWebViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWebViewController.h"
#import <WebKit/WebKit.h>
@interface CVWebViewController ()
@property(nonatomic,strong) WebView *webview;
@end

@implementation CVWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webview=[[WebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_webview];
    
    [[self.webview mainFrame] loadHTMLString:@"gpslocation.html" baseURL:[[NSBundle mainBundle] bundleURL]];
    
    
}

@end
