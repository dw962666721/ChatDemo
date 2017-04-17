//
//  ViewController.m
//  ChatDemo
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "MainViewController.h"
@interface MainViewController ()
@property NSMutableArray *bannerArray;
@property UIView *heardView;
@property ImageScrollView *imageScrollView;
@property UITableView *tableView;
@end

@implementation MainViewController
-(void)enterGuidanceView
{
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    // 获取当前软件的版本号
    NSString *currentVersion = [info objectForKey:@"CFBundleVersion"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *saveVersion = [defaults objectForKey:@"CFBundleVersion"];
    if ([currentVersion isEqualToString:saveVersion] && saveVersion != nil)
    {
        // 进入主页
    }
    else
    {
        GuidanceViewController *guidanceVC = [[GuidanceViewController alloc] init];
        [self presentViewController:guidanceVC animated:false completion:nil];
    }
}
- (void)viewDidLoad {
    // 引导页处理
    [self enterGuidanceView];
    [super viewDidLoad];
    [self loadImageScrollView];
    
    [self loadTableView];
}
-(void)loadTableView
{
    _heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 315)];
    UIView *layoutView = [[NSBundle mainBundle] loadNibNamed:@"LayoutView" owner:self options:nil][0];
    layoutView.frame = CGRectMake(0, 180, screenWidth, 135);
    [_heardView addSubview:_imageScrollView];
    [_heardView addSubview:layoutView];
    
    // 偶遇
    UIButton *studentBtn = (UIButton *)[layoutView viewWithTag:110];
    studentBtn.exclusiveTouch=true;
    [studentBtn addTarget:self action:@selector(encounterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 教师
    UIButton *teacherBtn = (UIButton *)[layoutView viewWithTag:111];
    [teacherBtn addTarget:self action:@selector(teacherBtnClick) forControlEvents:UIControlEventTouchUpInside];
    teacherBtn.exclusiveTouch=true;
    
    // 闲趣
    UIButton *forumBtn = (UIButton *)[layoutView viewWithTag:112];
   [forumBtn addTarget:self action:@selector(forumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    forumBtn.exclusiveTouch=true;
    
    // 院校
    UIButton *organizationBtn = (UIButton *)[layoutView viewWithTag:113];
    [organizationBtn addTarget:self action:@selector(organizationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    organizationBtn.exclusiveTouch=true;
    // marqueeView
    UIView *marqueeView = [layoutView viewWithTag:114];
    marqueeView.layer.borderColor = [UIColor grayColor].CGColor;
    marqueeView.layer.borderWidth = 0.3;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _heardView;
    [self.view addSubview:_tableView];
}
-(void)encounterBtnClick
{
    
}
-(void)teacherBtnClick
{
    
}
-(void)forumBtnClick
{
    
}
-(void)organizationBtnClick
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MainViewController"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainViewController"];
}
-(void)loadImageScrollView
{
    _bannerArray = [[NSMutableArray alloc] init] ;
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 180);
    _imageScrollView = [[ImageScrollView alloc] initWithFrame:rect];
    _imageScrollView.imageScrollViewDelegate = self;
    _imageScrollView.imageScrollViewDatasource = self;
    NSString *urlPath = [ServerUrl stringByAppendingString:@"getListSystem.jspx"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"type" : @"1",@"size" : @100,@"pageSize" : @5};
    
    [manager GET:urlPath parameters:params success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSData *data = operation.responseData;
         
         NSDictionary *json = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         //         [[String:AnyObject]]
         for (NSObject *obj in json) {
             //             _bannerArray.append(ServerURL + ( obj["url"] as String))
             [_bannerArray addObject:[ServerUrl stringByAppendingString:(NSString *)[obj valueForKey:@"url"]]];
         }
         [_imageScrollView reloadImages];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"下载错误 is %@",error);
         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//func imageScrollView(imageScrollView:ImageScrollView,didSelectedAtIndex index:Int).
//func numberOfImageScrollView(imageScrollView:ImageScrollView)->Int
//func imageScrollView(imageScrollView:ImageScrollView,imageUrlAtIndex index:Int)->String
-(void)imageScrollView:(ImageScrollView *)imageScrollView didSelectedAtIndex:(NSInteger)index
{
    
}
-(NSString *)imageScrollView:(ImageScrollView *)imageScrollView imageUrlAtIndex:(NSInteger)index
{
    return _bannerArray[index];
}
-(NSInteger)numberOfImageScrollView:(ImageScrollView *)imageScrollView
{
    return _bannerArray.count;
}
@end
