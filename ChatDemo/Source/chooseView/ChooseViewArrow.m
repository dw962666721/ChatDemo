//
//  ChooseViewjaintouview.m
//  E_Education
//
//  Created by user on 15/4/10.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

#import "ChooseViewArrow.h"

@implementation ChooseViewArrow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(void)layoutSubviews{
//    self.button.frame=self.bounds;
//    [self.button viewWithTag:9610].frame=CGRectMake(self.frame.size.width - 9 - 10 , 10, 9, 7);
//    self.valueLabel.frame=CGRectMake(5, 0, self.frame.size.width - [self.button viewWithTag:9527].frame.size.width - 10, self.frame.size.height);
//}
-(void)subViewInit{
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 44)];
    label.userInteractionEnabled=false;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.titleLabel=label;
    label=[[UILabel alloc] initWithFrame:CGRectMake(95, 0,190, 44)];
    label.userInteractionEnabled=false;
    
    [self addSubview:label];
    self.valueLabel=label;
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(83, 0, [UIScreen mainScreen].bounds.size.width-83, 40);
    [button setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateHighlighted];
    button.imageEdgeInsets=UIEdgeInsetsMake(0, button.frame.size.width-50, 0, -35.0/2);
    [self addSubview:button];
    self.button=button;
    
    
}


@end
