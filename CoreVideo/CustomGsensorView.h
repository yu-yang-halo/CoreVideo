//
//  CustomGsensorView.h
//  CoreVideo
//
//  Created by apple on 15/9/20.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomGsensorView : NSView
//xValue yValue zValue
@property(nonatomic,strong) NSMutableArray *gsensorArray;

-(void)updateGsensorRange:(int)len;

@end
