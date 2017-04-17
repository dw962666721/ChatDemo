//
//  LocationChooseViewGroup.m
//  TFQChooseViewDemo
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "LocationChooseViewGroup.h"
//#import "ChatDemo-Swift.h"
static NSArray* __locations;

@interface LocationChooseViewGroup()<ChooseViewGroupDatasource,ChooseViewGroupDelegate>{
 NSString *_selectedProName;
 NSString *_selectedCity;
 NSString *_selectedRegion;
}
@property (nonatomic,readonly)NSArray*locations;
@end
@implementation LocationChooseViewGroup
-(NSArray *)locations{
    if (!__locations) {
        NSData *fileData = [[NSData alloc]init];
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSString *_jsonContent=[[NSString alloc] initWithContentsOfFile:path encoding:enc error:nil];
        fileData =[_jsonContent dataUsingEncoding:NSUTF8StringEncoding];
        __locations=[NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    }
    return  __locations;
}
-(NSString *)selectedProName{
    return self.value[@"proname"];
}
-(NSString *)selectedCity{
    return self.value[@"cityname"];
}
-(NSString *)selectedRegion{
    return self.value[@"distancedata"];
}
-(void)setSelectedProName:(NSString *)province
{
    ChooseView*chooseView=(id)[self viewWithTag:tagWithIndex(0)];
    chooseView.value=province;
    _selectedProName = province;
}
-(void)setSelectedCity:(NSString *)city
{
    ChooseView*chooseView=(id)[self viewWithTag:tagWithIndex(1)];
    chooseView.value=city;
    _selectedCity = city;
}
-(void)setSelectedRegion:(NSString *)region
{
    ChooseView*chooseView=(id)[self viewWithTag:tagWithIndex(2)];
    chooseView.value=region;
    _selectedRegion = region;
}
-(NSString *)province{
    return self.value[@"proname"];
}
-(void)setProvince:(NSString *)province{
    ChooseView*chooseView=(id)[self viewWithTag:tagWithIndex(0)];
    chooseView.value=province;
}
-(NSString *)city{
    return self.value[@"cityname"];
}
-(void)setCity:(NSString *)city{
    ChooseView*chooseView=(id)[self viewWithTag:tagWithIndex(1)];
    chooseView.value=city;
}
-(NSString *)region{
    return self.value[@"distancedata"];
}
-(void)setRegion:(NSString *)region{
    ChooseView*chooseView=(id)[self viewWithTag:tagWithIndex(2)];
    chooseView.value=region;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate=self;
        self.datasource=self;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.datasource=self;
    }
    return self;
}
#define nil2NSNull(obj) obj?obj:[NSNull null]

-(void)chooseView:(ChooseView*)chooseView InitAtIndex:(NSInteger)index{
    
    NSString *locationState = @"请选择";
//    NSString *proName = @"省份";
    if (index == 0) {
        locationState = @"省份";
        if (_selectedProName!=nil) {
            locationState = _selectedProName;
            _selectedProName = nil;
        }
    }
    else if (index == 1)
    {
        locationState = @"城市";
        if (_selectedCity!=nil) {
            locationState = _selectedCity;
            _selectedCity = nil;
        }
    }
    else
    {
        locationState = @"区域";
        if (_selectedRegion!=nil) {
            locationState = _selectedRegion;
            _selectedRegion = nil;
        }
    }
    
    if ( ![[NSNull null] isEqual:locationState])
    {
        chooseView.value=locationState;
        
    }
}

-(NSDictionary *)value{
    NSMutableDictionary*temp=[[NSMutableDictionary alloc] init];
    NSArray*fields=@[@"proname",
                     @"cityname",
                     @"distancedata"];
    for (int i=0; i<3; i++) {
        
        NSString* value=[self valueOfChooseViewIndex:i];
        if ([value isEqualToString:@"请选择"]||value==nil) {
            break;
        }
        [temp setObject:value forKey:[fields objectAtIndex:i]];
    }
    return [NSDictionary dictionaryWithDictionary:temp];
}
-(NSInteger)numberOfChooseViewInGroup:(ChooseViewGroup *)chooseViewGroup{
    return 3;
    
}

-(NSString *)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup valueOfIndex:(NSInteger)index atChooseViewOfIndex:(NSInteger)chooseViewIndex
{
    NSArray*array=[self chooseViewGroup:chooseViewGroup subDataWithIndex:chooseViewIndex];
    if (array.count>0){
        id value=[array objectAtIndex:index];
        if ([value isKindOfClass:[NSString class]]) {
            return  value;
        }else if ([value isKindOfClass:[NSDictionary class]]){
            switch (chooseViewIndex) {
                case 0:
                    return value[@"proname"];
                    break;
                case 1:
                    return value[@"cityname"];
                    break;
                default:
                    return value[@"distancedata"];
                    break;
            }
            
        }
    }
    return nil;
}
-(NSInteger)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup numberOfChooseViewAtIndex:(NSInteger)index
{
    return [self chooseViewGroup:chooseViewGroup subDataWithIndex:index].count;
}

-(NSArray*)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup subDataWithIndex:(NSInteger)index{
    NSArray* temp=@[];
    if (index) {
        if (index==1) {
            
            NSString *proName = self.province;
            if (proName) {
                temp = [self getCityByPro:proName];
            }
            
        }
        else
        {
            NSString *proName = self.province;
            NSString *cityName = self.city;
            if (proName&&cityName) {
                temp = [self getDistanceByPro:proName withCity:cityName];
            }
            
        }
    }
    else
    {
        temp=self.locations;
    }
    return temp;
}
//根据省获取市
- (NSMutableArray *)getCityByPro:(NSString *)pronames
{
    NSMutableArray *pdd = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.locations.count; i++) {
        NSString *proname = self.locations[i][@"proname"];
        if ([pronames isEqual:proname]) {
            NSArray *citydata = self.locations[i][@"citydata"];
            for (NSInteger j = 0; j < citydata.count; j++) {
                NSString *cityname = citydata[j][@"cityname"];
                [pdd addObject:cityname];
            }
            break;
        }
        
    }
    return pdd;
}
//根据省市获取区
- (NSMutableArray *)getDistanceByPro:(NSString *)pronames withCity:(NSString *)citynames
{
    NSMutableArray *pdd = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.locations.count; i++) {
        NSString *proname = self.locations[i][@"proname"];
        if ([pronames isEqual:proname]) {
            NSArray *citydata = self.locations[i][@"citydata"];
            for (NSInteger j = 0; j < citydata.count; j++) {
                NSString *cityname = citydata[j][@"cityname"];
                if ([cityname isEqual:citynames]) {
                    NSArray *distancedata = citydata[j][@"distancedata"];
                    for (NSInteger h = 0; h < distancedata.count; h++) {
                        NSString *disname = distancedata[h];
                        [pdd addObject:disname];
                    }
                    break;
                }
            }
            break;
        }
        
    }
    return pdd;
}

@end
