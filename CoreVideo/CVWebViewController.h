//
//  CVWebViewController.h
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "VideoViewController.h"

@protocol CaculateDistanceDelegate <NSObject>

-(void)caculateTotalDistance:(float)distance;

@end

@interface CVWebViewController : NSViewController<GpsMapDelegate>

@property(nonatomic,strong) WebView *webview;
@property(nonatomic,weak) id<CaculateDistanceDelegate> distanceDelegate;

@end
