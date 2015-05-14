//
//  CVTextField.m
//  CoreVideo
//
//  Created by apple on 15/10/31.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "CVTextField.h"

@implementation CVTextField

- (void)drawRect:(NSRect)dirtyRect {
    
    
    CGFloat width = dirtyRect.size.width;
    CGFloat height = dirtyRect.size.height;
    CGFloat angle=10;
    CGFloat LineWidth=5;
    // Drawing code here.
    /*
        |-------------
        |
        |
     
     */
    NSBezierPath *path=[NSBezierPath bezierPath];
    
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(width-angle, 0)];
    [path lineToPoint:NSMakePoint(width,height/2)];
    [path lineToPoint:NSMakePoint(width-angle,height)];
    [path lineToPoint:NSMakePoint(0,height)];
    [path lineToPoint:NSMakePoint(0,0)];
    
    [path setLineWidth:LineWidth];
    [[NSColor blackColor] set];
    [path fill];
    
    [super drawRect:dirtyRect];
    
    
}

@end
