//
//  VideoViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/12.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "VideoViewController.h"
#import "AppColorManager.h"
#import "AppDelegate.h"
#import "TimeFormatUtils.h"
#import "AppToast.h"

static void *AVSPPlayerItemStatusContext = &AVSPPlayerItemStatusContext;
static void *AVSPPlayerRateContext = &AVSPPlayerRateContext;
static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

static int RATE_VIDEO[]={2,5,10,60};
static int RATE_VIDEO_LENGTH=4;


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

@property (weak) IBOutlet NSButton *voiceBtn;
- (IBAction)clickVoiceBtn:(id)sender;

- (IBAction)playOrPause:(id)sender;
- (IBAction)capture:(id)sender;
- (IBAction)lookPicture:(id)sender;

- (IBAction)forwardRate:(id)sender;

- (IBAction)backwardRate:(id)sender;


- (IBAction)zoomInOut:(id)sender;

- (IBAction)nextFile:(id)sender;

- (IBAction)lastFile:(id)sender;

@end

@implementation VideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor blackColor] CGColor]];
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    delegate.videoVC=self;
    
    [self.controlView setWantsLayer:YES];
    [self.controlView.layer setCornerRadius:2];
    [self.controlView.layer setBackgroundColor:[[AppColorManager appBackgroundColor] CGColor]];
    
    self.voiceBtn.tag=1;
    
    
    
}


-(void)initAssetData:(NSURL *)url{
    if(url==nil){
        return;
    }
    [self.gpsDelegate dataLogicProcessOfViodePath:url.absoluteString];
    [self.gpsInfoDelegate dataLogicProcessOfViodePath:url.absoluteString];
    [self.speedDelegate  dataLogicProcessOfViodePath:url.absoluteString];
    

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
            NSLog(@"error %@",error);
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
      
       
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
        self.player=[AVPlayer playerWithPlayerItem:playerItem];
        
        
        
        self.videolayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        self.videolayer.frame = self.containerView.layer.bounds;
        self.videolayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
         NSLog(@"隐藏视频图像  %d",self.videolayer.readyForDisplay);
        
        
        self.videolayer.hidden = YES;
        
        [self.containerView.layer addSublayer:_videolayer];
        
        [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerRateContext];
        [self addObserver:self forKeyPath:@"player.currentItem.status" options: NSKeyValueObservingOptionNew context:AVSPPlayerItemStatusContext];
        [self addObserver:self forKeyPath:@"videolayer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
        
        
        
        // Use a weak self variable to avoid a retain cycle in the block
        __weak VideoViewController *weakSelf = self;
        
        self.totalTimeField.stringValue=[TimeFormatUtils stringFromSeconds:CMTimeGetSeconds(playerItem.asset.duration)];
        [self.speedDelegate videoAllTime:CMTimeGetSeconds(playerItem.asset.duration)];
        [self.gpsDelegate videoAllTime:CMTimeGetSeconds(playerItem.asset.duration)];
        [self.gpsInfoDelegate videoAllTime:CMTimeGetSeconds(playerItem.asset.duration)];
        
        
        
        [self setTimeObserverToken:[[self player] addPeriodicTimeObserverForInterval:CMTimeMake(1, 100) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            [weakSelf.gpsDelegate updateDataByCurrentTime:CMTimeGetSeconds(time)];
            [weakSelf.gpsInfoDelegate updateDataByCurrentTime:CMTimeGetSeconds(time)];
            
            [weakSelf.speedDelegate updateDataByCurrentTime:CMTimeGetSeconds(time)];
            
            
            weakSelf.timeSlider.doubleValue = CMTimeGetSeconds(time);
            weakSelf.currentTimeField.stringValue=[TimeFormatUtils stringFromSeconds:CMTimeGetSeconds(time)];
            
            
            if(CMTimeGetSeconds(playerItem.asset.duration)==CMTimeGetSeconds(time)){
               
                [weakSelf.videoEndDelegate videoEnd];
            }
            
            
            
        }]];
        
        self.volumSlider.floatValue=self.player.volume;
        
        if(self.player.volume>0){
            [self.voiceBtn setImage:[NSImage imageNamed:@"speaker_on"]];
        }else{
            [self.voiceBtn setImage:[NSImage imageNamed:@"speaker_off"]];
        }
        
        [_player play];

        
        
        
    }
    else
    {
        // This asset has no video tracks. Show the "No Video" label.
        NSLog(@"NO Video");
    }
    
    // Create a new AVPlayerItem and make it our player's current item.
    
    
    
    // If needed, configure player item here (example: adding outputs, setting text style rules, selecting media options) before associating it with a player
    //[self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    
    
    
    
   
}



