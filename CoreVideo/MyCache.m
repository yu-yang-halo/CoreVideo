//
//  MyCache.m
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
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
        NSArray *gpsDats=[GpsDataHelper readGpsData:path];
        
        NSMutableDictionary *pathDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:path,keyPATH,gpsDats,keyGPSDATA,nil];
        
        
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
             NSArray *gpsDats=[GpsDataHelper readGpsData:[path absoluteString]];
             NSMutableDictionary *pathDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[path absoluteString],keyPATH,gpsDats,keyGPSDATA,nil];
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

@end
