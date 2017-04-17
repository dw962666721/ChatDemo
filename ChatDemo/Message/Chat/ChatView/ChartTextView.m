//
//  ChartTextView.m
//  E_Education
//
//  Created by admin on 15-1-6.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

#define kContentStartMargin 25 // 距离会话框边缘的距离
#define TimeLabelW 100
#define TimeLabelH 15
#define kIconMarginX 5
#define kIconMarginY 5
#define kIconW 40


#import "ChartTextView.h"
#import "ChartTextMessage.h"
@interface ChartTextView()
@property (nonatomic,readonly) ChartTextMessage* chartTextMessage;
@end
@implementation ChartTextView
// get 方法
-(ChartTextMessage *)chartTextMessage{
    return (ChartTextMessage*)self.chartMessage;
}
- (id)init
{
    self = [super init];
    if (self) {
        // 姓名
//        self.nameLabel=[[UILabel alloc]init];
//        self.nameLabel.numberOfLines=1;
////        self.nameLabel.textAlignment=NSTextAlignmentLeft;
//        self.nameLabel.font=[UIFont systemFontOfSize:12];
//        [self addSubview:self.nameLabel];
    [self.stateBtn addTarget:self action:@selector(stateBtnAction) forControlEvents:UIControlEventTouchUpInside];
        // 内容
        self.contentLabel=[[UILabel alloc]init];
        self.contentLabel.numberOfLines=0;
        self.contentLabel.textAlignment=NSTextAlignmentLeft;
        self.contentLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:self.contentLabel];
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.height<40)
    {
        frame.size.width -= 20;
    }
    else
    {
        frame.size.width -= 20;
    }
    CGRect contentLabelRect = frame;
    CGRect backImageRect = frame;
    CGRect failRect = frame;
    CGRect stateRect = frame;
    // 接收
    if(self.chartMessage.messageType==kMessageFrom){
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabelRect.origin.x = contentLabelRect.origin.x+13;
    }
    // 发送
    else if(self.chartMessage.messageType==kMessageTo){
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabelRect.origin.x = contentLabelRect.origin.x+5;
         backImageRect.origin.x = backImageRect.origin.x - 0;
        stateRect.size.width = 20;
        stateRect.size.height = 20;
        stateRect.origin.x = failRect.origin.x - 20;
        stateRect.origin.y = failRect.size.height / 2;
        
        failRect.size.width = 80;
        failRect.origin.x = failRect.origin.x - 70;
        if (failRect.origin.x < 0) {
            failRect.origin.x = failRect.origin.x-15 ;
//            failRect.size.width = screenWidth-frame.origin.x;
//            self.stateBtn.backgroundColor = [UIColor lightGrayColor];
            self.stateBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.stateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            self.stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            self.stateBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
        self.stateActivity.frame = stateRect;
        
    }   
    backImageRect.size.width += 20;
    self.contentLabel.frame=contentLabelRect;
    self.backImageView.frame=backImageRect;
    
    
    self.stateBtn.frame = failRect;
}

-(void)reload{
//    self.nameLabel.text=self.chartTextMessage.name;
       self.contentLabel.text=self.chartTextMessage.content;
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

@end
