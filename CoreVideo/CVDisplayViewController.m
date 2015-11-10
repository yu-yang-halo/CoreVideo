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
#import "AppUtils.h"
@interface CVDisplayViewController (){
    NSMutableArray *currentSpeedDataArr;
    NSMutableArray *currentGsensorDataArr;
    NSString       *currentPlayVideoPath;
    NSInteger      maxSpd;
    NSInteger      currentSpd;
    
    float          totalDistance;//单位 m
    float          totalTime;//单位 s
    NSLock         *mlock;
}
@property (weak) IBOutlet CustomSpeedView *speedView;
@property (weak) IBOutlet CustomGsensorView *gsensorView;

@property (weak) IBOutlet NSView *gsensorContainer;

@property (weak) IBOutlet NSTextField *maxHSpeed;

@property (weak) IBOutlet NSTextField *averageHSpeed;

@property (weak) IBOutlet NSTextField *movingDistance;


@property (weak) IBOutlet NSTextField *xTextField;

@property (weak) IBOutlet NSTextField *yTextField;
@property (weak) IBOutlet NSTextField *zTextField;

@property (weak) IBOutlet NSTextField *maxSpeedLabelText;

@property (weak) IBOutlet NSTextField *avageSpeedLabelText;
@property (weak) IBOutlet NSTextField *totalDistanceLabelText;



@property (weak) IBOutlet NSTextField *speedValueLabel;

@property (weak) IBOutlet NSTextField *speedUnitLabel;

@end

@implementation CVDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    
    mlock=[[NSLock alloc] init];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:SPEED_UNIT_NOTIFICATION object:nil];
    

}

-(void)updateUI:(NSNotification *)notification{
    if(totalTime>0){
     
        [self.averageHSpeed setStringValue:[AppUtils convertSpeedUnit:((totalDistance/totalTime)*3.6)]];
        
    }else{
         [self.averageHSpeed setStringValue:[AppUtils convertSpeedUnit:(0.0)]];
    }
    [self.speedView setCurrentSpeed:[AppUtils convertSpeed:currentSpd]];
    
    [self.maxHSpeed setStringValue:[AppUtils convertSpeedUnit:maxSpd]];
    [self.movingDistance setStringValue:[AppUtils convertDistanceUnit:totalDistance]];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SPEED_UNIT_NOTIFICATION object:nil];
    
}


-(void)dataLogicProcessOfViodePath:(NSString *)playVideoPath{
    currentPlayVideoPath=playVideoPath;
    
    currentSpd=0;


    
    NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    maxSpd=[MyCache findMaxSpeed:currentPlayVideoPath];
    [self.maxHSpeed setStringValue:[AppUtils convertSpeedUnit:maxSpd]];
    
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
-(void)updateDataByCurrentTime:(Float64)time{
    float m_ratio0=1.0;
    float m_ratio1=1.0;
    if(totalTime!=0){
       m_ratio0= [currentSpeedDataArr count]/totalTime;
       m_ratio1= [currentGsensorDataArr count]/totalTime;
    }
    
    int index0=(int)time*m_ratio0;
    int index1=(int)time*m_ratio1;
    
    if(currentSpeedDataArr!=nil&&[currentGsensorDataArr count]>0){
        if(index0<[currentSpeedDataArr count]){
            NSNumber *mspd=currentSpeedDataArr[index0];
            currentSpd=[mspd integerValue];
            
            [self.speedView setCurrentSpeed:[AppUtils convertSpeed:[mspd integerValue]]];
            
            [self.speedValueLabel setStringValue:[NSString stringWithFormat:@"%.f",[AppUtils convertSpeed:[mspd integerValue]]]];
            
            [self.speedUnitLabel setStringValue:[AppUtils currentSpeedUnit]];
            
        }
    }else{
        [self.speedView setCurrentSpeed:[AppUtils convertSpeed:0]];

        
        [self.maxHSpeed setStringValue:[AppUtils convertSpeedUnit:0]];
    }
    
    if(currentGsensorDataArr!=nil&&[currentGsensorDataArr count]>0){
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
/*
 
 X：加速时的前后变化；Y：加速时的左右变化；Z：加速时的上下变化轴
 
 Y<0 向前 ; Y>0 向后
 
 X<0 向左 ; X>0 向右
 
 */




#pragma mark 计算平均速度代理callback
/**
 1km==1公里
 1km==2里
 1km==1000m
 */
static BOOL distanceActiveYN=NO;
-(void)totalDistance:(float)distance{
    totalDistance=distance;
    [self.movingDistance setStringValue:[AppUtils convertDistanceUnit:distance]];
    
    
    [self loadAverageSpeedContent];
 
}

-(void)videoAllTime:(Float64)allTime{
    totalTime=allTime;
    [self loadAverageSpeedContent];
}


//1m/s==3.6km/h
-(void)loadAverageSpeedContent{
      [mlock lock];
        if(totalTime>0){
            [self.averageHSpeed setStringValue:[AppUtils convertSpeedUnit:((totalDistance/totalTime)*3.6)]];
           
            NSLog(@"平均时速：%@",[AppUtils convertSpeedUnit:((totalDistance/totalTime)*3.6)]);
            
        }
    
     [mlock unlock];
    
   
}

@end
