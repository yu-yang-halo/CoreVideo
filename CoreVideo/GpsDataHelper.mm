//
//  GpsDataHelper.m
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "GpsDataHelper.h"
#import "AssistFile.h"
#import "FileList.h"

@implementation GpsDataHelper

+(NSArray *)readGpsData:(NSString *)filePath{
    filePath=[self clearfilePrefix:filePath];
    CAssistFile m_assistInfo=CAssistFile();
    //chinesePath /Users/apple/Desktop/473下午－434.mov
    //chinesePath /Users/apple/Desktop/473下午－434.mov
    NSString *chinesePath=[filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"chinesePath %@",chinesePath);
    
    int count= m_assistInfo.ParseMOVSubtitle([chinesePath UTF8String]);
    NSLog(@"count %d",count);

    NSMutableArray *videoDats=[[NSMutableArray alloc] init];
    
    vector<AssistInfo_t> vectors=*m_assistInfo.GetAssistInfoList();
    
    vector<AssistInfo_t>::iterator iter;
    for(iter=vectors.begin();iter!=vectors.end();iter++){
        AssistInfo_t info=*iter;
         NSLog(@"lat:%s lgt:%s x:%f y:%f z:%f angle:%f spd:%d",info.gps_lat.data(),info.gps_lgt.data(),info.gsensor_x,info.gsensor_y,info.gsensor_z,info.north_angle,info.spd);
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithUTF8String:info.gps_lat.data()] forKey:@"gps_lat"];
        [dic setObject:[NSString stringWithUTF8String:info.gps_lgt.data()] forKey:@"gps_lgt"];
        [dic setObject:[NSNumber numberWithFloat:info.gsensor_x] forKey:@"gsensor_x"];
        [dic setObject:[NSNumber numberWithFloat:info.gsensor_y] forKey:@"gsensor_y"];
        [dic setObject:[NSNumber numberWithFloat:info.gsensor_z] forKey:@"gsensor_z"];
        
        [dic setObject:[NSNumber numberWithDouble:info.north_angle] forKey:@"north_angle"];
        [dic setObject:[NSNumber numberWithInt:info.spd] forKey:@"spd"];

        
        
        [videoDats addObject:dic];
        
    }
    
    return videoDats;
    
}
+(NSString *)clearfilePrefix:(NSString *)filePath{
    if([filePath containsString:@"file:///"]){
        filePath=[filePath stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:@""];
    }
    NSLog(@"filePath %@",filePath);
    return filePath;
}

@end
