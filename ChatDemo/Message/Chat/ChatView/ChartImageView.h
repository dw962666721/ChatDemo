//
//  ChartImageView.h
//  ChatMessageDemo
//
//  Created by admin on 15-1-8.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

#import "ChartContentView.h"



@interface ChartImageView : ChartContentView
-(UIImageView *)getIMG;
-(void)setIMG:(UIImage*) image;
@property(nonatomic,strong) UIImageView *placeholderImgView;
@property(nonatomic,strong) UIView *activityBgView;
@property(nonatomic,strong) UIActivityIndicatorView *activityView;

@property(nonatomic,strong) UIImageView *imgView;
@end
