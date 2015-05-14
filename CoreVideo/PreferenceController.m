//
//  PreferenceController.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "PreferenceController.h"
#import "AppLanguageManager.h"
#import "AppUserDefaults.h"

NSString *const SPEED_UNIT_NOTIFICATION=@"speed_unit_notification";
@interface PreferenceController ()


@end

@implementation PreferenceController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window setTitle:NSLocalizedString(@"setting",nil)];
    NSLog(@" %@",[AppLanguageManager systemCurrentLanguage]);
    //zh-Hans
    if([@"zh-Hans" isEqualToString:[AppLanguageManager systemCurrentLanguage]]){
       
        [_languageRadio setState:1 atRow:0 column:0];
        [_languageRadio setState:0 atRow:0 column:1];
        
    }else{
        
        [_languageRadio setState:1 atRow:0 column:1];
        [_languageRadio setState:0 atRow:0 column:0];
    }
    
    
    if([AppUserDefaults isKMPH]){
        
        [_speedUnitRadio setState:1 atRow:0 column:0];
        [_speedUnitRadio setState:0 atRow:0 column:1];
        
    }else{
        
        [_speedUnitRadio setState:1 atRow:0 column:1];
        [_speedUnitRadio setState:0 atRow:0 column:0];
        
    }
    
}
-(NSString *)windowNibName{
    return @"PreferenceController";
}

- (IBAction)speedUnitChange:(NSMatrix *)sender {
   
    NSLog(@"%ld",sender.selectedColumn);
    
    if(sender.selectedColumn==0){
        [[NSUserDefaults standardUserDefaults] setObject:KMPH forKey:@"speed_unit"];
        [AppUserDefaults setSpeedUnit:KMPH];
    }else{
        [AppUserDefaults setSpeedUnit:MILEPH];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SPEED_UNIT_NOTIFICATION object:nil];
    
}
@end
