//
//  ChooseView.h
//  E_Education
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ChooseView;
@protocol ChooseViewDatasource<NSObject>
@optional
-(NSInteger)numberOfComponentsInChooseView:(ChooseView *)chooseView;
-(NSString *)chooseView:(ChooseView *)chooseView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(NSInteger)chooseView:(ChooseView *)chooseView numberOfRowsInComponent:(NSInteger)componen;
-(CGFloat)chooseView:(ChooseView *)chooseView widthForComponent:(NSInteger)component;

-(void)chooseView:(ChooseView *)chooseView willClickButton:(UIButton *)button;
-(void)chooseViewPickerWillShow:(ChooseView *)chooseView;
-(void)chooseView:(ChooseView *)chooseView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
-(void)chooseViewSureButtonClicked:(ChooseView *)chooseView ;
-(void)chooseViewCancelButtonClicked:(ChooseView *)chooseView ;
@end

typedef enum{
    DatePickerRangeBeforeNow = 0,
    DatePickerRangeAfterNow,
    DatePickerRangeAnyTime
} DatePickerRange;

typedef enum{
    ChooseViewPickerTypeCustomPicker= 0,
    ChooseViewPickerTypeDatePicker
} ChooseViewPickerType;
@interface ChooseView : UIControl
@property (assign,nonatomic)NSString*title;
@property (assign,nonatomic)NSString*value;
@property (assign,nonatomic)ChooseViewPickerType pickerType;
@property (strong,nonatomic)id<ChooseViewDatasource> datasource;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) id pickerView;
@property (strong, nonatomic) UIView *wrapView;
@property (weak, nonatomic) UIButton *button;
@property (assign, nonatomic) DatePickerRange datePickerRange;

-(NSInteger) selectedRowInComponent:(NSInteger)component;

-(void)sureButtonClicked;
-(void)cancelButtonClicked;
-(void)setPicker;
@end
