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

const NSString *KEY_VIDEO_DATAS=@"key_video_datas";
const NSString *KEY_MAX_SPEED=@"key_max_speed";
const NSString *KEY_IS_IN_CHINA=@"key_is_in_china";

@implementation GpsDataHelper

+(NSDictionary *)readGpsData:(NSString *)filePath{
    filePath=[self clearfilePrefix:filePath];
    CAssistFile m_assistInfo=CAssistFile();
    CFileList   m_filelist=CFileList();
    NSString *chinesePath=[filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"chinesePath %@",chinesePath);
    
    FileNode_t m_node=m_filelist.createNodeInfo([chinesePath UTF8String]);
    
    NSLog(@"a7l: %d  novatek: %d  sunplus: %d",m_node.is_a7l,m_node.is_novatek,m_node.is_sunplus);
    int count=0;
    if(m_node.is_novatek==1){
        count= m_assistInfo.ParseAssistDataForNovatek([chinesePath UTF8String]);
    }else if(m_node.is_sunplus){
        count= m_assistInfo.ParseAssistDataForSunplus([chinesePath UTF8String]);
    }else{
        count= m_assistInfo.ParseMOVSubtitle([chinesePath UTF8String]);
    }
    
    
    
    NSLog(@"count %d",count);

    NSMutableArray *videoDats=[[NSMutableArray alloc] init];
    
    vector<AssistInfo_t> vectors=*m_assistInfo.GetAssistInfoList();
    
    vector<AssistInfo_t>::iterator iter;
    int max_speed=0;
    BOOL isInChina=true;//默认中国境内
    
    float latitude=0;
    float longitude=0;
   
    for(iter=vectors.begin();iter!=vectors.end();iter++){
        AssistInfo_t info=*iter;
         NSLog(@"lat:%s lgt:%s x:%f y:%f z:%f angle:%f spd:%d",info.gps_lat.data(),info.gps_lgt.data(),info.gsensor_x,info.gsensor_y,info.gsensor_z,info.north_angle,info.spd);
        
        latitude=[[NSString stringWithUTF8String:info.gps_lat.data()] floatValue];
        longitude=[[NSString stringWithUTF8String:info.gps_lgt.data()] floatValue];
        
        if(latitude==0||longitude==0||info.north_angle==0){
            NSLog(@"continue..............");
            continue;
        }
        if(max_speed<info.spd){
            max_speed=info.spd;
        }
        
        
        
        
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
    if(latitude!=0&&longitude!=0){
        isInChina=[self locationInChina:latitude longitude:longitude];
    }
    NSLog(@"Max Speed %d",max_speed);
    return [NSDictionary dictionaryWithObjectsAndKeys:videoDats,KEY_VIDEO_DATAS,[NSNumber numberWithInt:max_speed],KEY_MAX_SPEED,[NSNumber numberWithBool:isInChina],KEY_IS_IN_CHINA,nil];
    
    
}
+(NSString *)clearfilePrefix:(NSString *)filePath{
    if([filePath containsString:@"file:///"]){
        filePath=[filePath stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:@""];
    }
    NSLog(@"filePath %@",filePath);
    return filePath;
}

+(BOOL)locationInChina:(float)lat longitude:(float)lng{
    /*
     *  经度范围:73°33′E至135°05′E 纬度范围:3°51′N至53°33′N
     *
     */
    
    if(lat>=3.51&&lat<=53.33&&lng>=73.33&&lng<=135.05){
        NSLog(@"在中国境内");
        return true;
    }else{
        NSLog(@"不在中国境内");
        return false;
    }
    
}

@end
