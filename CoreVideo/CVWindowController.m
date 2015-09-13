//
//  CVWindowController.m
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWindowController.h"
#import "AppDelegate.h"
@interface CVWindowController ()

@end

@implementation CVWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    delegate.windowVC=self;
    
    NSLog(@"windowDidLoad...");
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (void)windowWillLoad{
    NSLog(@"windowWillLoad...");
}
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName{
    return @"行车记录仪";
}

@end
