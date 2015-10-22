//
//  GpsDataHelper.h
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSString *KEY_VIDEO_DATAS;
extern const NSString *KEY_MAX_SPEED;
extern const NSString *KEY_IS_IN_CHINA;
@interface GpsDataHelper : NSObject

+(NSDictionary *)readGpsData:(NSString *)filePath;

@end
