//
//  TFQAlertUtil.h
//  CBNClient
//
//  Created by mac on 13-11-19.
//  Copyright (c) 2013年 TFQ. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TFQAlertUtil : NSObject
@property (nonatomic,strong)NSString*text;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,strong)UIColor *backgroundColor;
@property (nonatomic,assign)float timeDelay;
@property (nonatomic,assign)int lines;
-(void)showAlert;
-(void)showAlert:(NSString *)messgae;
+(instancetype)alert;

@end
