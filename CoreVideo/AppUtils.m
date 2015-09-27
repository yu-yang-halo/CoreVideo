//
//  AppUtils.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "AppUtils.h"
#import "AppUserDefaults.h"
@implementation AppUtils
/*
 
 1英里＝＝1.6KM（公里）
 
 */

+(NSString *)convertSpeedUnit:(float)kmphspeed{
    float convertSpd=[self convertSpeed:kmphspeed];
    if ([AppUserDefaults isKMPH]){
        return [NSString stringWithFormat:@"%.f%@",convertSpd,NSLocalizedString(@"km_speedUnit", nil)];
    }else{
        return [NSString stringWithFormat:@"%.f%@",convertSpd,NSLocalizedString(@"mph_speedUnit", nil)];
    }
}

+(NSString *)currentSpeedUnit{
    if ([AppUserDefaults isKMPH]){
        return NSLocalizedString(@"km_speedUnit", nil);
    }else{
        return NSLocalizedString(@"mph_speedUnit", nil);
    }
}

+(float)convertSpeed:(float)kmphspeed{
    if ([AppUserDefaults isKMPH]){
        return kmphspeed;
    }else{
        return kmphspeed/1.6;
    }
}

+(NSString *)convertDistanceUnit:(float)mdistance{
    float convertDistance=[self convertDistance:mdistance];
    if ([AppUserDefaults isKMPH]){
        return [NSString stringWithFormat:@"%.2f%@",convertDistance,NSLocalizedString(@"km_distanceUnit", nil)];
    }else{
        return [NSString stringWithFormat:@"%.2f%@",convertDistance,NSLocalizedString(@"mile_distanceUnit", nil)];
    }
}
+(float)convertDistance:(float)mdistance{
    if ([AppUserDefaults isKMPH]){
        return mdistance/1000;
    }else{
        return mdistance/1600;
    }
}

@end
