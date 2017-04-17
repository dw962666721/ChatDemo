//
//  ChooseViewGroup.m
//  E_Education
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "ChooseViewGroup.h"
#import "ChooseViewStylePulldown.h"
@implementation ChooseViewGroup

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.required=YES;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.required=YES;
    }
    return self;
}
-(Class)chooseViewType{
    return [ChooseViewStylePulldown class];
}
-(UIColor*)chooseViewBorderColor{
    return [UIColor lightGrayColor];
}
-(UIColor*)chooseViewSeparatorLineColor{
    return [UIColor clearColor];
}
-(void)layoutSubviews{
    int count=[self.datasource numberOfChooseViewInGroup:self];
    // 每个chooseView之间的间隔
    CGFloat spacing=8;
    if([self.datasource respondsToSelector:@selector(spacingOfChooseViewGroup:)])
        spacing=[self.datasource spacingOfChooseViewGroup:self];
    CGFloat leading=0;
    CGFloat width=(self.frame.size.width+spacing)/count-spacing;
    for (int i=0;i<count;i++){
        ChooseView * chooseView=(ChooseView *)[self viewWithTag:tagWithIndex(i)];
        if (!chooseView) {
            
            if([self.datasource respondsToSelector:@selector(chooseViewGroup:widthOfChooseViewAtIndex:)])
                width=[self.datasource chooseViewGroup:self widthOfChooseViewAtIndex:i];
            chooseView=[[[self chooseViewType] alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
            chooseView.tag=tagWithIndex(i);
            chooseView.datasource=self;
            chooseView.value=[self chooseView:chooseView titleForRow:0 forComponent:0];
            chooseView.layer.borderColor=[self chooseViewBorderColor].CGColor;
            
            [self addSubview:chooseView];
        }
        if ([self.datasource respondsToSelector:@selector(chooseViewGroup:titleOfChooseViewAtIndex:)])
            chooseView.title=[self.datasource chooseViewGroup:self titleOfChooseViewAtIndex:i];
        chooseView.frame=CGRectMake(leading, 0, width, self.frame.size.height);
        if(i<count){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leading+width+spacing/2-4, 5, 1, 15)];
        lineView.backgroundColor=[self chooseViewSeparatorLineColor];
        [self addSubview:lineView];
        }
        leading+=width+spacing;
    }
}
-(void)addSubview:(UIView *)view{
    int index=indexOfChooseView(view);
    if (index<[self.datasource numberOfChooseViewInGroup:self]&&index>=0)
    {
        [self chooseView:(ChooseView*)view InitAtIndex:index];
    }
    [super addSubview:view];
}
-(void) cancelButtonClicked
{
    if (self.currentChooseView != nil)
    {
        [self.currentChooseView cancelButtonClicked];
    }
}
-(void)chooseView:(ChooseView*)chooseView InitAtIndex:(NSInteger)index{
    
}
-(NSInteger)numberOfComponentsInChooseView:(ChooseView *)chooseView{
    return 1;
}
-(NSInteger)chooseView:(ChooseView *)chooseView numberOfRowsInComponent:(NSInteger)componen{
    return [self.datasource chooseViewGroup:self numberOfChooseViewAtIndex:indexOfChooseView(chooseView)] +!self.isRequired ;
}
-(NSString *)chooseView:(ChooseView *)chooseView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString*value=@"请选择";
    if (self.isRequired||row!=0) {
       NSString*temp=[self.datasource chooseViewGroup:self valueOfIndex:row-!self.isRequired atChooseViewOfIndex:indexOfChooseView(chooseView)];
        if (temp) {
            value=temp;
        }
    }
    return value;
}
-(void)chooseViewPickerWillShow:(ChooseView *)chooseView
{
    self.currentChooseView = chooseView;
}
-(NSInteger)valueIndexOfChooseViewIndex:(NSInteger)index{
    ChooseView * chooseView=(ChooseView *)[self viewWithTag:tagWithIndex(index)];
    return [chooseView selectedRowInComponent:0] - !self.isRequired;
}
-(void)chooseViewSureButtonClicked:(ChooseView *)chooseView{
    ChooseView*temp = (id)[self viewWithTag:chooseView.tag-1];
    if (temp){
        temp.value = [self chooseView:temp titleForRow:0 forComponent:0];
        [self chooseViewSureButtonClicked:temp];
    }else{
        
    }
}
-(NSString *)valueOfChooseViewIndex:(NSInteger)index{
    ChooseView * chooseView=(ChooseView *)[self viewWithTag:tagWithIndex(index)];
    
    return chooseView.value;
}
@end
