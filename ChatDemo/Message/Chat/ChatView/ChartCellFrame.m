//
//  ChartCellFrame.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCellFrame.h"

@implementation ChartCellFrame

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    _chartMessage=chartMessage;
    
    
    // 头像的坐标大小
    CGFloat iconX=kIconMarginX;
    CGFloat iconY=kIconMarginY;
    CGFloat iconWidth=40;
    CGFloat iconHeight=40;
    
    if(chartMessage.messageType==kMessageFrom)
    {
        
    }
    else if (chartMessage.messageType==kMessageTo)
    {
        iconX=screenWidth-kIconMarginX-iconWidth;
    }
    // 头像的frame
    self.iconRect=CGRectMake(iconX, iconY, iconWidth, iconHeight);
    // 名字的Frame
    self.nameRect = CGRectMake(45, 0, screenWidth-90, 20);
    
    [chartMessage setFrameAt:self];
    
    // 时间的Frame
    self.timeRect = CGRectMake(45, self.cellHeight-20, screenWidth-90, 20);
}


@end
