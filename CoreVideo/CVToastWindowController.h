//
//  CVToastWindowController.h
//  CoreVideo
//
//  Created by apple on 15/10/7.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CVToastWindowController : NSWindowController
@property(nonatomic,strong) NSString *text;
@property(nonatomic,assign) float duration;
@end
