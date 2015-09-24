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
#import "DocumentController.h"
@interface AppDelegate ()



@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching...");
    [MyCache playPathClear];
    
   // NSWindowController *gpsmapWC=[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"gpsmap"];
    
    
    
}
- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender{
    NSLog(@"applicationShouldOpenUntitledFile");
    return YES;
}
- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender{
    NSLog(@"applicationOpenUntitledFile");
    return YES;
}


-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
    NSLog(@"filename %@",filename);
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    
    if(!flag){
        NSLog(@"applicationShouldHandleReopen flag:%d",flag);
        [self.windowVC showWindow:self];
    }
    return flag;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"applicationWillTerminate...");
}


@end
