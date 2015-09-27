//
//  AppUserDefaults.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "AppUserDefaults.h"
const NSString* KMPH=@"kmph";
const NSString* MILEPH=@"mileph";
@implementation AppUserDefaults


+(NSString *)initSpeedUnitUserDefault{
    
    NSString* speedUNIT=[[NSUserDefaults standardUserDefaults] objectForKey:@"speed_unit"];
    if(speedUNIT==nil){
        [[NSUserDefaults standardUserDefaults] setObject:KMPH forKey:@"speed_unit"];
    }
    
    return speedUNIT;

}
+(BOOL)isKMPH{
    NSString* speedUNIT=[self initSpeedUnitUserDefault];
    
    if([speedUNIT isEqualToString:KMPH]){
        return YES;
    }else{
        return NO;
    }
}
+(void)setSpeedUnit:(NSString *)unit{
     [[NSUserDefaults standardUserDefaults] setObject:unit forKey:@"speed_unit"];
}

@end
