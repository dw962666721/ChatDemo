//
//  LocationChooseViewGroup.h
//  TFQChooseViewDemo
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "ChooseViewGroup.h"

@interface LocationChooseViewGroup : ChooseViewGroup
@property NSString *selectedProName;
@property NSString *selectedCity;
@property NSString *selectedRegion;
-(void)setSelectedProName:(NSString *)province;
-(void)setSelectedCity:(NSString *)city;
-(void)setSelectedRegion:(NSString *)region;
@property (nonatomic,strong)NSString*province;
@property (nonatomic,strong)NSString*city;
@property (nonatomic,strong)NSString*region;
-(void)setProvince:(NSString *)province;
-(void)setCity:(NSString *)city;
-(void)setRegion:(NSString *)region;
@end
