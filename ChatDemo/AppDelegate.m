//
//  AppDelegate.m
//  ChatDemo
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatDemo-Swift.h"
#import "EaseMob.h"
#import "UncaughtExceptionHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [MobClick setAppVersion:currentVersion];
    [MobClick startWithAppkey:@"55810ea067e58e407d000b64" reportPolicy:BATCH channelId:nil];
    _mapManager = [[BMKMapManager alloc]init];
    // 注册百度地图
    _Bool ret = [self.mapManager start:@"LbiRumUuOsFb8ZSfkqd0G7CC" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
//    SKPaymentQueue.defaultQueue().addTransactionObserver(payment())
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:(id<SKPaymentTransactionObserver>)];
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"dw962666721#chatdemo" apnsCertName:@"dw962666721"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 允许推送权限
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    
    // 全局变量赋值
    [PropertyController setmessageBox:[[TFQAlertUtil alloc] init]];// 提示弹出框
    [PropertyController setBufferView:[[BufferView alloc] init]];// 缓冲页面
    
    // 监听错误
    InstallUncaughtExceptionHandler();
    return YES;
}
-(void)onGetPermissionState:(int)iError
{
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (sourceApplication.length>=10 && [[sourceApplication substringToIndex:10]  isEqual: @"com.alipay"]) {
        [[AlipaySDK defaultService] processOderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[ProductInfo shareInstance] complantOrder:resultDic];
        }];
    }
    return YES;
}
-(void)setAutoLogin
{
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:true];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}
// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
   [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application {
  [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
