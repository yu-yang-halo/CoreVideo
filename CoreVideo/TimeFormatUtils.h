//
//  TimeFormatUtils.h
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFormatUtils : NSObject

+(NSString *)stringFromSeconds:(int)seconds;
+(NSString *)stringDateFormat:(NSDate *)date;

@end
