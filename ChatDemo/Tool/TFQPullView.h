//
//  TFQRefreshView.h
//  TFQRefreshView
//
//  Created by mac on 13-8-16.
//  Copyright (c) 2013年 TFQ. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum{
    TFQPullPulling = 0,
    TFQPullNormal,
    TFQPullLoading,
} TFQPullStatus;
typedef enum{
    TFQPullViewTop = 0,
    TFQPullViewBottom,
} TFQPullType;
#define DEFAULT_ARROW_IMAGE         [UIImage imageNamed:@"blueArrow.png"]
//#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]
#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithWhite:240.0/255 alpha:1]
#define DEFAULT_TEXT_COLOR          [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define DEFAULT_ACTIVITY_INDICATOR_STYLE    UIActivityIndicatorViewStyleGray
#define midY   PULL_TRIGGER_HEIGHT - PULL_AREA_HEIGTH/2
#define FLIP_ANIMATION_DURATION 0.18f

#define PULL_AREA_HEIGTH 60.0f
#define PULL_TRIGGER_HEIGHT (PULL_AREA_HEIGTH + 5.0f)
@protocol TFQPullViewDelegate;
@interface TFQPullView : UIView<UIScrollViewDelegate>{
    int _status;
    BOOL _isLoading;
    TFQPullType _type;
    
    // Set this to Yes when egoRefreshTableHeaderDidTriggerRefresh delegate is called and No with egoRefreshScrollViewDataSourceDidFinishedLoading
    BOOL isLoading;
}
@property (nonatomic,assign)id<TFQPullViewDelegate> delegate;
+(TFQPullView *) addToView:(UIScrollView*) scrollView delegate:(id<TFQPullViewDelegate>) delegate;
+(TFQPullView *) addToView:(UIScrollView*) scrollView delegate:(id<TFQPullViewDelegate>) delegate type:(TFQPullType)type;
+(TFQPullView *) addToView:(UIScrollView*) scrollView delegate:(id<TFQPullViewDelegate>) delegate type:(TFQPullType)type BackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage;
+(TFQPullView *) addToView:(UIScrollView*) scrollView delegate:(id<TFQPullViewDelegate>) delegate type:(TFQPullType)type BackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage info:(NSString*)info;
@end

@protocol TFQPullViewDelegate <NSObject>

@required
-(void)viewDidPulledTrigger:(TFQPullView *)pullView type:(TFQPullType) type;

@end