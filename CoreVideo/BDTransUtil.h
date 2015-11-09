//
//  BDTransUtil.h
//  CoreVideo
//
//  Created by admin on 15/11/9.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//transformLat(lat, lon): 转换方法，比较复杂，不必深究了。输入：横纵坐标，输出：转换后的横坐标。
//transformLon(lat, lon): 转换方法，同样复杂，自行脑补吧。输入：横纵坐标，输出：转换后的纵坐标。
//wgs2gcj(lat, lon): WGS坐标转换为GCJ坐标。
//gcj2bd(lat, lon): GCJ坐标转换为百度坐标。

@interface BDTransUtil : NSObject


+(NSArray *)gcj2bdLat:(double)lat lgt:(double)lon;
+(NSArray *)wgs2bdLat:(double)lat lgt:(double)lon;


@end
