//
//  BaseTabBarController.m
//  ChatDemo
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "BaseTabBarController.h"
#import "EMCDDeviceManager.h"
static const CGFloat kDefaultPlaySoundInterval = 3.0;
@interface BaseTabBarController ()< IChatManagerDelegate, EMCallManagerDelegate>
@property bool tabBarIsShow;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end
@implementation BaseTabBarController

-(void)viewDidLoad
{
    [self registerNotifications];
    _tabBarIsShow = true;
    for (int i = 0; i<self.viewControllers.count; i++) {
        ((UINavigationController *)self.viewControllers[i]).delegate = self;
        ((UINavigationController *)self.viewControllers[i]).navigationBar.titleTextAttributes =  [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
        [((UINavigationController *)self.viewControllers[i]).navigationBar setBarTintColor:[UIColor blackColor]];
        ((UINavigationController *)self.viewControllers[i]).navigationBar.tintColor = [UIColor whiteColor];
//        [((UINavigationController *)self.viewControllers[i]).navigationItem];
        //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    }

}
-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    [self setupUnreadMessageCount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadChatList) name:@"loadChatList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"logOut" object:nil];
}
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}
-(void)logOut
{
    ((UINavigationController *)self.viewControllers[1]).tabBarItem.badgeValue = nil;
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
}
-(void)loadChatList
{
    MessageViewController * vc = ((UINavigationController *)(self.viewControllers[1])).viewControllers[0];
    [vc refreshDataSource];
    [vc registerNotifications];
    
}
-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        if (![PropertyController InBalckList:conversation.chatter]) {
           unreadCount += conversation.unreadMessagesCount;
        }
    }
    if ((UINavigationController *)self.viewControllers[1]) {
        if (unreadCount > 0) {
            ((UINavigationController *)self.viewControllers[1]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            ((UINavigationController *)self.viewControllers[1]).tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}
// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}
- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
   
    return ret;
}
// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
//#if !TARGET_IPHONE_SIMULATOR
        if ([PropertyController InBalckList:message.conversationChatter]) {
            return;
        }
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
//            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
//#endif
    }
}
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.topViewController == viewController) {
        if (navigationController.viewControllers.count>1) {
            UIViewController *lastViewController = navigationController.viewControllers[navigationController.viewControllers.count-2];
            viewController.hidesBottomBarWhenPushed = lastViewController.hidesBottomBarWhenPushed || viewController.hidesBottomBarWhenPushed;
        }
        if (viewController.hidesBottomBarWhenPushed) {
            [self hideTabBar];
        }
        else
        {
            [self showTabBar];
        }
    }
}

-(void)hideTabBar{
    if (_tabBarIsShow) {
        self.tabBar.backgroundColor = [UIColor clearColor];
        _tabBarIsShow=false;
    }
}
-(void)showTabBar{
    if (!_tabBarIsShow){
       self.tabBar.backgroundColor = [UIColor whiteColor];
        _tabBarIsShow=true;
    }
}


@end
