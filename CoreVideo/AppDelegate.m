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
-(IBAction)showHelp:(id)sender{
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *appName=NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
    
    NSString *message=[NSString stringWithFormat:@"Version %@(Build %@)",version,build];
    
    NSRunAlertPanel(appName, message,
                                 nil, nil,nil);
    
}

- (IBAction)openFile:(id)sender {
   
    __weak AppDelegate *weakSelf=self;
    [[NSDocumentController sharedDocumentController] beginOpenPanelWithCompletionHandler:^(NSArray *fileList) {
        if(fileList!=nil){
         
            
            NSLog(@"%@",fileList);
            [weakSelf.videoVC close];
            if(fileList!=nil&&[fileList count]>0){
                NSURL *fisrtUrl=[fileList objectAtIndex:0];
                
                [MyCache playPathArrCache:fileList block:^{
                    
                    [weakSelf activeCurrentPlayFile:[fisrtUrl absoluteString]];
                    
                    [weakSelf.videoVC initAssetData:fisrtUrl];
                    
                    [weakSelf.playlistVC reloadPlayListData];
                    
                }];
            }
            
        }
        
    }];
}

-(void)activeCurrentPlayFile:(NSString *)filePath{
    NSArray *playList=[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list];
    
    NSMutableArray *newPlayList=[NSMutableArray new];
    for (int i=0; i<[playList count];i++) {
        
    
        NSMutableDictionary *dic=[playList[i] mutableCopy];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:keyActiveYN];
        
        [newPlayList addObject:dic];
        
    }
    
    for (int i=(int)[playList count]-1; i>=0;i--) {
        
        if([filePath isEqualToString:[playList[i] objectForKey:keyPATH]]){
        
            NSMutableDictionary *dic=[playList[i] mutableCopy];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:keyActiveYN];
            
            [newPlayList replaceObjectAtIndex:i withObject:dic];
            
            break;
        }
        
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:newPlayList forKey:key_play_list];
    
}
-(void)activeCurrentPlayIndex:(int)index{
    NSArray *playList=[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list];
    
    NSMutableArray *newPlayList=[NSMutableArray new];
    for (int i=0; i<[playList count];i++) {
        
        
        NSMutableDictionary *dic=[playList[i] mutableCopy];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:keyActiveYN];
        
        [newPlayList addObject:dic];
        
    }
    
    for (int i=0;i<[playList count];i++) {
        
        if(i==index){
            NSMutableDictionary *dic=[playList[i] mutableCopy];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:keyActiveYN];
            
            [newPlayList replaceObjectAtIndex:i withObject:dic];
            
            break;
        }
        
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:newPlayList forKey:key_play_list];
    
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
