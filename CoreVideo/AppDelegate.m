//
//  AppDelegate.m
//  CoreVideo
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoViewController.h"
#import "MyCache.h"

@interface AppDelegate ()



@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching...");
    [MyCache playPathClear];
    
   // NSWindowController *gpsmapWC=[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"gpsmap"];
    
    
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"applicationWillTerminate...");
}


@end
