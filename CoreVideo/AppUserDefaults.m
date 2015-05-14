//
//  AppUserDefaults.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
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
