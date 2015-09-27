//
//  AppUserDefaults.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSString* KMPH;
extern const NSString* MILEPH;
@interface AppUserDefaults : NSObject


+(NSString *)initSpeedUnitUserDefault;

+(BOOL)isKMPH;

+(void)setSpeedUnit:(NSString *)unit;

@end
