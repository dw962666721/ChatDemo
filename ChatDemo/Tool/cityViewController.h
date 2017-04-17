//
//  cityViewController.h
//  ZFB1
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cityViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIPickerView *p1;
- (NSMutableArray *)getAllProName; // 获取所有省份
//根据省获取市
- (NSMutableArray *)getCityByPro:(NSString *)pronames;
//根据省市获取区
- (NSMutableArray *)getDistanceByPro:(NSString *)pronames withCity:(NSString *)citynames;
@end
