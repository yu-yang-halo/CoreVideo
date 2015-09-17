//
//  VideoViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/12.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "VideoViewController.h"

#import "AppDelegate.h"
#import "TimeFormatUtils.h"
#import "MySlider.h"

static void *AVSPPlayerItemStatusContext = &AVSPPlayerItemStatusContext;
static void *AVSPPlayerRateContext = &AVSPPlayerRateContext;
static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@interface VideoViewController (){
    NSInteger zoomState;//0 放大  1 缩小
}
@property (weak) IBOutlet NSView *controlView;
@property(nonatomic,strong) AVAssetImageGenerator *imageGenerator;

@property(nonatomic,strong) AVPlayerLayer *videolayer;
@property (strong) id timeObserverToken;
@property (weak) IBOutlet NSSlider *timeSlider;
@property (assign) double currentTime;
@property (readonly) double duration;
@property (assign) float volume;
@property (weak) IBOutlet NSSlider *volumSlider;

@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSTextField *currentTimeField;
@property (weak) IBOutlet NSTextField *totalTimeField;

@property (weak) IBOutlet NSButton *fileButton;
@property (weak) IBOutlet NSButton *captureButton;
@property(nonatomic,assign) BOOL isAddVideoFile;

- (IBAction)playOrPause:(id)sender;
- (IBAction)capture:(id)sender;
- (IBAction)lookPicture:(id)sender;
- (IBAction)volumChange:(id)sender;

- (IBAction)zoomInOut:(id)sender;

@end

@implementation VideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor blackColor] CGColor]];
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    delegate.videoVC=self;
    
    [self.controlView setWantsLayer:YES];
    [self.controlView.layer setCornerRadius:10];
    [self.controlView.layer setBackgroundColor:[[NSColor colorWithCalibratedRed:90 green:0 blue:10 alpha:0.5] CGColor]];
    
    
}


-(void)initAssetData:(NSURL *)url{
    if(url==nil){
        return;
    }
    [self.gpsMapdelegate loadGpsLoadPathToMapByPlayVideo:url.absoluteString];
    

    self.isAddVideoFile=YES;
    AVURLAsset *asset = [AVAsset assetWithURL:url];
    self.imageGenerator=[[AVAssetImageGenerator alloc] initWithAsset:asset];
   
    
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"hasProtectedContent", @"tracks"];
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^(void) {
        
        // The asset invokes its completion handler on an arbitrary queue when loading is complete.
        // Because we want to access our AVPlayer in our ensuing set-up, we must dispatch our handler to the main queue.
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self setUpPlaybackOfAsset:asset withKeys:assetKeysToLoadAndTest];
            
        });
        
    }];

   
   
}

- (void)setUpPlaybackOfAsset:(AVAsset *)asset withKeys:(NSArray *)keys
{
    // This method is called when the AVAsset for our URL has completing the loading of the values of the specified array of keys.
    // We set up playback of the asset here.
    
    // First test whether the values of each of the keys we need have been successfully loaded.
    for (NSString *key in keys)
    {
        NSError *error = nil;
        
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
        {
            NSLog(@"%@",error);
            return;
        }
    }
    
    if (![asset isPlayable] || [asset hasProtectedContent])
    {
        // We can't play this asset. Show the "Unplayable Asset" label.
        NSLog(@"无法播放该视频");
        return;
    }
    
    // We can play this asset.
    // Set up an AVPlayerLayer according to whether the asset contains video.
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
    {
        // Create an AVPlayerLayer and add it to the player view if there is video, but hide it until it's ready for display
        if(self.videolayer!=nil){
            [_videolayer removeFromSuperlayer];
        }
        self.player=[AVPlayer new];
        
        self.videolayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.videolayer.frame = self.containerView.layer.bounds;
        self.videolayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
        self.videolayer.hidden = YES;
        
        [self.containerView.layer addSublayer:_videolayer];
        
        [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew context:AVSPPlayerRateContext];
        [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:AVSPPlayerItemStatusContext];
        [self addObserver:self forKeyPath:@"videolayer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
        
        
    }
    else
    {
        // This asset has no video tracks. Show the "No Video" label.
        NSLog(@"NO Video");
    }
    
    // Create a new AVPlayerItem and make it our player's current item.
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    

    
    
    // If needed, configure player item here (example: adding outputs, setting text style rules, selecting media options) before associating it with a player
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    // Use a weak self variable to avoid a retain cycle in the block
    __weak VideoViewController *weakSelf = self;
   
    self.totalTimeField.stringValue=[TimeFormatUtils stringFromSeconds:CMTimeGetSeconds(playerItem.asset.duration)];
    
    [self setTimeObserverToken:[[self player] addPeriodicTimeObserverForInterval:CMTimeMake(1, 100) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
         [weakSelf.gpsMapdelegate updateGpsDataToMapByCurrentTime:CMTimeGetSeconds(time)];
        
         weakSelf.timeSlider.doubleValue = CMTimeGetSeconds(time);
         weakSelf.currentTimeField.stringValue=[TimeFormatUtils stringFromSeconds:CMTimeGetSeconds(time)];
    }]];
    
    self.volumSlider.floatValue=self.player.volume;
    [_player play];
    
}

