//
//  BDTransUtil.m
//  CoreVideo
//
//  Created by admin on 15/11/9.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "BDTransUtil.h"
#include <math.h>

//pi: 圆周率。
static double mpi = 3.14159265358979324;

//a: 卫星椭球坐标投影到平面地图坐标系的投影因子。
static double a = 6378245.0;

//ee: 椭球的偏心率。
static double ee = 0.00669342162296594323;

//x_pi: 圆周率转换量。
static double x_pi = 3.14159265358979324 * 3000.0 / 180.0;



@implementation BDTransUtil
//火星坐标转百度坐标
+(NSArray *)gcj2bdLat:(double)lat lgt:(double)lon{
    double x = lon, y = lat;
    
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    return @[@(bd_lon), @(bd_lat)];
}
//地球坐标转百度坐标
+(NSArray *)wgs2bdLat:(double)lat lgt:(double)lon{
   
    NSArray *wgs2gcj = [BDTransUtil wgs2gcjLat:lat lgt:lon];
    
    NSArray *gcj2bd = [BDTransUtil gcj2bdLat:[wgs2gcj[0] doubleValue] lgt:[wgs2gcj[1] doubleValue]];
    
    return gcj2bd;
}
//百度坐标转火星坐标
+(NSArray *)bd2gcjLat:(double)lat lgt:(double)lon{
    double x = lon - 0.0065, y = lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return @[@(gg_lat), @(gg_lon)];
}

//地球坐标转火星坐标
+(NSArray *)wgs2gcjLat:(double)lat lgt:(double)lon{
    double dLat = [BDTransUtil transformLat:(lon - 105.0) lgt:(lat - 35.0)];
    double dLon = [BDTransUtil transformLon:(lon - 105.0) lgt:(lat - 35.0)];
    
    double radLat = lat / 180.0 * mpi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * mpi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * mpi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
   
    return @[@(mgLat), @(mgLon)];
}
+(double)transformLat:(double)lat lgt:(double)lon{
    double ret = -100.0 + 2.0 * lat + 3.0 * lon + 0.2 * lon * lon + 0.1 * lat * lon + 0.2 * sqrt(abs(lat));
    ret += (20.0 * sin(6.0 * lat * mpi) + 20.0 * sin(2.0 * lat * mpi)) * 2.0 / 3.0;
    ret += (20.0 * sin(lon * mpi) + 40.0 * sin(lon / 3.0 * mpi)) * 2.0 / 3.0;
    ret += (160.0 * sin(lon / 12.0 * mpi) + 320 * sin(lon * mpi / 30.0)) * 2.0 / 3.0;
    return ret;
}
+(double)transformLon:(double)lat lgt:(double)lon{
    double ret = 300.0 + lat + 2.0 * lon + 0.1 * lat * lat + 0.1 * lat * lon + 0.1 * sqrt(abs(lat));
    ret += (20.0 * sin(6.0 * lat * mpi) + 20.0 * sin(2.0 * lat * mpi)) * 2.0 / 3.0;
    ret += (20.0 * sin(lat * mpi) + 40.0 * sin(lat / 3.0 * mpi)) * 2.0 / 3.0;
    ret += (150.0 * sin(lat / 12.0 * mpi) + 300.0 * sin(lat / 30.0 * mpi)) * 2.0 / 3.0;
    return ret;
}
    
@end
