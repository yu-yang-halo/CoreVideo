//
//  MyCache.m
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "MyCache.h"

NSString *const key_play_list=@"KEY_PLAY_LIST";
NSString *const keyPATH=@"key_path";
NSString *const keyGPSDATA=@"key_gps_data";
NSString *const keyActiveYN=@"key_active_yn";
#import "GpsDataHelper.h"
@implementation MyCache

+(void)playPathCache:(NSString *)path block:(cacheCompleteHandler)_block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *playList=[[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list] mutableCopy];
        if(playList==nil){
            playList=[NSMutableArray new];
        }
        NSDictionary *gpsDats=[GpsDataHelper readGpsData:path];
        NSMutableDictionary *pathDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:path,keyPATH,[gpsDats objectForKey:KEY_VIDEO_DATAS],keyGPSDATA,[gpsDats objectForKey:KEY_MAX_SPEED],KEY_MAX_SPEED,[gpsDats objectForKey:KEY_IS_IN_CHINA],KEY_IS_IN_CHINA,nil];
        
        
        [playList addObject:pathDic];
        
        [[NSUserDefaults standardUserDefaults] setObject:playList forKey:key_play_list];
        
         dispatch_async(dispatch_get_main_queue(), ^{
             _block();
         });
        
    });
    
}

+(void)playPathArrCache:(NSArray *)pathArr block:(cacheCompleteHandler)_block{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *playList=[[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list] mutableCopy];
        if(playList==nil){
            playList=[NSMutableArray new];
        }
        
        
        for (NSURL *path in pathArr) {
            NSDictionary *gpsDats=[GpsDataHelper readGpsData:[path absoluteString]];
            NSMutableDictionary *pathDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[path absoluteString],keyPATH,[gpsDats objectForKey:KEY_VIDEO_DATAS],keyGPSDATA,[gpsDats objectForKey:KEY_MAX_SPEED],KEY_MAX_SPEED,[gpsDats objectForKey:KEY_IS_IN_CHINA],KEY_IS_IN_CHINA, nil];
             [playList addObject:pathDic];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:playList forKey:key_play_list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
              _block();
        });
        
    });
}




+(void)syncPlayList:(NSArray *)playlist{
    [[NSUserDefaults standardUserDefaults] setObject:playlist forKey:key_play_list];
}

+(void)playPathClear{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key_play_list];
}

+(NSArray *)playList{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key_play_list];
}

+(NSArray *)findGpsDatas:(NSString *)videoPath{
    NSArray *gpsDataArr;
    for (NSDictionary *gpsItem in [self playList]) {
        if([[gpsItem objectForKey:keyPATH] isEqualToString:videoPath]){
            gpsDataArr=[gpsItem objectForKey:keyGPSDATA];
            break;
        }
    }
    return gpsDataArr;
}
+(BOOL)locationIsINChina:(NSString *)videoPath{
    BOOL isINCHINA = YES;
    for (NSDictionary *gpsItem in [self playList]) {
        if([[gpsItem objectForKey:keyPATH] isEqualToString:videoPath]){
            isINCHINA=[[gpsItem objectForKey:KEY_IS_IN_CHINA] boolValue];
            break;
        }
    }
    return isINCHINA;
}
+(int)findMaxSpeed:(NSString *)videoPath{
    int maxSpd = 0;
    for (NSDictionary *gpsItem in [self playList]) {
        if([[gpsItem objectForKey:keyPATH] isEqualToString:videoPath]){
            maxSpd=[[gpsItem objectForKey:KEY_MAX_SPEED] intValue];
            break;
        }
    }
    return maxSpd;
}

@end
