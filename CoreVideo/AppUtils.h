//
//  AppUtils.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

+(NSString *)convertSpeedUnit:(float)kmphspeed;
+(float)convertSpeed:(float)kmphspeed;

+(NSString *)convertDistanceUnit:(float)mdistance;
+(float)convertDistance:(float)mdistance;

+(NSString *)currentSpeedUnit;

@end
