//
//  ChartTextMessage
//  E_Education
//
//  Created by admin on 15-1-6.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

#import "ChartMessage.h"

@interface ChartTextMessage : ChartMessage

@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, copy) NSString *sendTime;//发送时间

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

