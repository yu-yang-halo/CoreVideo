//
//  AppDelegate.h
//  CoreVideo
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VideoViewController.h"
#import "CVWindowController.h"
#import "PlayListViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic,strong) VideoViewController *videoVC;
@property(nonatomic,strong) CVWindowController  *windowVC;
@property(nonatomic,strong) PlayListViewController  *playlistVC;

- (IBAction)openFile:(id)sender;
@end

