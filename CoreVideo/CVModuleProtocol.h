//
//  CVModuleProtocol.h
//  CoreVideo
//
//  Created by admin on 15/9/29.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

@protocol CVModuleProtocol <NSObject>

#pragma mark 放大缩小播放窗口    代理协议
-(NSInteger)zoomInVideoPlayWindow:(NSInteger)state;

#pragma mark 放大缩小地图窗口    代理协议
-(NSInteger)zoomInMapWindow:(NSInteger)state;


#pragma mark 根据视频路径获取想要的视频数据进行逻辑处理
-(void)dataLogicProcessOfViodePath:(NSString *)playVideoPath;

#pragma mark 根据当前的时间及时的更新数据
-(void)updateDataByCurrentTime:(Float64)time;

#pragma mark 获取视频的总时间
-(void)videoAllTime:(Float64)allTime;
#pragma mark 获取总距离
-(void)totalDistance:(float)distance;

#pragma mark 视频结束
-(void)videoEnd;

#pragma mark 播放下一个文件
-(void)playNext:(BOOL)isNext;


@end