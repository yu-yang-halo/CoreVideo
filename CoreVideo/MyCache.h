//
//  MyCache.h
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCache : NSObject

+(void)playPathCache:(NSString *)path;

+(void)playPathClear;

+(NSArray *)playList;

@end
