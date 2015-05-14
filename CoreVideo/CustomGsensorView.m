//
//  CustomGsensorView.m
//  CoreVideo
//
//  Created by apple on 15/9/20.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "CustomGsensorView.h"
static float x_min_shaft=0;
static float y_min_shaft=0;

@interface CustomGsensorView(){
    int index;//gsensor array index
    
    
}


@end

@implementation CustomGsensorView

-(void)updateGsensorRange:(int)len{
    index=len;
    [self setNeedsDisplay:YES];
}

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
    float spaceY=0;
    
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
    [[NSColor whiteColor] set];
    [bezierPath stroke];
    
    float _ly=(Y_shaft-spaceY)/6;
    //-2.0 -1.0
    NSMutableDictionary *fattr=[NSMutableDictionary dictionary];
    [fattr setObject:[NSFont systemFontOfSize:10] forKey:NSFontAttributeName];
    [fattr setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
    

    NSString *numbers[]={@"-2.0",@"-1.0",@"0.0",@"1.0",@"2.0"};
    for(int i=0;i<5;i++){
         [bezierPath moveToPoint:NSMakePoint(spaceX,spaceY+ _ly*(i+1))];
         [bezierPath lineToPoint:NSMakePoint(spaceX-shortLineWidth,spaceY+ _ly*(i+1))];
        
         NSSize size=[numbers[i] sizeWithAttributes:fattr];
        
        
         [numbers[i] drawAtPoint:NSMakePoint(spaceX-shortLineWidth-size.width,spaceY+ _ly*(i+1)-size.height/2) withAttributes:fattr];
    }
    
    
    [bezierPath moveToPoint:originP];
    [bezierPath lineToPoint:NSMakePoint(X_shaft,spaceY)];
    
    [[NSColor whiteColor] set];
    [bezierPath stroke];

    
    NSBezierPath *bezierPathX=[NSBezierPath bezierPath];
    NSBezierPath *bezierPathY=[NSBezierPath bezierPath];
    NSBezierPath *bezierPathZ=[NSBezierPath bezierPath];
    
    //-3~3 _ly  x:  i/count*(X_shaft-spaceX) y
    
    if(_gsensorArray!=nil&&[_gsensorArray count]>=(index+1)){
        NSArray *subArr=[_gsensorArray subarrayWithRange:NSMakeRange(0,index+1)];
        
        for (int i=0;i<[subArr count];i++) {
            float xValue=[subArr[i][0] floatValue];
            float yValue=[subArr[i][1] floatValue];
            float zValue=[subArr[i][2] floatValue];
            
            NSPoint xP=NSMakePoint(spaceX+((float)(i+1)/[_gsensorArray count])*(X_shaft-spaceX),(xValue+3)*_ly+spaceY);
            NSPoint yP=NSMakePoint(spaceX+((float)i/[_gsensorArray count])*(X_shaft-spaceX),(yValue+3)*_ly+spaceY);
            
            NSPoint zP=NSMakePoint(spaceX+((float)i/[_gsensorArray count])*(X_shaft-spaceX),(zValue+3)*_ly+spaceY);
            
            if(i==0){
                [bezierPathX moveToPoint:xP];
                [bezierPathY moveToPoint:yP];
                [bezierPathZ moveToPoint:zP];
            }else{
                [bezierPathX lineToPoint:xP];
                [bezierPathY lineToPoint:yP];
                [bezierPathZ lineToPoint:zP];
                
            }
            
            
            
        
            
        }
        
        [[NSColor redColor] set];
        [bezierPathX stroke];
        
        [[NSColor greenColor] set];
        [bezierPathY stroke];
        

        [[NSColor blueColor] set];
        [bezierPathZ stroke];
        

        
    }
    
    
}

@end
