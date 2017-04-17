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
@protocol ChartImageMessageDelegate<NSObject>
@optional
-(void)imageDidDownLoad;
-(void)browsePhoto:(UIImageView*)imageView Id:(NSString*)id;
@end
@interface ChartImageMessage : ChartMessage

//@property (nonatomic, copy) NSString *picture;//图片
@property (nonatomic, copy) NSString *sendTime;//发送时间
@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, weak) id<ChartImageMessageDelegate> delegate;//图片
@property (nonatomic,strong) NSURL *imageUrl;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
