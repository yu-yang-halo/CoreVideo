//
//  PreferenceController.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>
extern NSString *const SPEED_UNIT_NOTIFICATION;
@interface PreferenceController : NSWindowController
@property (weak) IBOutlet NSMatrix *languageRadio;
@property (weak) IBOutlet NSMatrix *speedUnitRadio;

@end
