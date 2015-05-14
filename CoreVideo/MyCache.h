//
//  MyCache.h
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const key_play_list;
extern NSString *const keyPATH;
extern NSString *const keyGPSDATA;
extern NSString *const keyActiveYN;
typedef void (^cacheCompleteHandler)();
@interface MyCache : NSObject



//+(void)playPathCache:(NSString *)path block:(cacheCompleteHandler)_block;

+(void)playPathArrCache:(NSArray *)pathArr block:(cacheCompleteHandler)_block;

+(void)playPathClear;

+(NSArray *)playList;
+(void)syncPlayList:(NSArray *)playlist;

+(NSArray *)findGpsDatas:(NSString *)videoPath;
+(int)findMaxSpeed:(NSString *)videoPath;
+(BOOL)locationIsINChina:(NSString *)videoPath;

@end
