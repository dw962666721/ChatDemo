//
//  TextChartMessage.m
//  E_Education
//
//  Created by admin on 15-1-6.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ChartTextMessage.h"
#import "ChartCellFrame.h"
#import "ChartContentView.h"
#import "ChartTextView.h"
@implementation ChartTextMessage
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.content=dictionary[@"message"];
        self.sendTime=dictionary[@"createTime"];
    }
    return self;
}
// get TextCell 标示符
-(NSString *)cellIdentifier{
    return @"TextCell";
}
-(void)setFrameAt:(ChartCellFrame *)chartCellFrame{
    CGFloat iconWidth=40;
    CGFloat contentX=iconWidth+kIconMarginX;
//    CGFloat contentY=kIconMarginY;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
//    NSString *test = [NSString stringWithFormat:@"%@%@",self.content,@"aaa"];
    CGSize contentSize=[self.content boundingRectWithSize:CGSizeMake(kScreenWidth-2*iconWidth-10, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    CGFloat contentW=contentSize.width;
    
    if (contentW<110)
    {
//        contentW = 110;
    }
    if(self.messageType==kMessageTo)
    {
        contentX=(kScreenWidth-10-contentW-iconWidth-20)/2;
    }
    else
    {
        contentX=iconWidth/2+kIconMarginX;
    }
    // 内容视图的高度和frame
    chartCellFrame.chartViewRect=CGRectMake(contentX, 10, contentW+20, contentSize.height+20);
    chartCellFrame.cellHeight=MAX(CGRectGetMaxY(chartCellFrame.iconRect), CGRectGetMaxY(chartCellFrame.chartViewRect))+kIconMarginX+30;
}
//// get method
-(ChartContentView *)chartContentView{
    
    ChartContentView*temp=[[ChartTextView alloc] init];
    temp.chartMessage=self;
    return temp;
}
@end
