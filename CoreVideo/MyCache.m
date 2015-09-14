//
//  MyCache.m
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "MyCache.h"
static NSString *key_play_list=@"KEY_PLAY_LIST";
@implementation MyCache

+(void)playPathCache:(NSString *)path{
    NSMutableArray *playList=[[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list] mutableCopy];
    if(playList==nil){
        playList=[NSMutableArray new];
    }
    [playList addObject:path];
    [[NSUserDefaults standardUserDefaults] setObject:playList forKey:key_play_list];
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

@end
