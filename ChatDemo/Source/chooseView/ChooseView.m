//
//  ChooseView.m
//  E_Education
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "ChooseView.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>
#define UIColorFromRGB(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
@interface ChooseView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
@property (weak,nonatomic)UIView*topView;
@end
@implementation ChooseView

-(NSString*)title{
    return self.titleLabel.text;
}
-(void)setTitle:(NSString*)title{
    
    self.titleLabel.text=title;
    if (self.button.tag==9999) {
        [self.button setTitle:title forState:UIControlStateNormal];
    }
}
-(UIView *)topView{
    UIView* topView=self;
    while (![topView.superview isMemberOfClass:NSClassFromString(@"UIViewControllerWrapperView")]&&![topView.superview isMemberOfClass:[UIWindow class]]) {

        topView=topView.superview;
    }
    
    return topView;
}
- (instancetype)init
{
    self =[[[NSBundle mainBundle] loadNibNamed:@"ChooseView" owner:nil options:nil] lastObject];
    if (self) {
        self.datePickerRange=DatePickerRangeBeforeNow;
    }
    return self;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{

    return [super pointInside:point withEvent:event]
//    &&CGRectContainsPoint(self.button.frame, point)
    ;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.datePickerRange=DatePickerRangeBeforeNow;
        [self subViewInit];
        [self.button addTarget:self action:@selector(pickerShow:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
-(void)subViewInit{
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 44)];
    label.userInteractionEnabled=false;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.titleLabel=label;
    label=[[UILabel alloc] initWithFrame:CGRectMake(95, 0,190, 44)];
    label.userInteractionEnabled=false;
    
    [self addSubview:label];
    self.valueLabel=label;
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-60, 13, 52, 17);
    [button setImage:[UIImage imageNamed:@"添加(蓝色)"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"添加点击(蓝色)"] forState:UIControlStateHighlighted];
    button.imageEdgeInsets=UIEdgeInsetsMake(0, 35.0/2, 0, -35.0/2);
    [self addSubview:button];
    self.button=button;
 

}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self subViewInit];
        [self.button addTarget:self action:@selector(pickerShow:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return self;
}
-(NSString *)value{
    return  self.valueLabel.text;
}
-(void)setValue:(NSString *)value{
    self.valueLabel.text=value;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point=[touch locationInView:[self.pickerView superview]];
    return point.y<0;
}

- (IBAction)pickerShow:(UIButton*)sender {
    if ([self.datasource respondsToSelector:@selector(chooseViewPickerWillShow:)])
    [self.datasource chooseViewPickerWillShow:self];
    //    if ([TextFieldListener shareInstance].currentTextField)
    //        [[TextFieldListener shareInstance].currentTextField resignFirstResponder];
    
    if (![self.pickerView superview]) {
        if ([self.datasource respondsToSelector:@selector(chooseView:willClickButton:)]) {
            [self.datasource chooseView:self willClickButton:sender];
        }
        if (self.pickerType==ChooseViewPickerTypeDatePicker)
        {
            if (!self.pickerView) {
                self.pickerView=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 60)];
                if (self.datePickerRange==DatePickerRangeBeforeNow) {
                    [self.pickerView setMaximumDate:[NSDate date]];
                }else if (self.datePickerRange==DatePickerRangeAfterNow){
                    [self.pickerView setMinimumDate:[NSDate date]];

                }

            }
            
            [self.pickerView setDatePickerMode:UIDatePickerModeDate];
        }else{
            if (!self.pickerView) {
                self.pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 60)];
            }
            [self.pickerView setShowsSelectionIndicator : YES];
            
            [self.pickerView setValue:self forKey:@"dataSource"];
            
            for (int i=0; i<[self.datasource numberOfComponentsInChooseView:self]; i++) {
                for (int j=0; j<[self.datasource chooseView:self numberOfRowsInComponent:i]; j++) {
                    NSString*title=[[self.value componentsSeparatedByString:@" "] objectAtIndex:i];
                    if ([title isEqualToString:[self.datasource chooseView:self titleForRow:j forComponent:i]]) {
                        [self.pickerView selectRow:j inComponent:i animated:NO];
                        if (i+1<[self.datasource numberOfComponentsInChooseView:self]) {
                            [self.pickerView reloadComponent:i+1];
                        }
                    }
                }
            }
            
        }
        
        
        [self setPicker];
        
        
    }
}

