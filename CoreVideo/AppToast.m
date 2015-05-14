//
//  AppToast.m
//  CoreVideo
//
//  Created by apple on 15/10/7.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "AppToast.h"
#import "CVToastWindowController.h"
#import "AppDelegate.h"
@implementation AppToast
static bool winlock=false;
+(void)showToast:(NSString *)text duration:(float)duration{
 
    if(!winlock){
        winlock=true;
        CVToastWindowController *toastWC=[[CVToastWindowController alloc] init];
        
        
        [toastWC setText:text];
        [toastWC.window makeKeyAndOrderFront:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(closeWin:) userInfo:toastWC repeats:NO];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:duration];
            [[toastWC.window  animator] setAlphaValue:0.0];
        } completionHandler:^{
            NSLog(@"All done!");
            [[toastWC.window  animator] setAlphaValue:1.0];
            
        }];
  
    }
    
    
    

}
+(void)closeWin:(NSTimer *)timer{
    CVToastWindowController *cvt=(CVToastWindowController *)timer.userInfo;
    [cvt close];
    NSLog(@"close window");
    winlock=false;
}


@end
