//
//  CVWebViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "CVWebViewController.h"
#import "MyCache.h"
#import "JSONKit.h"
#import "BDTransUtil.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface CVWebViewController ()
{
    NSMutableArray *currentVideoGpsDataArr;
    NSString       *currentPlayVideoPath;
    Float64         totalTime;
    BOOL  currentLocationChina;
    
     NSInteger zoomState;//0 放大  1 缩小
}

@end

@implementation CVWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
        默认加载百度地图（中国内）
     */
    currentLocationChina=YES;
    
    self.webview=[[WebView alloc] initWithFrame:self.view.bounds];
    [self loadMapHTMLData:currentLocationChina];
    
    
    self.webview.frameLoadDelegate=self;
    
    NSButton *zoomInOut=[[NSButton alloc] initWithFrame:NSMakeRect(0, 0,48, 48)];
   
    [zoomInOut.cell setBezelStyle:NSRegularSquareBezelStyle];
    [zoomInOut setImage:[NSImage imageNamed:@"scale"]];
    [zoomInOut.cell setImageScaling:NSImageScaleProportionallyDown];
    [zoomInOut setToolTip:NSLocalizedString(@"zoomin_out",nil)];
    
    
    [zoomInOut setTarget:self];
    [zoomInOut setAction:@selector(zoomInOut:)];
    
    
    
    
    [self.view addSubview:_webview];
    [self.view addSubview:zoomInOut];
    
    
    
    
        
    
}

-(void)zoomInOut:(id)sender{
    [self loadMapHTMLData:currentLocationChina];
    zoomState=[self.zoomInOutDelegate zoomInMapWindow:zoomState];
}

-(void)loadMapHTMLData:(BOOL)locationInChina{
     NSString *mapHtml=@"baidu_map.html";
     if(!locationInChina){
        mapHtml=@"google_map.html";
     }
     NSString *gpsPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mapHtml];
    
  
    
    NSString *htmlString = [NSString stringWithContentsOfFile:gpsPath encoding:NSUTF8StringEncoding error:nil];
    
    /*
     该种方式加载本地html数据可能会出现无法显示的奇怪问题
     
     [[self.webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gpsPath]]];
     */
    
    [[self.webview mainFrame]  loadHTMLString:htmlString baseURL:[NSURL URLWithString:gpsPath]];
    
    
    

}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    NSLog(@"didFinishLoadForFrame");
    JSContext *context=self.webview.mainFrame.javaScriptContext;
    
    __weak CVWebViewController *weakSelf = self;
    
    context[@"cocoa_getDistance"]=^(){
        NSArray *args=[JSContext currentArguments];
        JSValue *value=args[0];
        NSLog(@"当前距离是 : %f" ,value.toDouble);
        [weakSelf.distanceDelegate totalDistance:value.toDouble];
    };
   
    if(currentVideoGpsDataArr!=nil&&[currentVideoGpsDataArr count]>0){
        [_webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath(%@)",[currentVideoGpsDataArr JSONString]]];
    }
    
    
}

-(void)updateDataByCurrentTime:(Float64)time{
    float m_ratio=1.0;
    if(totalTime>0){
        m_ratio= [currentVideoGpsDataArr count]/totalTime;
    }
    
    int index=(int)time*m_ratio;
    
    if(currentVideoGpsDataArr!=nil&&[currentVideoGpsDataArr count]>0){
        if(index<[currentVideoGpsDataArr count]){
             NSArray *xyItem=currentVideoGpsDataArr[index];
            
             [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateMarkerPosition(%@)",[xyItem JSONString]]];
        }
    }
    
   
}




-(void)videoAllTime:(Float64)allTime{
    totalTime=allTime;
}


-(void)dataLogicProcessOfViodePath:(NSString *)playVideoPath{
     [self.distanceDelegate totalDistance:0];
    
     currentPlayVideoPath=playVideoPath;
    
    
     BOOL isINCHINA=[MyCache locationIsINChina:currentPlayVideoPath];
    
     if(currentLocationChina!=isINCHINA){
         [self loadMapHTMLData:isINCHINA];
         currentLocationChina=isINCHINA;
     }
    
    
     NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    
     currentVideoGpsDataArr=[NSMutableArray new];
     [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
         NSString *gps_lat=[obj objectForKey:@"gps_lat"];
         NSString *gps_lgt=[obj objectForKey:@"gps_lgt"];

         if(gps_lat.floatValue!=0&&gps_lgt.floatValue!=0){
             
             if(isINCHINA){
                 
                 [currentVideoGpsDataArr addObject:[BDTransUtil wgs2bdLat:gps_lat.floatValue lgt:gps_lgt.floatValue]];
                  
                 
                
             }else{
                 [currentVideoGpsDataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:gps_lat.floatValue],@"lat",[NSNumber numberWithFloat:gps_lgt.floatValue],@"lng",nil]];
                 
             }
             
            
         }
         
        
        
     }];
   // NSLog(@"*****%@****",[currentVideoGpsDataArr JSONString]);
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath(%@)",[currentVideoGpsDataArr JSONString]]];
}

@end
