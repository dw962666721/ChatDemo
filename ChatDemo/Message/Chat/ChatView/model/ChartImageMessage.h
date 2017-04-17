//
//  ChartImageMessage.h
//  ChatMessageDemo
//
//  Created by admin on 15-1-8.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

#import "ChartMessage.h"
#import "SDWebImageManager.h"
#import <UIKit/UIKit.h>
@protocol ChartImageMessageDelegate <NSObject>
@optional
-(void)imageDidDownLoad;
@required
//- (void)browsePhoto:(UIImageView *)imageView Id:(NSString *)messageId;
-(void)chartContentBrowsePhotos:(UIImageView *) imageView id:(NSString *)messageId;
@end
@interface ChartImageMessage : ChartMessage

@property (nonatomic, copy) NSString *localImage;//本地图片
@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, weak) id<ChartImageMessageDelegate> delegate;//图片
@property (nonatomic,strong) NSURL *imageUrl;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