- (IBAction)clickVoiceBtn:(id)sender {
    
    NSButton *mVoiceBtn=(NSButton *)sender;
    
    
    if(mVoiceBtn.tag==1){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
        
        [self setVolume:0];
        
    }else{
        NSNumber *vNumValue=[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"];
        [mVoiceBtn setImage:[NSImage imageNamed:@"speaker_on"]];
        [self setVolume:[vNumValue floatValue]];
        [mVoiceBtn setTag:1];
    }
    
}

- (IBAction)playOrPause:(id)sender {
    i=0;
    j=0;
    
    NSButton *btn=(NSButton *)sender;
    NSLog(@"state: %ld",btn.state);
    if(self.player==nil){
        return;
    }
    if (self.player.rate == 0.f)
    {
        if (self.currentTime == [self duration])
            [self setCurrentTime:0.f];
        [self.player play];
        
    }else{
        [self.player pause];
       
    }
    
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
        [AppToast showToast:NSLocalizedString(@"capture_fail", nil) duration:0.8];
    }
    
    
}

- (IBAction)lookPicture:(id)sender {
    
    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[self pictureSaveDirectory]];
    
}
static int i=0;
static int j=0;

- (IBAction)forwardRate:(id)sender {
    j=0;
    if(self.player!=nil){
        if(i>=RATE_VIDEO_LENGTH){
            i=0;
        }
        int rate_val=RATE_VIDEO[i++];
        [self.player setRate:rate_val];
        [AppToast showToast:[NSString stringWithFormat:@"%dx",rate_val] duration:0.8];
    }
}

- (IBAction)backwardRate:(id)sender {
    i=0;
    if(self.player!=nil){
        if(j>=RATE_VIDEO_LENGTH){
            j=0;
        }
        int rate_val=-RATE_VIDEO[j++];
        [self.player setRate:rate_val];
        [AppToast showToast:[NSString stringWithFormat:@"%dx",rate_val] duration:0.8];
    }
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
    if(volume==0){
         [_voiceBtn setImage:[NSImage imageNamed:@"speaker_off"]];
         [_voiceBtn setTag:0];
    }else{
        [_voiceBtn setImage:[NSImage imageNamed:@"speaker_on"]];
        [_voiceBtn setTag:1];
    }
}


- (IBAction)zoomInOut:(NSButton *)sender {
    zoomState=[self.zoomInDelegate zoomInVideoPlayWindow:zoomState];
}

- (IBAction)nextFile:(id)sender {
    [_videoEndDelegate playNext:YES];
}

- (IBAction)lastFile:(id)sender {
    [_videoEndDelegate playNext:NO];
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
       
        NSError *error;
        
        CGImageRef cgimageRef=[_imageGenerator copyCGImageAtTime:self.player.currentTime actualTime:NULL error:&error];
        
        if(error==nil){
            NSImage *image=[[NSImage alloc] initWithCGImage:cgimageRef size:NSSizeFromCGSize(CGSizeMake(300,200))];
            NSFileManager *fileMgr=[NSFileManager defaultManager];
            [fileMgr createFileAtPath:diskPath contents:[image TIFFRepresentation] attributes:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error==nil){
                [AppToast showToast:NSLocalizedString(@"capture_suc", nil) duration:0.8];
            }else{
                [AppToast showToast:NSLocalizedString(@"capture_fail", nil) duration:0.8];
            }
            
        });
      
        
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
                NSLog(@"AVPlayerItemStatusFailed %@",[[[self player] currentItem] error]);
                break;
        }
        
        self.playButton.enabled = enable;
    }
    else if (context == AVSPPlayerRateContext)
    {
        float rate = [change[NSKeyValueChangeNewKey] floatValue];
        NSLog(@"rate : %f",rate);
        if(rate==0.f){
             [_playButton setImage:[NSImage imageNamed:@"player_play"]];
        }else{
             [_playButton setImage:[NSImage imageNamed:@"player_pause"]];
        }
        
       
    }
    else if (context == AVSPPlayerLayerReadyForDisplay)
    {
        
        if ([change[NSKeyValueChangeNewKey] boolValue] == YES)
        {
            // The AVPlayerLayer is ready for display. Hide the loading spinner and show it.
            NSLog(@"显示视频图像");
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

- (IBAction)openFile:(id)sender {
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    [delegate openFile:sender];
}

@end
