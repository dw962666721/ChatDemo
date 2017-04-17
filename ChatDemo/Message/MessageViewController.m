//
//  MessageTableViewController.m
//  ChatDemo
//
//  Created by zw on 15/6/29.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "MessageViewController.h"
#import "EaseMob.h"
#import "AppDelegate.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "NSDate+Category.h"
#import "ChatDemo-Swift.h"
@interface MessageViewController()
{
    
}

@end

@implementation MessageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
//     self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
    [self toLoginAndRegistView];
}

-(void)viewDidLoad
{
    [UserInfoForObjc refresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toLoginAndRegistView) name:@"toLoginAndRegistView1" object:nil];
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-92)];
    _tableView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *viewFoot = [[UIView alloc] init];
    viewFoot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = viewFoot;
    [self.tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
    [self.view addSubview:self.tableView];
}
//func toLoginAndRegistView()
//{
//    if !UserInfo.isLogin
//    {
//        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.navigationController?.popToRootViewControllerAnimated(false)
//            })
//        })
//    }
//}
-(void)toLoginAndRegistView
{
    if (![UserInfoForObjc isLogin]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                LoginAndRegistViewController *guidanceVC = [[LoginAndRegistViewController alloc] init];
                guidanceVC.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:guidanceVC animated:YES];
            });
        });
    }
}
-(void)refreshDataSource
{
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
}
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSMutableArray *conversations = [NSMutableArray arrayWithArray:[[EaseMob sharedInstance].chatManager conversations]];
    for(int i = 0;i<conversations.count;i++){
        EMConversation *first = conversations[i];
        if (![PropertyController InBalckList:first.chatter]) {
            continue;
        }
        BOOL hasCell = NO;
        for(int j = 0;j<self.dataSource.count;j++){
            EMConversation *second = self.dataSource[j];
            if ([first.chatter compare:second.chatter options:NSCaseInsensitiveSearch]==NSOrderedSame) {
                hasCell = YES;
            }
        }
        if (!hasCell) {
            [conversations removeObjectAtIndex:i];
        }
    }
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    NSString *title = conversation.chatter;
    if (conversation.conversationType != eConversationTypeChat) {
        if ([[conversation.ext objectForKey:@"groupSubject"] length])
        {
            title = [conversation.ext objectForKey:@"groupSubject"];
        }
        else
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    title = group.groupSubject;
                    break;
                }
            }
        }
    }
    
    ChatListCell *cell = (ChatListCell *)[tableView cellForRowAtIndexPath:indexPath];
    PrivateLetterViewController *vc = [[PrivateLetterViewController alloc] init];
    vc.userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:conversation.chatter, @"userNumber",cell.name,@"name", @"18", @"age",[cell.imageURL absoluteString],@"avatarUrl" ,nil];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByEMMessage:(EMMessage *)message
{
    NSString *ret = @"";
    EMMessage *lastMessage = message;
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                //                ret = NSLocalizedString(@"message.image1", @"[image]");
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
//                ret = NSLocalizedString(@"message.image1", @"[image]");
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    cell.name = conversation.chatter;
    if (conversation.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
            cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
        }
        NSString *icoPath = [NSString stringWithFormat:@"%@",[PropertyController getUserAvatar:conversation]];
        cell.imageURL = [NSURL URLWithString:  icoPath ];
        cell.placeholderImage = [UIImage imageNamed:@"logo"];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self getAvatarById:conversation.chatter]] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    cell.name = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        else
        {
            cell.name = [conversation.ext objectForKey:@"groupSubject"];
            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    
    if (![PropertyController InBalckList:conversation.chatter]) {
        cell.unreadCount = [self unreadMessageCountByConversation:conversation];
        cell.detailMsg = [self subTitleMessageByConversation:conversation];
        cell.time = [self lastMessageTimeByConversation:conversation];
    }
    else
    {
        cell.detailMsg = [self subTitleMessageByEMMessage:[PropertyController getLocalLastMessage:conversation.chatter]];
        cell.time = [self lastMessageTimeByEMMessage:[PropertyController getLocalLastMessage:conversation.chatter]];
    }
    cell.name = [PropertyController getUserName:conversation];
    if (self.dataSource.count==indexPath.row+1) {
        [cell isLastCell];
    }
    if (indexPath.row % 2 == 1) {
//        cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        cell.contentView.backgroundColor = [UIColor colorWithRed:246 green:246 blue:246 alpha:1];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;

}

-(void)didUnreadMessagesCountChanged
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
}
// 得到最后消息时间
-(NSString *)lastMessageTimeByEMMessage:(EMMessage *)message
{
    NSString *ret = @"";
    EMMessage *lastMessage = message;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)send:(id)sender {
  
//    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"dw798833403" isGroup:NO];
//    EMChatText *messgae = [[EMChatText alloc] initWithText:text.text];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:messgae];
//    EMMessage *msg = [[EMMessage alloc] initWithReceiver:@"dw798833403"
//                                                  bodies:@[body]];
//    [[EaseMob sharedInstance].chatManager sendMessage:msg progress:nil error:nil];

}
-(void)didReceiveMessageId:(NSString *)messageId chatter:(NSString *)conversationChatter error:(EMError *)error
{
    
}
-(void)didReceiveMemoryWarning
{
    
}
// 接收完离线消息加载会话列表
-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
}
@end
