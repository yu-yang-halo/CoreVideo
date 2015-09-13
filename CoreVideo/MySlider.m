//
//  MySlider.m
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "MySlider.h"
#import "AppDelegate.h"
@implementation MySlider

-(void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    NSLog(@"catch mouse down %@",theEvent);
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    [delegate.videoVC.player play];
}

@end
