//
//  GpsDataHelper.h
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSString *KEY_VIDEO_DATAS;
extern const NSString *KEY_MAX_SPEED;
extern const NSString *KEY_IS_IN_CHINA;
@interface GpsDataHelper : NSObject

+(NSDictionary *)readGpsData:(NSString *)filePath;

@end
