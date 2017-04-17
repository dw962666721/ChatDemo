//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
//#import "ChartVoiceView.h"
#import "UIImageView+WebCache.h"
//#import "ChartDemo-Swift.h"
@interface ChartCell()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *myAvatarImgView;
@property (nonatomic,strong) UIImageView *defaultAvatarImgView;
@property (nonatomic,strong) UIView *bigView;

//@property (nonatomic,strong) ChartContentView *chartView;UIActivityIndicatorView
@end

@implementation ChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.frame = CGRectMake(45, 0, screenWidth-90, 20);
        [self.contentView addSubview:self.nameLabel];
        
        self.bigView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, screenWidth, screenHeight)];
        self.bigView.backgroundColor = [UIColor clearColor];
//        self.bigView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        [self.contentView addSubview:self.bigView];
        
        self.defaultAvatarImgView=[[UIImageView alloc]init];
        self.defaultAvatarImgView.layer.masksToBounds = YES;
        self.defaultAvatarImgView.layer.cornerRadius = 5;
        self.defaultAvatarImgView.image=[UIImage imageNamed:@"logo"];
        [self.contentView addSubview:self.defaultAvatarImgView];
        
        self.myAvatarImgView=[[UIImageView alloc]init];
//        self.myAvatarImgView.layer.cornerRadius = 20;
        self.myAvatarImgView.layer.cornerRadius = 5;
        self.myAvatarImgView.clipsToBounds = YES;
        [self.contentView addSubview:self.myAvatarImgView];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
        
        // 4. 添加单击手势监听
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture)];
        [singleTap setNumberOfTapsRequired:1];
        [self.bigView addGestureRecognizer:singleTap];
        
        [self.contentView bringSubviewToFront:self.bigView];
        }
    return self;
}

-(void)singleTapGesture
{
    if(self.chartView.delegate&&[self.chartView.delegate respondsToSelector:@selector(chartContentReSend:)])
    {
        [self.chartView.delegate chartContentReSend:self.chartView.chartMessage.message];
    }
    
}

// 首先执行
-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
    _cellFrame=cellFrame;
    
    // [ChartVoiceMessage picture] 报错 没有移除
    [self.chartView removeFromSuperview];
    self.chartView =[cellFrame.chartMessage chartContentView];
    
    [self.contentView addSubview:self.chartView];
    
    self.chartView.chartMessage=cellFrame.chartMessage;
    
    self.chartView.backgroundColor = [UIColor clearColor];  
    

    self.defaultAvatarImgView.frame=cellFrame.iconRect;
    self.myAvatarImgView.frame=cellFrame.iconRect;
    self.timeLabel.frame = CGRectMake(45, CGRectGetMaxY(cellFrame.chartViewRect) + (cellFrame.chartMessage.messageStyle == 0 ? 10 : 20), screenWidth-90, 20);
    self.timeLabel.text = self.chartView.chartMessage.sendTime;
    self.nameLabel.text = self.chartView.chartMessage.name;
    [self.myAvatarImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cellFrame.chartMessage.icon]]];
    [self setBackGroundImageViewImage:self.chartView from:@"对话框蓝色.png" to:@"对话框白色.png"];
    CGRect rect =cellFrame.chartViewRect;
    rect.origin.x = (rect.origin.x+50)/2;
    rect.size.height += 40;
    // 聊天视图
    self.chartView.frame=cellFrame.chartViewRect;
    [self.chartView reload];
    
    CGFloat h = cellFrame.cellHeight;
    CGRect bigViewRect =  self.bigView.frame;
    bigViewRect.size.height = h;
    self.bigView.frame = bigViewRect;
}
-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to
{
    UIImage *normal=nil ;
    if (chartView.chartMessage.messageType== kMessageFrom)
    {
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    else if(chartView.chartMessage.messageType== kMessageTo)
    {
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    chartView.backImageView.image=normal;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
