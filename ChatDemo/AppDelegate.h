//
//  AppDelegate.h
//  ChatDemo
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFQAlertUtil.h"
#import "BMKMapManager.h"
#import "UncaughtExceptionHandler.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BMKMapManager *mapManager;
-(void)setAutoLogin;
@end

