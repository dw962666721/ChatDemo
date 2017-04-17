//
//  ChooseViewStylePulldown.m
//  E_Education
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "ChooseViewStylePulldown.h"

@implementation ChooseViewStylePulldown

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor=borderColor;
    self.layer.borderColor = borderColor.CGColor;
    
}

-(void)layoutSubviews{
    self.button.frame=self.bounds;
    [self.button viewWithTag:9527].frame=CGRectMake(self.frame.size.width - 9 - 10 , 10, 9, 7);
    self.valueLabel.frame=CGRectMake(5, 0, self.frame.size.width - [self.button viewWithTag:9527].frame.size.width - 10, self.frame.size.height);

}
-(void)subViewInit{
    
    
    UIImageView*pImageView =[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 9 - 10 , 10, 9, 7)] ;
    pImageView.tag=9527;
    pImageView.image =[UIImage imageNamed:@"向下箭头"];
    
    UIButton* button  = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.tag=9999;
    button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    button.titleEdgeInsets = UIEdgeInsetsMake(6, self.frame.size.width / 2 , 5, 20);
    
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 0;
    self.clipsToBounds=true;
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentRight;
    button.titleLabel.font =[UIFont systemFontOfSize:13];
    [button addSubview:pImageView];
    [self addSubview:button];
    self.button=button;
    UILabel *selectedTitleLabel=[[UILabel alloc ] initWithFrame:CGRectMake(5, 0, self.frame.size.width - pImageView.frame.size.width - 10, self.frame.size.height)];
    selectedTitleLabel.font = [UIFont systemFontOfSize:13];
    selectedTitleLabel.textAlignment = NSTextAlignmentCenter;
    selectedTitleLabel.textColor = [UIColor blackColor];
    self.valueLabel = selectedTitleLabel;
    [self addSubview:selectedTitleLabel];
}
@end
