//
//  CustomGsensorView.m
//  CoreVideo
//
//  Created by apple on 15/9/20.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CustomGsensorView.h"
static float x_min_shaft=150;
static float y_min_shaft=100;

@implementation CustomGsensorView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    /*
     
     x代表左右 
     y代表前后
     z代表上下
     
     
    2 ｜
    1 ｜
    0 ｜
   -1 ｜
   -2 ｜
      ｜————————————————————————时间轴
     
     */
    
    float spaceX=30;
    float shortLineWidth=5;
    float spaceY=20;
    
    float X_shaft=0.0;
    float Y_shaft=0.0;

    if(x_min_shaft<NSMaxX(self.bounds)){
        X_shaft=NSMaxX(self.bounds);
    }else{
        X_shaft=x_min_shaft;
    }
    
    if(y_min_shaft<NSMaxY(self.bounds)){
        Y_shaft=NSMaxY(self.bounds);
    }else{
        Y_shaft=y_min_shaft;
    }
    
    
    NSBezierPath *bezierPath=[NSBezierPath bezierPath];
    
    //画出y轴
    NSPoint originP=NSMakePoint(spaceX,spaceY);
    [bezierPath moveToPoint:originP];
    [bezierPath lineToPoint:NSMakePoint(spaceX,Y_shaft)];
    
    float _ly=(Y_shaft-spaceY)/6;
    //-2.0 -1.0
    NSMutableDictionary *fattr=[NSMutableDictionary dictionary];
    [fattr setObject:[NSFont fontWithName:@"Helvetica" size:12] forKey:NSFontAttributeName];
    [fattr setObject:[NSColor brownColor] forKey:NSForegroundColorAttributeName];
    

    NSString *numbers[]={@"-2.0",@"-1.0",@"0.0",@"1.0",@"2.0"};
    for(int i=0;i<5;i++){
         [bezierPath moveToPoint:NSMakePoint(spaceX,spaceY+ _ly*(i+1))];
         [bezierPath lineToPoint:NSMakePoint(spaceX-shortLineWidth,spaceY+ _ly*(i+1))];
        
         NSSize size=[numbers[i] sizeWithAttributes:fattr];
        
        
         [numbers[i] drawAtPoint:NSMakePoint(spaceX-shortLineWidth-size.width,spaceY+ _ly*(i+1)-size.height/2) withAttributes:fattr];
    }
    

    
    
    
    
    
    [bezierPath moveToPoint:originP];
    [bezierPath lineToPoint:NSMakePoint(X_shaft,20)];
    
    [[NSColor greenColor] set];
    [bezierPath stroke];
    
    
}

@end
