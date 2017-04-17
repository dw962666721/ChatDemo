//
//  VoiceChartMessage.h
//  E_Education
//
//  Created by admin on 15-1-6.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

#import "ChartMessage.h"

@interface ChartVoiceMessage : ChartMessage

@property (nonatomic, copy) NSString *voiceTime;//录音时长
@property (nonatomic, copy) NSString *record;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