-(void)setPicker{
    
    self.wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topView.frame.size.height)];
    self.wrapView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.topView addSubview:self.wrapView];
    
      UITapGestureRecognizer*endTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    endTap.delegate = self;
    endTap.cancelsTouchesInView = NO;
    [self.wrapView addGestureRecognizer:endTap];
    
    [self.pickerView setValue:self forKey:@"delegate"];
    [self.pickerView setAutoresizingMask : UIViewAutoresizingFlexibleWidth ];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [self.pickerView frame].size.height+[self.pickerView frame].origin.y)];
    [self.topView addSubview:view];
    UITapGestureRecognizer*recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClicked)];
    if (objc_getAssociatedObject(self.class,  (__bridge const void *)(@"kCurrentPickView"))) {
        [self cancelButtonClicked];
    }
    recognizer.delegate=self;
    objc_setAssociatedObject(self.class, (__bridge const void *)(@"kCurrentPickView"), view, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self.class, (__bridge const void *)(@"kCurrentRecognizer"), recognizer, OBJC_ASSOCIATION_RETAIN);
    [self.topView addGestureRecognizer:recognizer];
    recognizer.cancelsTouchesInView = NO;
    view.backgroundColor=UIColorFromRGB(0x59bdef, 1);
    [self.pickerView setBackgroundColor:[UIColor clearColor]];
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    UIView*backgroundView=[[UIView alloc] initWithFrame:[self.pickerView frame]];
    backgroundView.backgroundColor=UIColorFromRGB(0xf0f0f0, 1);
    [view addSubview:backgroundView];
    [view addSubview:self.pickerView];
    CGRect frame=CGRectZero;
    for (UIView *view in [self.pickerView subviews]) {
        if (view.frame.size.height==0.5) {
            float y=view.frame.origin.y;
            if (frame.origin.y==0) {
                frame.origin.y=y;
            }else{
                if (y>frame.origin.y) {
                    frame.size.height=y-frame.origin.y;
                }else{
                    frame.size.height=frame.origin.y-y;
                    frame.origin.y=y;
                }
            }
        }
    }
    frame.size.width=[UIScreen mainScreen].bounds.size.width;
    frame.origin.y+=44;
    backgroundView=[[UIView alloc] initWithFrame:frame];
    backgroundView.backgroundColor=[UIColor whiteColor];
    [view addSubview:backgroundView];
    [view bringSubviewToFront:self.pickerView];
    button.frame=CGRectMake(0, 0,60, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-60,0 , 60, 44);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -view.frame.size.height);
    }completion:nil];
}
-(void)endEdit{
        [self cancelButtonClicked];
}

-(void)cancelButtonClicked{
    
    UIView*view=objc_getAssociatedObject(self.class, @"kCurrentPickView");
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.transform=CGAffineTransformIdentity;
    }completion:^(BOOL finished){
        [view removeFromSuperview];
    }];
    UIGestureRecognizer*recognizer=objc_getAssociatedObject(self.class, @"kCurrentRecognizer");
    if (self.topView&&recognizer)
    {
        [self.topView removeGestureRecognizer:recognizer];
        if ([self.datasource respondsToSelector:@selector(chooseViewCancelButtonClicked:)])
            [self.datasource chooseViewCancelButtonClicked:self];
    }
    [self.wrapView removeFromSuperview];
    objc_setAssociatedObject(self.class, (__bridge const void *)(@"kCurrentPickView"), nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self.class, (__bridge const void *)(@"kCurrentRecognizer"), nil, OBJC_ASSOCIATION_ASSIGN);
}

-(void)sureButtonClicked{
    NSString*value;
    if (self.pickerType==ChooseViewPickerTypeDatePicker) {
        UIDatePicker*datePicker =(UIDatePicker*)self.pickerView;
        NSDateFormatter*formatter=[[NSDateFormatter alloc] init];
        formatter.dateFormat=@"yyyy-MM-dd";
        value=[formatter stringFromDate:datePicker.date];
    }else{
        value=[[NSMutableString alloc] init];
        for (int i=0;i<[self.pickerView numberOfComponents];i++) {
            NSInteger row=[self.pickerView selectedRowInComponent:i];
            [(NSMutableString*)value appendString:[NSString stringWithFormat:@"%@%@",value.length==0?@"":@" ",[self pickerView:self.pickerView titleForRow:row forComponent:i]]];
            [self.pickerView selectRow:row inComponent:i animated:NO];
        }
    }
    self.value=value;
    [self cancelButtonClicked];
    if ([self.datasource respondsToSelector:@selector(chooseViewSureButtonClicked:)])
        [self.datasource chooseViewSureButtonClicked:self];
}
-(NSInteger) selectedRowInComponent:(NSInteger)component{
    for (int i=0;i<[self.datasource chooseView:self numberOfRowsInComponent:component];i++){
        if ([self.value isEqualToString:[self.datasource chooseView:self titleForRow:i forComponent:component]])
            return i;
    }
    return [self.pickerView selectedRowInComponent:component];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.datasource numberOfComponentsInChooseView:self];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return [self.datasource respondsToSelector:@selector(chooseView:widthForComponent:)]?[self.datasource chooseView:self numberOfRowsInComponent:component]:[UIScreen mainScreen].bounds.size.width/[self.datasource numberOfComponentsInChooseView:self];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen{
    return [self.datasource chooseView:self numberOfRowsInComponent:componen];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.datasource chooseView:self titleForRow:row forComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 44;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.datasource numberOfComponentsInChooseView:self]==2&&component==0) {
        [self.pickerView reloadComponent:1];
    }
    if ([self.datasource respondsToSelector:@selector(chooseView:didSelectRow:inComponent:)])
        [self.datasource chooseView:self didSelectRow:row inComponent:component];
}
@end
