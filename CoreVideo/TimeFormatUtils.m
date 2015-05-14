//
//  TimeFormatUtils.m
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "TimeFormatUtils.h"

@implementation TimeFormatUtils
+(NSString *)stringDateFormat:(NSDate *)date{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy_MM_dd_HH_mm_ss_SSS";
    return [formatter stringFromDate:date];
}

+(NSString *)stringFromSeconds:(int)seconds{
    //100s==01:40  hh:mm:ss
    //1h==60*60=36000s
    //1m==60s
    //3669s=3669/3600==1  3669%3600==69  69/
    
    int hour=0;
    int min=0;
    int second=0;
    
    hour=seconds/3600;
    
    if(hour!=0){
        seconds=seconds%60;
    }
    
    min=seconds/60;
    if(min!=0){
        seconds=seconds%60;
    }
    
    second=seconds;
    
    
    
    
    return [NSString stringWithFormat:@"%@:%@:%@",[self stringAddPreZero:hour],[self stringAddPreZero:min],[self stringAddPreZero:second]];
    
}
+(NSString *)stringAddPreZero:(int)num{
    if(num<10&&num>=0){
        return [NSString stringWithFormat:@"0%d",num];
    }else{
        return [NSString stringWithFormat:@"%d",num];
    }
}

@end
