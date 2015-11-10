//
//  GpsViewController.m
//  CoreVideo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "GpsViewController.h"
#import "MyCache.h"
@interface GpsViewController (){
    NSMutableArray *currentVideoGpsDataArr;
    NSString       *currentPlayVideoPath;
    Float64         totalTime;
}
@property (weak) IBOutlet NSTextField *latitudeLabel;
@property (weak) IBOutlet NSTextField *longitudeLabel;
@property (weak) IBOutlet NSTextField *latitudeUnitLabel;

@property (weak) IBOutlet NSTextField *longitudeUnitLabel;
@property (weak) IBOutlet NSImageView *northAngleImageView;
@property (weak) IBOutlet NSImageView *stillImageView;


@end

@implementation GpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

}



-(void)updateDataByCurrentTime:(Float64)time{
    float m_ratio=1.0;
    if(totalTime>0){
        m_ratio= [currentVideoGpsDataArr count]/totalTime;
    }
    
    int index=(int)time*m_ratio;
    
    if(currentVideoGpsDataArr!=nil&&[currentVideoGpsDataArr count]>0){
        if(index<[currentVideoGpsDataArr count]){
            NSArray *xyItem=currentVideoGpsDataArr[index];
            
            if ([xyItem[0] floatValue]<0) {
                _longitudeUnitLabel.stringValue=@"W";
            }else{
                _longitudeUnitLabel.stringValue=@"E";
            }
            if ([xyItem[1] floatValue]<0) {
                _latitudeUnitLabel.stringValue=@"S";
            }else{
                _latitudeUnitLabel.stringValue=@"N";
            }
            
            _longitudeLabel.stringValue=[self convertLatLngToDFM:[xyItem[0] floatValue]<0?-[xyItem[0] floatValue]:[xyItem[0] floatValue]];
            
            _latitudeLabel.stringValue=[self convertLatLngToDFM:[xyItem[1] floatValue]<0?-[xyItem[1] floatValue]:[xyItem[1] floatValue]];
            
            //NSLog(@"north_angle %@",xyItem[2]);
            [self  rotateAngle:[xyItem[2] floatValue]/180*M_PI];
            
        }
    }
    
    
}
static float val=0.0;

-(void)rotateAngle:(float)angle{
    
    
    float xval=self.northAngleImageView.frame.origin.x+self.northAngleImageView.frame.size.width/2;
    float yval=self.northAngleImageView.frame.origin.y+self.northAngleImageView.frame.size.height/2;
    
    self.northAngleImageView.layer.position=CGPointMake(xval, yval);
    
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    self.northAngleImageView.layer.anchorPoint=CGPointMake(0.5, 0.5);
    self.northAngleImageView.layer.transform=transform;
   
    
   
}

-(NSString *)convertLatLngToDFM:(float)latlng{
    int d_int=(int)latlng;
    float f_float=(latlng-d_int)*60;
    int f_int=(int)f_float;
    float m_float=(f_float-f_int)*60;
    return [NSString stringWithFormat:@"%3d°%3d'    %.2f",d_int,f_int,m_float];
}

-(void)videoAllTime:(Float64)allTime{
    totalTime=allTime;
}


-(void)dataLogicProcessOfViodePath:(NSString *)playVideoPath{
    
    currentPlayVideoPath=playVideoPath;
    
    
    
    NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    
    currentVideoGpsDataArr=[NSMutableArray new];
    [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *gps_lat=[obj objectForKey:@"gps_lat"];
        NSString *gps_lgt=[obj objectForKey:@"gps_lgt"];
        
        NSNumber *north_angle=[obj objectForKey:@"north_angle"];
        
        
        if(gps_lat.floatValue!=0&&gps_lgt.floatValue!=0){
            
          [currentVideoGpsDataArr addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:gps_lgt.floatValue],[NSNumber numberWithFloat:gps_lat.floatValue],north_angle, nil]];
            
            
        }
        
        
        
    }];
    
}


@end
