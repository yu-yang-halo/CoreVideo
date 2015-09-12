//
//  VideoViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/12.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "VideoViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoViewController ()
@property(nonatomic,strong) AVAssetImageGenerator *imageGenerator;
@property(nonatomic,strong) AVPlayer *player;
@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSButton *playButton;

@property (weak) IBOutlet NSButton *pauseButton;
@property (weak) IBOutlet NSButton *captureButton;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

- (IBAction)capture:(id)sender;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.containerView setWantsLayer:YES];
    [self.containerView.layer setBackgroundColor:[[NSColor blackColor] CGColor]];
    
    

    
    AVAsset *asset=[AVAsset assetWithURL:[NSURL URLWithString:@"file:///Users/admin/Desktop/video.mov"]];
    self.imageGenerator=[[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    AVPlayerItem *playItem=[AVPlayerItem playerItemWithAsset:asset];
    self.player=[AVPlayer playerWithPlayerItem:playItem];
    
    AVPlayerLayer *newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    newPlayerLayer.position=_containerView.layer.position;
    newPlayerLayer.frame = _containerView.layer.bounds;
    newPlayerLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    newPlayerLayer.hidden = NO;
    [self.containerView.layer addSublayer:newPlayerLayer];
    
   
    
    
    
}

- (IBAction)play:(id)sender {
    NSLog(@"play...");
    if (self.player.rate != 1.f)
    {
        if (self.currentTime == [self duration])
            [self setCurrentTime:0.f];
        [self.player play];
    }

}

- (IBAction)pause:(id)sender {
    NSLog(@"pause...");
    if (self.player.rate == 1.f)
    {
        [self.player pause];
    }
}

- (IBAction)capture:(id)sender {
    NSLog(@"capture...");
    
    if([self.player status]==AVPlayerItemStatusReadyToPlay){
        NSString *path=[NSString stringWithFormat:@"/Users/admin/Desktop/%@.png",[NSDate date]];
        [self saveImageFileToDiskPath:path];
    }else{
        
    }
    
    
}

-(void)saveImageFileToDiskPath:(NSString *)diskPath{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        CGImageRef cgimageRef=[_imageGenerator copyCGImageAtTime:self.player.currentTime actualTime:NULL error:nil];
        NSImage *image=[[NSImage alloc] initWithCGImage:cgimageRef size:NSSizeFromCGSize(CGSizeMake(300,200))];
        NSFileManager *fileMgr=[NSFileManager defaultManager];
        [fileMgr createFileAtPath:diskPath contents:[image TIFFRepresentation] attributes:nil];
        
    });
    
}


- (double)duration
{
    AVPlayerItem *playerItem = self.player.currentItem;
    
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
        return CMTimeGetSeconds(playerItem.asset.duration);
    else
        return 0.f;
}

- (double)currentTime
{
    return CMTimeGetSeconds(self.player.currentTime);
}

- (void)setCurrentTime:(double)time
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

@end
