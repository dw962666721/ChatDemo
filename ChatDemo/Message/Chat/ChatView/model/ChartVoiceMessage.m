//
//  ChartVoiceMessage
//  E_Education
//
//  Created by admin on 15-1-6.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ChartVoiceMessage.h"
//#import "ChartVoiceView.h"
#import "ChartCellFrame.h"
//#import "ChartDemo-Swift.h"
@implementation ChartVoiceMessage

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        // 分割字符串
        
        NSString *string=dictionary[@"record"];
        NSArray *array=[string componentsSeparatedByString:@"="];
        self.voiceTime = [array objectAtIndex:1];
//        self.record = [NSString stringWithFormat:@"%@%@",[ServerURL4Objc serverURL],string];

    }
    return self;
}
// get VoiceCell 标示符
-(NSString *)cellIdentifier{
    return @"VoiceCell";
}
-(void)setFrameAt:(ChartCellFrame *)chartCellFrame{
    
    CGFloat iconWidth=40;
    CGFloat contentX=CGRectGetMaxX(chartCellFrame.iconRect)+kIconMarginX;
    CGFloat contentY=kIconMarginY;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
    
    // 计算录音时长的长度
    CGSize contentSize=[self.voiceTime boundingRectWithSize:CGSizeMake(kScreenWidth-2*iconWidth-20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    CGFloat voiceTimeLength = [self.voiceTime intValue];
    // 录音宽度=固定值+(屏宽/一个数值)*录音时间
    CGFloat contentW=25 + (kScreenWidth/150) * voiceTimeLength;
    
    if (contentW>200)
    {
        contentW=200;
    }
    if(self.messageType==kMessageTo)
    {
        contentX=kScreenWidth-kIconMarginX-contentW-iconWidth-30;
    }
    // 内容视图的高度和frame
    chartCellFrame.chartViewRect=CGRectMake(contentX, contentY+20, contentW+30, contentSize.height+13);
    chartCellFrame.cellHeight=MAX(CGRectGetMaxY(chartCellFrame.iconRect), CGRectGetMaxY(chartCellFrame.chartViewRect))+kIconMarginX;
}
//-(ChartContentView *)chartContentView{
//
//    ChartContentView*temp=[[ChartVoiceView alloc] init];
//    temp.chartMessage=self;
//    return temp;
//    
//}
@end