- (IBAction)valueChange:(NSSlider *)sender {
   
    
    [_player pause];
    [self setCurrentTime:sender.floatValue];
}


-(void)playOrPause{
    if (self.player.rate != 1.f)
    {
        if (self.currentTime == [self duration])
            [self setCurrentTime:0.f];
        [self.player play];
    }else{
        [self.player pause];
    }
}

- (IBAction)playOrPause:(id)sender {
    [self playOrPause];
    
}

-(NSString *)pictureSaveDirectory{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,NSUserDomainMask,YES);
    NSString *docDir=[paths objectAtIndex:0];
    NSString *pictureDir=[NSString stringWithFormat:@"%@/capture",docDir];
    BOOL isDirectory=YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:pictureDir isDirectory:&isDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:pictureDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return pictureDir;
}

- (IBAction)capture:(id)sender {
    NSLog(@"capture...");
    
    if([self.player status]==AVPlayerItemStatusReadyToPlay){
        NSString *path=[NSString stringWithFormat:@"%@/%@.png",[self pictureSaveDirectory],[TimeFormatUtils stringDateFormat:[NSDate new]]];
        [self saveImageFileToDiskPath:path];
    }else{
        
    }
    
    
}

- (IBAction)lookPicture:(id)sender {
    
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[self pictureSaveDirectory]];
    
}
+(NSSet *)keyPathsForValuesAffectingVolume{
    return [NSSet setWithObject:@"player.volume"];
}
- (float)volume
{
    
    return self.player.volume;
}

- (void)setVolume:(float)volume
{
    self.player.volume = volume;
}

- (IBAction)volumChange:(NSSlider *)sender {
     NSLog(@"%f",sender.floatValue);
    [self setVolume:sender.floatValue];
}

- (IBAction)zoomInOut:(NSButton *)sender {
    [self.delegate zoomIOView:zoomState];
    
    if(zoomState==0){
        zoomState=1;
        NSLog(@"放大");
    }else{
        zoomState=0;
        NSLog(@"缩小");
    }
    
}
- (void)close
{
    
    if(self.isAddVideoFile){
        [self.player pause];
        [self.player removeTimeObserver:[self timeObserverToken]];
        self.timeObserverToken = nil;
        [self removeObserver:self forKeyPath:@"player.rate"];
        [self removeObserver:self forKeyPath:@"player.currentItem.status"];
        if (self.videolayer){
            [[self videolayer] removeFromSuperlayer];
            [self removeObserver:self forKeyPath:@"videolayer.readyForDisplay"];
        }
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.currentTimeField.stringValue=[TimeFormatUtils stringFromSeconds:0];
        self.totalTimeField.stringValue=[TimeFormatUtils stringFromSeconds:0];
    }
    self.isAddVideoFile=NO;
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
     self.currentTimeField.stringValue=[TimeFormatUtils stringFromSeconds:time];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVSPPlayerItemStatusContext)
    {
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        BOOL enable = NO;
        switch (status)
        {
            case AVPlayerItemStatusUnknown:
                break;
            case AVPlayerItemStatusReadyToPlay:
                enable = YES;
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"%@",[[[self player] currentItem] error]);
                break;
        }
        
        self.playButton.enabled = enable;
    }
    else if (context == AVSPPlayerRateContext)
    {
        float rate = [change[NSKeyValueChangeNewKey] floatValue];
        if (rate != 1.f)
        {
            self.playButton.title = @"播放";
        }
        else
        {
            self.playButton.title = @"停止";
        }
    }
    else if (context == AVSPPlayerLayerReadyForDisplay)
    {
        if ([change[NSKeyValueChangeNewKey] boolValue] == YES)
        {
            // The AVPlayerLayer is ready for display. Hide the loading spinner and show it.
        
            self.videolayer.hidden = NO;
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
+ (NSSet *)keyPathsForValuesAffectingDuration
{
    return [NSSet setWithObjects:@"player.currentItem", @"player.currentItem.status", nil];
}


@end
