//
//  AppController.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PreferenceController;
@interface AppController : NSObject{
    PreferenceController *preferenceController;
}
- (IBAction)showPreferencePanel:(id)sender;



@end
