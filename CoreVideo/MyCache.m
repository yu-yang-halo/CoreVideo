//
//  MyCache.m
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "MyCache.h"
static NSString *key_play_list=@"KEY_PLAY_LIST";
const NSString *keyPATH=@"key_path";
const NSString *keyGPSDATA=@"key_gps_data";

#import "GpsDataHelper.h"
@implementation MyCache

+(void)playPathCache:(NSString *)path block:(cacheCompleteHandler)_block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *playList=[[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list] mutableCopy];
        if(playList==nil){
            playList=[NSMutableArray new];
        }
        NSArray *gpsDats=[GpsDataHelper readGpsData:path];
        
        NSDictionary *pathDic=[NSDictionary dictionaryWithObjectsAndKeys:path,keyPATH,gpsDats,keyGPSDATA,nil];
        
        
        [playList addObject:pathDic];
        
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
