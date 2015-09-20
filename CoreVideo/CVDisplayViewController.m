//
//  CVDisplayViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVDisplayViewController.h"
#import "CustomSpeedView.h"
#import "MyCache.h"
@interface CVDisplayViewController (){
    NSMutableArray *currentSpeedDataArr;
    NSString       *currentPlayVideoPath;
    NSInteger      maxSpd;
    float          totalDistance;//单位 m
    float          totalTime;//单位 s
}
@property (weak) IBOutlet CustomSpeedView *speedView;

@property (weak) IBOutlet NSTextField *maxHSpeed;

@property (weak) IBOutlet NSTextField *averageHSpeed;

@property (weak) IBOutlet NSTextField *movingDistance;

@end

@implementation CVDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}
-(void)loadGpsLoadPathToMapByPlayVideo:(NSString *)playVideoPath{
    currentPlayVideoPath=playVideoPath;
    
    NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    
    currentSpeedDataArr=[NSMutableArray new];
    [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //NSLog(@"%@ %@",[obj objectForKey:@"gps_lat"],[obj objectForKey:@"gps_lgt"] );
        
        NSNumber *spd=[obj objectForKey:@"spd"];
       
        
       [currentSpeedDataArr addObject:spd];
        
        
        
    }];
}
-(void)updateGpsDataToMapByCurrentTime:(Float64)time{
    float m_ratio=9.9;
    if(totalTime!=0){
       m_ratio= [currentSpeedDataArr count]/totalTime;
    }
    
    int index=(int)time*m_ratio;
    
    //NSLog(@"time %d  m_ratio:%f",index,m_ratio);
    
    if(currentSpeedDataArr!=nil){
        if(index<[currentSpeedDataArr count]){
            NSNumber *mspd=currentSpeedDataArr[index];
            
            if(maxSpd<[mspd integerValue]){
                maxSpd=[mspd integerValue];
            }
            
            [self.speedView setCurrentSpeed:[mspd integerValue]];
            [self.maxHSpeed setStringValue:[NSString stringWithFormat:@"%ldKm/H",maxSpd]];
        }
    }

    
}

#pragma mark 计算距离代理callback
/**
 1km==1公里
 1km==2里
 1km==1000m
 */
-(void)caculateTotalDistance:(float)distance{
    totalDistance=distance;
    [self.movingDistance setStringValue:[NSString stringWithFormat:@"%.3fKm",distance/1000]];
    [self loadAverageSpeedContent];
}
//1m/s==3.6km/h
-(void)loadAverageSpeedContent{
    if(totalTime>0){
        [self.averageHSpeed setStringValue:[NSString stringWithFormat:@"%dKm/H",(int)((totalDistance/totalTime)*3.6)]];
    }
}
-(void)videoDurationTime:(Float64)time{
    totalTime=time;
    [self loadAverageSpeedContent];
}

@end
