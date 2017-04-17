//
//  cityViewController.m
//  ZFB1
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import "cityViewController.h"

@interface cityViewController ()
@property NSMutableArray *pd ;
@end

@implementation cityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pd = [self getCityData];
//   NSString *proname = self.pd[0][@"proname"];
//    NSLog(@"%@",proname);
//    NSMutableArray *cityarray = [self getCityByPro:proname];
//    NSString *cityname = cityarray[0];
//    NSMutableArray *disarry = [self getDistanceByPro:proname withCity:cityname];
//    NSLog(@"%@",cityarray);
//    NSLog(@"%@",disarry);
    
//    self.p1.dataSource = self;
//    self.p1.delegate = self;
    
}
// 获取所有省份
- (NSMutableArray *)getAllProName
{
    NSMutableArray *pdd = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.pd.count; i++) {
        NSString *proname = self.pd[i][@"proname"];
        [pdd addObject:proname];
    }
    return pdd;
}
//根据省获取市
- (NSMutableArray *)getCityByPro:(NSString *)pronames
{
    NSMutableArray *pdd = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.pd.count; i++) {
       NSString *proname = self.pd[i][@"proname"];
        if (proname == pronames) {
             NSArray *citydata = self.pd[i][@"citydata"];
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
    for (NSInteger i = 0; i < self.pd.count; i++) {
        NSString *proname = self.pd[i][@"proname"];
        if (proname == pronames) {
            NSArray *citydata = self.pd[i][@"citydata"];
            for (NSInteger j = 0; j < citydata.count; j++) {
                NSString *cityname = citydata[j][@"cityname"];
                if (cityname == citynames) {
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


- (NSMutableArray *)getCityData
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    //    if ([UD objectForKey:@"city"] == nil) {
    NSString *path;
    path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSString *_jsonContent=[[NSString alloc] initWithContentsOfFile:path encoding:enc error:nil];
    fileData =[_jsonContent dataUsingEncoding:NSUTF8StringEncoding];
    
    // fileData = [NSData dataWithContentsOfFile:path];
    
    //        [UD setObject:fileData forKey:@"city"];
    //        [UD synchronize];
    //    }
    //    else {
    //        fileData = [UD objectForKey:@"city"];
    //    }
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    
    for (NSDictionary *dict in jsonArray) {
       
        [array addObject:dict];
    }
    
    return array;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
