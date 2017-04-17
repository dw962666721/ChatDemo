//
//  ChartContentView.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#define kContentStartMargin 25 // 距离会话框边缘的距离
#define TimeLabelW 100
#define TimeLabelH 15
#define kIconMarginX 5
#define kIconMarginY 5
#define kIconW 40

#import "ChartContentView.h"
#import "ChartMessage.h"
#import "ChatDemo-Swift.h"
@implementation ChartContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor=[UIColor redColor];
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        [self sendSubviewToBack:self.backImageView];
        
        self.stateBtn = [[UIButton alloc] init];
        self.stateBtn.hidden = YES;
        self.stateBtn.userInteractionEnabled=YES;
//        self.stateBtn.backgroundColor = [UIColor lightGrayColor];
        [self.stateBtn setTitle:@"发送失败" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.stateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.stateBtn addTarget:self action:@selector(stateBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.stateBtn];
        
        self.stateActivity = [[UIActivityIndicatorView alloc] init];
        self.stateActivity.hidden = YES;
        [self.stateActivity startAnimating];
        self.stateActivity.color = [UIColor whiteColor];
        [self addSubview:self.stateActivity];

        // 4. 添加单击手势监听
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stateBtnAction)];
        [singleTap setNumberOfTapsRequired:1];
        [self.backImageView addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)stateBtnAction
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(chartContentReSend:)])
    {
        [self.delegate chartContentReSend:self.chartMessage.message];
    }
}

-(void)reload
{

}
@end
