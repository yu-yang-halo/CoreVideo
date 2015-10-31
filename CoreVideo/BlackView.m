//
//  BlackView.m
//  CoreVideo
//
//  Created by apple on 15/10/31.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "BlackView.h"

@implementation BlackView


-(void)awakeFromNib{
    [self.layer setBackgroundColor:[[NSColor blackColor] CGColor]];
}

@end
