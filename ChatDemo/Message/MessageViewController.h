//
//  MessageTableViewController.h
//  ChatDemo
//
//  Created by zw on 15/6/29.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMChatManagerChatDelegate.h"
#import "IChatManagerDelegate.h"
#import "ChatListCell.h"
@interface MessageViewController : UIViewController<EMChatManagerChatDelegate,IChatManagerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
- (void)refreshDataSource;
- (void)registerNotifications;
@end
