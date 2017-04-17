//
//  ChooseViewGroup.h
//  E_Education
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"

#define tagWithIndex(index) 0xadc-index
#define indexOfChooseView(chooseView) 0xadc-chooseView.tag
@class ChooseViewGroup;
@protocol ChooseViewGroupDatasource <NSObject>
-(NSInteger)numberOfChooseViewInGroup:(ChooseViewGroup *)chooseViewGroup;
-(NSString*)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup valueOfIndex:(NSInteger)index atChooseViewOfIndex:(NSInteger)chooseViewIndex;
-(NSInteger)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup numberOfChooseViewAtIndex:(NSInteger)index;
@optional
-(Class)classOfChooseViewGroup;
-(NSString*)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup titleOfChooseViewAtIndex:(NSInteger)index;
-(CGFloat)spacingOfChooseViewGroup:(ChooseViewGroup *)chooseViewGroup;
-(CGFloat)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup widthOfChooseViewAtIndex:(NSInteger)index;
-(CGFloat)chooseViewGroup:(ChooseViewGroup *)chooseViewGroup didSelectedAtIndex:(NSInteger) index;

@end
@protocol ChooseViewGroupDelegate <NSObject>



@end
@interface ChooseViewGroup : UIView<ChooseViewDatasource>
@property (nonatomic,weak)id<ChooseViewGroupDelegate> delegate;
@property (nonatomic,weak)id<ChooseViewGroupDatasource> datasource;
@property (nonatomic,assign,getter=isRequired)BOOL required;
@property (nonatomic,readonly)id value;
@property ChooseView *currentChooseView;
-(NSInteger) valueIndexOfChooseViewIndex:(NSInteger)index;
-(NSString*) valueOfChooseViewIndex:(NSInteger)index;
-(void) cancelButtonClicked;
@end
