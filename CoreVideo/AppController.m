//
//  AppController.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
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
