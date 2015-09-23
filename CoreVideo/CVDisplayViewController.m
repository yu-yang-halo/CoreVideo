//
//  CVDisplayViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVDisplayViewController.h"
#import "CustomSpeedView.h"
#import "CustomGsensorView.h"
#import "MyCache.h"
@interface CVDisplayViewController (){
    NSMutableArray *currentSpeedDataArr;
    NSMutableArray *currentGsensorDataArr;
    NSString       *currentPlayVideoPath;
    NSInteger      maxSpd;
    float          totalDistance;//单位 m
    float          totalTime;//单位 s
}
@property (weak) IBOutlet CustomSpeedView *speedView;
@property (weak) IBOutlet CustomGsensorView *gsensorView;

@property (weak) IBOutlet NSTextField *maxHSpeed;

@property (weak) IBOutlet NSTextField *averageHSpeed;

@property (weak) IBOutlet NSTextField *movingDistance;


@property (weak) IBOutlet NSTextField *xTextField;

@property (weak) IBOutlet NSTextField *yTextField;
@property (weak) IBOutlet NSTextField *zTextField;

@end

@implementation CVDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}
-(void)loadGpsLoadPathToMapByPlayVideo:(NSString *)playVideoPath{
    currentPlayVideoPath=playVideoPath;
    
    NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    
    currentSpeedDataArr=[NSMutableArray new];
    currentGsensorDataArr=[NSMutableArray new];
    [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //NSLog(@"%@ %@",[obj objectForKey:@"gps_lat"],[obj objectForKey:@"gps_lgt"] );
        
        NSNumber *spd=[obj objectForKey:@"spd"];
       
        NSNumber *gsensor_x=[obj objectForKey:@"gsensor_x"];
        NSNumber *gsensor_y=[obj objectForKey:@"gsensor_y"];
        NSNumber *gsensor_z=[obj objectForKey:@"gsensor_z"];
        if([gsensor_x floatValue]>2||[gsensor_x floatValue]<-2||[gsensor_y floatValue]>2||[gsensor_y floatValue]<-2||[gsensor_z floatValue]>2||[gsensor_z floatValue]<-2){
            
        }else{
            [currentGsensorDataArr addObject:@[gsensor_x,gsensor_y,gsensor_z]];
            
        }
        
        [currentSpeedDataArr addObject:spd];
        
        
        
    }];
    _gsensorView.gsensorArray=currentGsensorDataArr;
}
-(void)updateGpsDataToMapByCurrentTime:(Float64)time{
    float m_ratio0=9.9;
    float m_ratio1=9.9;
    if(totalTime!=0){
       m_ratio0= [currentSpeedDataArr count]/totalTime;
        m_ratio1= [currentGsensorDataArr count]/totalTime;
    }
    
    int index0=(int)time*m_ratio0;
    int index1=(int)time*m_ratio1;
    
    //NSLog(@"time %d  m_ratio:%f",index,m_ratio);
    
    if(currentSpeedDataArr!=nil){
        if(index0<[currentSpeedDataArr count]){
            NSNumber *mspd=currentSpeedDataArr[index0];
            
            if(maxSpd<[mspd integerValue]){
                maxSpd=[mspd integerValue];
            }
            
            [self.speedView setCurrentSpeed:[mspd integerValue]];
            [self.maxHSpeed setStringValue:[NSString stringWithFormat:@"%ldKm/H",maxSpd]];
        }
    }
    
    if(currentGsensorDataArr!=nil){
        if(index1<[currentGsensorDataArr count]){
            [_gsensorView updateGsensorRange:index1];
            
            float xVal=[currentGsensorDataArr[index1][0] floatValue];
            float yVal=[currentGsensorDataArr[index1][1] floatValue];
            float zVal=[currentGsensorDataArr[index1][2] floatValue];
            
            
            [_xTextField setStringValue:[NSString stringWithFormat:@"X: %.2f",xVal]];
            [_yTextField setStringValue:[NSString stringWithFormat:@"Y: %.2f",yVal]];
            [_zTextField setStringValue:[NSString stringWithFormat:@"Z: %.2f",zVal]];
            
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
