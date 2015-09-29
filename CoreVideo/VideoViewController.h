//
//  VideoViewController.h
//  CoreVideo
//
//  Created by admin on 15/9/12.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CVModuleProtocol.h"

@interface VideoViewController : NSViewController

@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,assign,readonly) BOOL isAddVideoFile;
@property(nonatomic,weak) id<CVModuleProtocol> zoomInDelegate;
@property(nonatomic,weak) id<CVModuleProtocol> gpsDelegate;
@property(nonatomic,weak) id<CVModuleProtocol> speedDelegate;
-(void)initAssetData:(NSURL *)url;
-(void)close;
-(void)playOrPause;

@end

