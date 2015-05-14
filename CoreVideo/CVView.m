//
//  CVView.m
//  CoreVideo
//
//  Created by admin on 15/10/30.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "CVView.h"

@implementation CVView

-(void)drawRect:(NSRect)rect{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
   
    
    /*
    3__________|2
     |          |
     ________1 |
     */
    
    
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius =2;
    CGFloat dxy=3;
    CGFloat lineWidth=0.6;
    
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];
    // 移动到初始点
    CGContextMoveToPoint(context, radius+dxy, dxy);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius-dxy, dxy);
    CGContextAddArc(context, width - radius-dxy, radius+dxy, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width-dxy, height - radius-dxy);
    CGContextAddArc(context, width - radius-dxy, height - radius-dxy, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius+dxy, height-dxy);
    CGContextAddArc(context, radius+dxy, height - radius-dxy, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, dxy, radius+dxy);
    CGContextAddArc(context, radius+dxy, radius+dxy, radius, M_PI, 1.5 * M_PI, 0);
    
    CGContextSetLineWidth(context, lineWidth);
   
    // 闭合路径
    CGContextClosePath(context);
    //CGContextSetAllowsAntialiasing(context,false);
    // 填充半透明黑色
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
   
}

@end
