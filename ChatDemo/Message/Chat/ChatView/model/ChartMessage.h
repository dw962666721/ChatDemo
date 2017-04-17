//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
typedef enum {
    
    kMessageFrom=0,
    kMessageTo
    
}ChartMessageType;

@class ChartCellFrame;
@class ChartContentView;
#import <Foundation/Foundation.h>

@interface ChartMessage : NSObject{
     ChartContentView* _chartContentView;

}
@property (nonatomic, strong) NSString *stata; // 0: 待发送 1:正在发送 2: 已发送, 成功 3: 已发送, 失败
@property NSInteger messageStyle; // 0: 文字 1:图片 2: 语音 3: 视频
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSString *sendTime;//名字
@property (nonatomic, copy) NSString *icon;//头像
@property (nonatomic, copy) NSString *senderId;// 发送者id
@property (nonatomic, copy) NSString *receiverId;//接收者id
@property (nonatomic, copy) NSString *dialogueId;//会话id
@property (nonatomic, copy) NSString *id;// 消息id
@property (nonatomic, copy) NSString *messageId;// 消息id
@property (nonatomic, strong) EMMessage *message;// 消息id
@property (nonatomic, readonly) NSString *cellIdentifier; // cell标示符
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(void)setFrameAt:(ChartCellFrame*)chartCellFrame;
@property (nonatomic, readonly) ChartContentView *chartContentView;


@end
