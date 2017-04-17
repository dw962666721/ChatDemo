//
//  TFQAlertUtil.m
//  CBNClient
//
//  Created by mac on 13-11-19.
//  Copyright (c) 2013年 TFQ. All rights reserved.
//

#import "TFQAlertUtil.h"
#import "NSString+boundingRectWithSize.h"
@implementation TFQAlertUtil

-(id)init{
    if ((self=[super init])) {
        self.timeDelay=2;
        self.textColor=[UIColor colorWithWhite:240.0/2 alpha:1];
        self.font=[UIFont systemFontOfSize:17];
        self.backgroundColor=[UIColor blackColor];
    
    }
    return self;
}
+(instancetype)alert{
    return [[TFQAlertUtil alloc] init];
}

-(void)showAlert{
    CGSize size=[self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:[UIFont systemFontOfSize:self.font.pointSize+3] withLineSpacing:4];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width+10  , 45)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width+10, 45)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=self.text;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=self.textColor;
    label.numberOfLines=self.lines;
    [view addSubview:label];
    view.alpha=0.8;
    view.backgroundColor=self.backgroundColor;
    label.font=self.font;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.center=[UIApplication sharedApplication].keyWindow.center;
    [self performSelectorOnMainThread:@selector(alertViewWillDisappear:) withObject:view waitUntilDone:YES];
}
-(void)showAlert:(NSString *)messgae
{
    self.text = messgae;
    CGSize size=[self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:[UIFont systemFontOfSize:self.font.pointSize+3] withLineSpacing:4];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width+10  , 45)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width+10, 45)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=self.text;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=self.textColor;
    label.numberOfLines=self.lines;
    [view addSubview:label];
    view.alpha=0.8;
    view.backgroundColor=self.backgroundColor;
    label.font=self.font;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.center=[UIApplication sharedApplication].keyWindow.center;
    [self performSelectorOnMainThread:@selector(alertViewWillDisappear:) withObject:view waitUntilDone:YES];
}
-(void)alertViewWillDisappear:(UIView*)view{
    [self performSelector:@selector(alertViewDisappear:) withObject:view afterDelay:self.timeDelay];
}
-(void)alertViewDisappear:(UIView*)view{
    [view removeFromSuperview];
}
@end
