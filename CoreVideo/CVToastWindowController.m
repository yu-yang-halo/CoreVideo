//
//  CVToastWindowController.m
//  CoreVideo
//
//  Created by apple on 15/10/7.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
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
