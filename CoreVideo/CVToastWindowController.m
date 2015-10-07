//
//  CVToastWindowController.m
//  CoreVideo
//
//  Created by apple on 15/10/7.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVToastWindowController.h"

@interface CVToastWindowController ()
@property (weak) IBOutlet NSTextField *textLabel;
@property (weak) IBOutlet NSView *view;

@end

@implementation CVToastWindowController


- (void)windowDidLoad {
    [super windowDidLoad];
    if(_text!=nil){
        [_textLabel setStringValue:_text];
    }
}
-(NSString *)windowNibName{
    return @"CVToastWindowController";
}


@end
