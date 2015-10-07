//
//  CVToastWindowController.h
//  CoreVideo
//
//  Created by apple on 15/10/7.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CVToastWindowController : NSWindowController
@property(nonatomic,strong) NSString *text;
@property(nonatomic,assign) float duration;
@end
