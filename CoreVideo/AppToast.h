//
//  AppToast.h
//  CoreVideo
//
//  Created by apple on 15/10/7.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppToast : NSObject

+(void)showToast:(NSString *)text duration:(float)duration;

@end
