//
//  PlayListViewController.h
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@interface PlayListViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>
-(void)reloadPlayListData;
@end
