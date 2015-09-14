//
//  PlayListViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "PlayListViewController.h"
#import "MyCache.h"
#import "AppDelegate.h"
@interface PlayListViewController (){
    NSInteger selectIndex;
}

@property (weak) IBOutlet NSTableView *tableView;
- (IBAction)addVideoPlay:(id)sender;
- (IBAction)removeVideoPlay:(id)sender;
@property(nonatomic,strong) NSMutableArray *playlist;
@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    delegate.playlistVC=self;
    self.playlist=[NSMutableArray new];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    selectIndex=-1;
}

- (IBAction)addVideoPlay:(id)sender {
    
}

- (IBAction)removeVideoPlay:(id)sender {
    NSLog(@"selectIndex : %ld",selectIndex);
    if(_playlist!=nil){
        if(selectIndex>=0&&selectIndex<[_playlist count]){
            [_playlist removeObjectAtIndex:selectIndex];
             AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
            [delegate.videoVC close];
        }
        [_tableView reloadData];
    }
    selectIndex=-1;
    
}


-(void)reloadPlayListData{
    self.playlist=[[MyCache playList] mutableCopy];
    [_tableView reloadData];
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if(_playlist!=nil){
        return [_playlist count];
    }else{
        return 0;
    }
    
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if(_playlist!=nil){
        return [_playlist objectAtIndex:row];
    }else{
        return @"";
    }
  
}
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return NO;
}

- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes NS_AVAILABLE_MAC(10_5){
    NSLog(@"%ld : %ld",proposedSelectionIndexes.firstIndex,proposedSelectionIndexes.lastIndex);
    
    selectIndex=proposedSelectionIndexes.firstIndex;
    if(selectIndex<[_playlist count]){
         [self playCurrentItem:[_playlist objectAtIndex:selectIndex]];
    }
   
    
    return proposedSelectionIndexes;
}

-(void)playCurrentItem:(NSString *)path{
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    [delegate.videoVC close];
    
    [delegate.videoVC initAssetData:[NSURL URLWithString:path]];
}

@end
