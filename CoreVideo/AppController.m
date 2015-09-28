//
//  AppController.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"
@implementation AppController



- (IBAction)showPreferencePanel:(id)sender {
    if(!preferenceController){
        preferenceController=[[PreferenceController alloc] init];
    }
    
    [preferenceController showWindow:self];
}
@end
