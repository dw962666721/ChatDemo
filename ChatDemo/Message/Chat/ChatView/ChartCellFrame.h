//
//  ChartCellFrame.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartMessage.h"
#import "ChartTextMessage.h"
#import "ChartVoiceMessage.h"
#import "UIImageView+WebCache.h"
#define kIconMarginX 5
#define kIconMarginY 5
@interface ChartCellFrame : NSObject
@property (nonatomic,assign) CGRect nameRect;//名字
@property (nonatomic,assign) CGRect timeRect;//名字
@property (nonatomic,assign) CGRect iconRect;//头像
@property (nonatomic,weak) UITableView* tableView;
@property (nonatomic,assign) CGRect chartViewRect;//聊天内容
@property (nonatomic,strong) ChartMessage *chartMessage;//信息
@property (nonatomic,assign) CGFloat cellHeight; //cell高度

@end
