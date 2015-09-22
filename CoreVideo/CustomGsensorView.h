//
//  CustomGsensorView.h
//  CoreVideo
//
//  Created by apple on 15/9/20.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomGsensorView : NSView
//xValue yValue zValue
@property(nonatomic,strong) NSMutableArray *gsensorArray;

-(void)updateGsensorRange:(int)len;

@end
