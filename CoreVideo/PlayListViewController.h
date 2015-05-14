//
//  PlayListViewController.h
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CVModuleProtocol.h"
#import <WebKit/WebKit.h>
@interface PlayListViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,CVModuleProtocol>
-(void)reloadPlayListData;


@end
