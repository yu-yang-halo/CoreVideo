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
#import "AppColorManager.h"
@interface PlayListViewController (){
    NSInteger selectIndex;
}

@property (weak) IBOutlet NSTableView *tableView;
- (IBAction)addVideoPlay:(id)sender;
- (IBAction)removeVideoPlay:(id)sender;

@property (weak) IBOutlet NSTableHeaderView *headerView;

@property (weak) IBOutlet NSButton *buttonAdd;
@property (weak) IBOutlet NSButton *buttonRemove;

@property(nonatomic,strong) NSMutableArray *playlist;
@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
   
    [self setButtonColor:_buttonAdd andColor:[NSColor whiteColor]];
    [self setButtonColor:_buttonRemove andColor:[NSColor whiteColor]];
    
    
    [self.tableView setBackgroundColor:[NSColor blackColor
                                        ]];
    
    [self.tableView.headerView setFrame:NSZeroRect];
    [self.tableView setHeaderView:nil];
    
    
    [self.tableView setFocusRingType:NSFocusRingTypeNone];
    [self.tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    
    
    [self.tableView setRowSizeStyle:NSTableViewRowSizeStyleCustom];
    
    
    
    if(_tableView.headerView==_headerView){
        NSLog(@"YES");
    
   
    }else{
        NSLog(@"NO");
    }
    
    
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    delegate.playlistVC=self;
    self.playlist=[NSMutableArray new];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    selectIndex=-1;
   
}

- (IBAction)addVideoPlay:(id)sender {
    
    [[NSDocumentController sharedDocumentController] beginOpenPanelWithCompletionHandler:^(NSArray *fileList) {
        NSLog(@"%@",fileList);
        if(fileList!=nil&&[fileList count]>0){
            [MyCache playPathArrCache:fileList block:^{
                [self reloadPlayListData];
            }];
        }
        
    }];
    

}

- (IBAction)removeVideoPlay:(id)sender {
    NSLog(@"selectIndex : %ld",selectIndex);
    if(_playlist!=nil){
        if(selectIndex>=0&&selectIndex<[_playlist count]){
            [_playlist removeObjectAtIndex:selectIndex];
            [MyCache syncPlayList:_playlist];
            
             AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
            [delegate.videoVC close];
        }
        [self reloadPlayListData];
        [_tableView deselectAll:self];
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
        NSString *abbrev=[NSString stringWithFormat:@"%ld:%@",row,[self abbreviationFile:[[_playlist objectAtIndex:row] objectForKey:keyPATH]]];
        
        NSNumber *activeYN=[[_playlist objectAtIndex:row] objectForKey:keyActiveYN];
        
        if(activeYN!=nil&&[activeYN boolValue]==YES){
            [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
            selectIndex=row;
        
        }
         //NSLog(@"*****************row %ld  selectIndex %ld",row,selectIndex);
        return [abbrev stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
  
}
-(NSString *)abbreviationFile:(NSString *)path{
    
    return [path lastPathComponent];
}


- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes NS_AVAILABLE_MAC(10_5){
  
    
    selectIndex=proposedSelectionIndexes.firstIndex;
    
    [self selectIndexPlay:selectIndex];
    
    return proposedSelectionIndexes;
}
-(void)playNext:(BOOL)isNext{
    if(isNext){
        selectIndex++;
    }else{
        selectIndex--;
    }
    
    [self selectIndexPlay:selectIndex];
    
}
-(void)selectIndexPlay:(NSInteger)index{
    if(index<[_playlist count]){
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
        [self playCurrentItem:[[_playlist objectAtIndex:index] objectForKey:keyPATH]];
        
        AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
        [delegate activeCurrentPlayIndex:index];
    }else{
        selectIndex=-1;
    }
    
    [self reloadPlayListData];
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"%@",tableColumn);
}

-(void)playCurrentItem:(NSString *)path{
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    [delegate.videoVC close];
    
    [delegate.videoVC initAssetData:[NSURL URLWithString:path]];
}
- (void)setButtonColor:(NSButton *)button andColor:(NSColor *)color {
    if (color == nil) {
        color = [NSColor redColor];
    }
    
    int fontSize = 16;
    NSFont *font = [NSFont systemFontOfSize:fontSize];
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:font,
                            NSFontAttributeName,
                            color,
                            NSForegroundColorAttributeName,
                            
                            nil];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[button title] attributes:attrs];
    [attributedString setAlignment:NSRightTextAlignment range:NSMakeRange(0, [attributedString length])];
    
    [button setAttributedTitle:attributedString];
  
}
-(void)videoEnd{
     NSLog(@"video over...");
    
     [self selectIndexPlay:(++selectIndex)];
    
}

@end
