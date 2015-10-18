//
//  CustomSpeedView.m
//  CoreVideo
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CustomSpeedView.h"
#import "AppUtils.h"
#import "AppUserDefaults.h"
static NSInteger Radius=80;
static NSInteger LineWidth=40;
static NSInteger MIN_ANGLE=0;
static NSInteger MAX_ANGLE=180;//从右到左

static NSString* MIN_SPEED=@"0";// km/h
static NSString* MAX_SPEED=@"120";//从左到右读
static NSString* MAX_SPEED_MPH=@"75";//从左到右读
@interface CustomSpeedView(){
    CGFloat midX;
    CGFloat midY;
    float   ratio;//速度转换刻度系数
    NSString*  max_spd_str;
    NSString*  min_spd_str;
}

@end

/*
 
 刻度0到180度 
 
 速度是0到120
 
 120*180/120=180读
 
 120km=75mph
 
 */

@implementation CustomSpeedView


-(void)setCurrentSpeed:(NSInteger)currentSpeed{
    
    if([AppUserDefaults isKMPH]){
        max_spd_str=MAX_SPEED;
    }else{
        max_spd_str=MAX_SPEED_MPH;
    }
    min_spd_str=MIN_SPEED;
    
    if(currentSpeed>max_spd_str.integerValue){
        currentSpeed=max_spd_str.integerValue;
    }else if(currentSpeed<0){
        currentSpeed=0;
    }
    _currentSpeed=currentSpeed;
    
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if(max_spd_str==nil){
        max_spd_str=MAX_SPEED;
    }
    if(min_spd_str==nil){
        min_spd_str=MIN_SPEED;
    }
    
    ratio=(float)MAX_ANGLE/[max_spd_str integerValue];
   // NSLog(@"ratio 系数 %f",ratio);
    
    
    
    
    midX=NSMidX(self.bounds);
    midY=NSMidY(self.bounds)/2;
    
    
    
    
    
    [self drawArc:[NSColor colorWithCalibratedRed:237 green:231 blue:231 alpha:0.8]startAngle:MIN_ANGLE endAngle:MAX_ANGLE];
    
    [self drawArc:[NSColor colorWithCalibratedRed:251 green:108 blue:0 alpha:1] startAngle:(MAX_ANGLE-_currentSpeed*ratio) endAngle:MAX_ANGLE];

    
    
    NSString *currentSpeed=[NSString stringWithFormat:@"%.f",[AppUtils convertSpeed:_currentSpeed]];
  
    NSMutableDictionary *md=[NSMutableDictionary dictionary];
    [md setObject:[NSFont fontWithName:@"Helvetica" size:48] forKey:NSFontAttributeName];
    [md setObject:[NSColor greenColor] forKey:NSForegroundColorAttributeName];
    NSMutableDictionary *md1=[NSMutableDictionary dictionary];
    [md1 setObject:[NSFont fontWithName:@"Helvetica" size:15] forKey:NSFontAttributeName];
    [md1 setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
    
    
    NSSize size=[currentSpeed sizeWithAttributes:md];
    NSSize unitSize=[[AppUtils currentSpeedUnit] sizeWithAttributes:md1];
    
    [self drawText:currentSpeed location:NSMakePoint(midX-size.width/2,midY) attibutes:md];
    
    [self drawText:[AppUtils currentSpeedUnit] location:NSMakePoint(midX-unitSize.width/2,midY-unitSize.height) attibutes:md1];

    
    
    
    NSMutableDictionary *md2=[NSMutableDictionary dictionary];
    [md2 setObject:[NSFont fontWithName:@"Helvetica" size:18] forKey:NSFontAttributeName];
    [md2 setObject:[NSColor gridColor] forKey:NSForegroundColorAttributeName];
    
    
    NSSize  minsSize=[min_spd_str sizeWithAttributes:md2];
    NSSize  maxsSize=[max_spd_str sizeWithAttributes:md2];
    
    [self drawText:min_spd_str location:NSMakePoint(midX-minsSize.width/2-Radius,midY-minsSize.height) attibutes:md2];
    
    [self drawText:max_spd_str location:NSMakePoint(midX-maxsSize.width/2+Radius,midY-maxsSize.height) attibutes:md2];
    
    
    
    
}

-(void)drawText:(NSString *)content location:(NSPoint)point attibutes:(NSDictionary *)md{
    
    [content drawAtPoint:point withAttributes:md];
}


-(void)drawArc:(NSColor *)color startAngle:(NSInteger)sAngle endAngle:(NSInteger)eAngle{
    NSBezierPath *path=[NSBezierPath bezierPath];
    NSPoint center=NSMakePoint(midX,midY);
    
    [path appendBezierPathWithArcWithCenter:center radius:Radius startAngle:sAngle endAngle:eAngle clockwise:NO];
    [path setLineWidth:LineWidth];
    [color set];
    [path stroke];
}

@end
