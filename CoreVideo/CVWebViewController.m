//
//  CVWebViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWebViewController.h"
#import "MyCache.h"
#import "JSONKit.h"
@interface CVWebViewController ()
{
    NSMutableArray *currentVideoGpsDataArr;
}
@end

@implementation CVWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor purpleColor] CGColor]];
    
    
    self.webview=[[WebView alloc] initWithFrame:self.view.bounds];
    self.webview.frameLoadDelegate=self;
    
    
    [self.view addSubview:_webview];
    
    NSString *gpsPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"gpslocation.html"];
    
 
    
    [[self.webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gpsPath]]];
    
    
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    NSLog(@"didFinishLoadForFrame");
    
    
    
}

-(void)autolayoutWebview{

    [[NSLayoutConstraint constraintWithItem:self.webview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.webview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
}
-(void)updateGpsDataToMapByCurrentTime:(Float64)time{
    int index=(int)time*9.6;
    NSLog(@"time %d",index);
    
    if(currentVideoGpsDataArr!=nil){
        if(index<[currentVideoGpsDataArr count]){
             NSArray *xyItem=currentVideoGpsDataArr[index];
            
             [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateMarkerPosition(%@)",[xyItem JSONString]]];
        }
    }
    
   
}
-(void)beginDrawPath{
    
     NSArray *gpsDataArr=[[[MyCache playList] objectAtIndex:0] objectForKey:keyGPSDATA];
     currentVideoGpsDataArr=[NSMutableArray new];
     [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         NSLog(@"%@ %@",[obj objectForKey:@"gps_lat"],[obj objectForKey:@"gps_lgt"] );
         
         NSString *gps_lat=[obj objectForKey:@"gps_lat"];
         NSString *gps_lgt=[obj objectForKey:@"gps_lgt"];

         if(gps_lat.floatValue>0&&gps_lgt.floatValue>0){
             
             NSValue *pValue=[NSValue valueWithPoint:CGPointMake(gps_lat.floatValue, gps_lgt.floatValue)];
             
             
             [currentVideoGpsDataArr addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:gps_lat.floatValue],[NSNumber numberWithFloat:gps_lgt.floatValue], nil]];
         }
         
        
        
     }];
    
    NSString *jsonS=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:currentVideoGpsDataArr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] ;
    
    
     NSLog(@"line arr::  %@ %@",jsonS,@"");
    
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath(%@)",[currentVideoGpsDataArr JSONString]]];
}

@end
