//
//  ChartImageView.m
//  ChatMessageDemo
//
//  Created by admin on 15-1-8.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kContentStartMargin 25 // 距离会话框边缘的距离
#define kIconW 40

#import "ChartImageView.h"
#import "ChartImageMessage.h"
#import "UIImageView+WebCache.h"

@interface ChartImageView(){
    UIImage*_errorImage;
}
@property (nonatomic,readonly) ChartImageMessage* chartImageMessage;
@property (nonatomic,readonly) UIImage*errorImage;
@end
@implementation ChartImageView

-(ChartImageMessage *)chartImageMessage{
    return (ChartImageMessage*)self.chartMessage;
}

-(void)setChartMessage:(ChartMessage *)chartMessage{
    super.chartMessage=chartMessage;
    [self reload];
}
-(instancetype)init
{
    if (self = [super init])
    {        
        // 默认加载图片
        self.activityBgView = [[UIView alloc]init];
        self.activityBgView.backgroundColor = [UIColor blackColor];
        self.activityBgView.alpha = 0.5;
        [self addSubview:self.activityBgView];
        
        
        self.activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.hidesWhenStopped = NO;//当程序停止执行时风火轮隐藏
        
        [self.activityView startAnimating];
        [self addSubview:self.activityView];

        self.imgView=[[UIImageView alloc]init];
        self.imgView.userInteractionEnabled=YES;
        self.imgView.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:self.imgView];
        
        // 4. 添加单击手势监听
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture)];
        [singleTap setNumberOfTapsRequired:1];
        [self.imgView addGestureRecognizer:singleTap];

    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat imageViewX;
    CGFloat backImgViewX;
    CGRect failRect = frame;
    CGRect stateRect = frame;
    
    if(self.chartMessage.messageType==kMessageFrom){
        imageViewX=10;
        backImgViewX=0;
    }
    // 发送
    else if(self.chartMessage.messageType==kMessageTo)
    {
        imageViewX=-8;
        backImgViewX=-10;
        
        stateRect.size.width = 20;
        stateRect.size.height = 20;
        stateRect.origin.x = - 30;
        stateRect.origin.y = frame.size.height / 2 + 10;
        
        failRect.size.width = 80;
        failRect.size.height = 20;
        failRect.origin.x = -100;
        failRect.origin.y = frame.size.height / 2 + 10;
        if (failRect.origin.x < 0) {
            //            failRect.size.width = screenWidth-frame.origin.x;
//            self.stateBtn.backgroundColor = [UIColor lightGrayColor];
            self.stateBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.stateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            self.stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            self.stateBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
        self.stateActivity.frame = stateRect;
        self.stateBtn.frame = failRect;
    }
    self.backImageView.frame=CGRectMake(backImgViewX, 20, self.bounds.size.width+10, self.bounds.size.height);
    CGFloat imageViewH=self.backImageView.frame.size.height-5;
    CGFloat imageViewW=self.backImageView.frame.size.width-13;
    self.activityBgView.frame=CGRectMake(imageViewX, 22, imageViewW,imageViewH);
    self.activityView.center = self.activityBgView.center;//设置中心点坐标
    self.imgView.frame = CGRectMake(imageViewX, 22, imageViewW,imageViewH);
}
-(void)reload{
   
    self.imgView.image=self.chartImageMessage.image;
    [self.activityBgView setHidden:YES];
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    switch (self.chartMessage.stata.intValue) {
        case 0:
        case 1:
            self.stateBtn.hidden = YES;
            self.stateActivity.hidden = NO;
            [self.stateActivity startAnimating];
            break;
        case 3:
            self.stateBtn.hidden = NO;
            self.stateActivity.hidden = YES;
            [self.stateActivity stopAnimating];
            break;
        default:
            self.stateBtn.hidden = YES;
            self.stateActivity.hidden = YES;
            [self.stateActivity stopAnimating];
            break;
    }
    if (self.chartMessage.messageType == kMessageFrom)
    {
        self.stateBtn.hidden = YES;
        self.stateActivity.hidden = YES;
        [self.stateActivity stopAnimating];
    }

}
-(UIImageView *)getIMG
{
    return self.imgView;
}
-(void)setIMG:(UIImage*) image
{
    self.imgView.image = image;
}


// 图片浏览代理调用
-(void)singleTapGesture
{
//    [self.chartImageMessage.delegate browsePhoto:self.imgView id:self.chartImageMessage.id.description];
//    [self.chartImageMessage.delegate browsePhoto:self.imgView Id:self.chartImageMessage.id.description];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartContentBrowsePhotos:id:)])
    {
        [self.delegate chartContentBrowsePhotos:self.imgView id:self.chartImageMessage.id.description];
    }
}

@end
