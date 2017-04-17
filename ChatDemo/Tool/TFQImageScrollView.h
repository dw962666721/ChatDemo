//
//  TFQImageScrollView.h
//  CBNClient
//
//  Created by cbn_tech on 14-6-30.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFQImageScrollView;
@protocol TFQImageScrollViewDelegate<NSObject>
@optional
-(void) imageScrollView:(TFQImageScrollView *)imageScrollView didSelectedAtIndex:(NSInteger)index;
-(void) imageScrollView:(TFQImageScrollView *)imageScrollView didEndScrolltoIndex:(NSInteger)index;
-(void)imageScrollViewTouchBegin;
-(void)imageScrollViewTouchEnd;
@end
@protocol TFQImageScrollViewDatasource<NSObject>
-(NSInteger) numberOfImageScrollView:(TFQImageScrollView *)imageScrollView;

-(NSString*) imageScrollView:(TFQImageScrollView *)imageScrollView imageUrlAtIndex:(NSInteger)index;

@end
@interface TFQImageScrollView : UIScrollView

-(void)reloadImages;
-(void)nextImage;

@property(nonatomic,readwrite)CGSize imageSize;
@property (nonatomic,strong)id<TFQImageScrollViewDatasource> imageScrollViewDatasource;
@property (nonatomic,strong)id<TFQImageScrollViewDelegate> imageScrollViewDelegate;
@end
