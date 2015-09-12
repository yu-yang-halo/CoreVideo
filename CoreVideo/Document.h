//
//  Document.h
//  CoreVideo
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Cocoa/Cocoa.h>
extern const NSString *key_url_path;
extern const NSString *NOTIFICATION_URL_PATH;
@protocol DocumentDelegate <NSObject>

-(void)getOpenDocumentPath:(NSURL *)url;

@end

@interface Document : NSDocument
@property(nonatomic,weak) id<DocumentDelegate> delegateDocPath;
@end

