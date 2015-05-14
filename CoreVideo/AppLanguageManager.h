//
//  AppLanguageManager.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLanguageManager : NSObject

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

+(NSString *)systemCurrentLanguage;


@end
