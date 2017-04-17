//
//  ChartContentView.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChartContentView,ChartMessage;
@protocol ChartContentDelegate <NSObject>
-(void)chartContentBrowsePhotos:(UIImageView *) imageView id:(NSString *)messageId;
-(void)chartContentReSend:(EMMessage *) message;
@end

@interface ChartContentView : UIView
//@property (nonatomic,weak) id<ChartContentDelegate> delegate;
@property (nonatomic, weak) id<ChartContentDelegate> delegate;//图片
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) ChartMessage *chartMessage;
@property (nonatomic,strong) UIButton *stateBtn; // 发送状态 按钮
@property (nonatomic,strong) UIActivityIndicatorView *stateActivity; // 发送中
-(void)reload;
-(void)stateBtnAction;
@end
