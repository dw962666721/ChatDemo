//
//  SubjectChooseViewGroup.m
//  TFQChooseViewDemo
//
//  Created by admin on 14-11-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "SubjectChooseViewGroup.h"
static NSArray* __subjects;

@implementation SubjectChooseViewGroup

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSArray *)locations{
    if (!__subjects) {
        NSString* file=[[NSBundle mainBundle] pathForResource:@"subjects" ofType:nil];
        __subjects=[NSKeyedUnarchiver unarchiveObjectWithFile:file];
    }
    return  __subjects;
}
-(NSInteger)numberOfChooseViewInGroup:(ChooseViewGroup *)chooseViewGroup{
    return 2;
    
}
-(NSString *)value{
    return [self valueOfChooseViewIndex:1];
}
-(void)chooseView:(ChooseView*)chooseView InitAtIndex:(NSInteger)index{

}
-(void)chooseViewSureButtonClicked:(ChooseView *)chooseView{
    if (indexOfChooseView(chooseView)==0){
        ChooseView*temp = (id)[self viewWithTag:chooseView.tag-1];
        if (temp){
            temp.value = [self chooseView:temp titleForRow:1 forComponent:0];
            [self chooseViewSureButtonClicked:temp];
        }
    }
}
@end
