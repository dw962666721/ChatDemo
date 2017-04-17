//
//  ChartMessage.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartMessage.h"
#import "ChartTextMessage.h"
#import "ChartVoiceMessage.h"
#import "ChartImageMessage.h"
#import "ChatDemo-Swift.h"
@implementation ChartMessage

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    // 文本子类
    if ((dictionary[@"message"] && dictionary[@"createTime"]) && ![dictionary[@"message"] isEqual:@""])
    {
        self=[[ChartTextMessage alloc] initWithDictionary:dictionary];
        self.messageStyle = 0;
    }
    // 录音子类
    else if(dictionary[@"record"] && ![dictionary[@"record"] isEqual:@""])
    {
        self=[[ChartVoiceMessage alloc]initWithDictionary:dictionary];
        self.messageStyle = 2;
    }
    // 图片子类
    else if (dictionary[@"picture"] )
    {
        self=[[ChartImageMessage alloc] initWithDictionary:dictionary];
        self.messageStyle = 1;
    }
    
    if (self)
    {
        self.name=dictionary[@"name"];
        self.icon=dictionary[@"avatarUrl"];
//        self.icon=@"";
        self.senderId=dictionary[@"senderId"];
        self.receiverId=dictionary[@"receiverId"];
        self.dialogueId=dictionary[@"dialogueId"];
        self.id=dictionary[@"id"];
        self.stata=dictionary[@"stata"];
        self.messageType=[ [NSString stringWithFormat:@"%@",(NSString *)[UserInfoForObjc UserNumber]]   isEqualToString:self.senderId];
        // 环信未登录成功
        if ([self.senderId compare:@""] == NSOrderedSame)
        {
            self.messageType = 0;
            self.stata = @"3";
            [UserInfoForObjc loginHX];
        }
        
    }
    return self;
}
-(void)setFrameAt:(ChartCellFrame *)chartCellFrame
{
}
-(ChartContentView *)chartContentView
{
    return nil;
}
- (NSString *)messageId
{
    return _message.messageId;
}

@end
