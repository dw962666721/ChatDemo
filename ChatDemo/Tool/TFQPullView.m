//
//  TFQRefreshView.m
//  TFQRefreshView
//
//  Created by mac on 13-8-16.
//  Copyright (c) 2013年 TFQ. All rights reserved.
//

#import "TFQPullView.h"
@interface TFQPullView(){
    CALayer *_arrowImage;
    UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
    NSDate *_date;
	UIActivityIndicatorView *_activityView;
}
@property (nonatomic,readonly) CALayer *arrowImage;
@property (nonatomic,readonly) UILabel *statusLabel;
@property (nonatomic,readonly) UILabel *lastUpdatedLabel;
@property (nonatomic,readonly) 	UIActivityIndicatorView *activityView;
@property (nonatomic,strong) 	NSString *info;
@property (nonatomic,strong) 	UIScrollView *scrollView;


@end

@implementation TFQPullView
-(CALayer *)arrowImage{
    if(!_arrowImage){
        
        /* Config Arrow Image */
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(self.frame.size.width/2-135.0f,midY - 35, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
        
    }return _arrowImage;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        /* Config Status Updated Label */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,midY - 18, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
    }return _statusLabel;
}
-(UILabel *)lastUpdatedLabel{
    if (!_lastUpdatedLabel) {
        /* Config Last Updated Label */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, midY, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
    }
    return _lastUpdatedLabel;
}
-(UIActivityIndicatorView *)activityView{
    if (!_activityView){
        
        /* Config activity indicator */
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
        view.frame = CGRectMake(25.0f,midY- 8, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
    }return _activityView;
}
- (void)setStatus:(TFQPullStatus)aStatus{
	if (_type)
        switch (aStatus) {
            case TFQPullPulling:
                
                self.statusLabel.text = NSLocalizedStringFromTable(@"释放加载更多...",@"PullTableViewLan", @"Release to load more status");
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
                
                break;
            case TFQPullNormal:
                
                if (_status == TFQPullPulling) {
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                    [CATransaction commit];
                }

                self.statusLabel.text = NSLocalizedStringFromTable(self.info?self.info:@"上拉加载更多...", @"PullTableViewLan",@"Pull down to load more status");
                [self.activityView stopAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                self.arrowImage.hidden = NO;
                self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
                
                break;
            case TFQPullLoading:
                
                self.statusLabel.text = NSLocalizedStringFromTable(@"加载中...", @"PullTableViewLan",@"Loading Status");
                [self.activityView startAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                self.arrowImage.hidden = YES;
                [CATransaction commit];
                
                break;
            default:
                break;
        }else{
            switch (aStatus) {
                case TFQPullPulling:
                    self.statusLabel.text = NSLocalizedStringFromTable(@"释放立即刷新...",@"PullTableViewLan", @"Release to refresh status");
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                    [CATransaction commit];
                    
                    break;
                case TFQPullNormal:
                    
                    if (_status == TFQPullPulling) {
                        [CATransaction begin];
                        [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                        self.arrowImage.transform = CATransform3DIdentity;
                        [CATransaction commit];
                    }
                    
                    self.statusLabel.text = NSLocalizedStringFromTable(self.info?self.info:@"下拉刷新内容...",@"PullTableViewLan", @"Pull down to refresh status");
                    [self.activityView stopAnimating];
                    [CATransaction begin];
                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                    self.arrowImage.hidden = NO;
                    self.arrowImage.transform = CATransform3DIdentity;
                    [CATransaction commit];
                    break;
                case TFQPullLoading:
                    
                    self.statusLabel.text = NSLocalizedStringFromTable(@"加载中...",@"PullTableViewLan", @"Loading Status");
                    [self.activityView startAnimating];
                    [CATransaction begin];
                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                    self.arrowImage.hidden = YES;
                    [CATransaction commit];
                    
                    break;
                default:
                    break;
            }
//            [self refreshLastUpdatedDate];
        }
    _status = aStatus;

    
}
#define aMinute 60
#define anHour 3600
#define aDay 86400
- (void)refreshLastUpdatedDate {
    
	
    if(_date) {
        NSTimeInterval timeSinceLastUpdate = [_date timeIntervalSinceNow];
        NSInteger timeToDisplay = 0;
        timeSinceLastUpdate *= -1;
        
        if(timeSinceLastUpdate < anHour) {
            timeToDisplay = (NSInteger) (timeSinceLastUpdate / aMinute);
            
            if(timeToDisplay <= /* Singular*/ 1) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Updated 1 minute ago",@"PullTableViewLan",@"Last uppdate in minutes singular")];
            } else {
                /* Plural */
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Updated %ld minutes ago",@"PullTableViewLan",@"Last uppdate in minutes plural"), (long)timeToDisplay];
                
            }
            
        } else if (timeSinceLastUpdate < aDay) {
            timeToDisplay = (NSInteger) (timeSinceLastUpdate / anHour);
            if(timeToDisplay == /* Singular*/ 1) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Updated %ld hour ago",@"PullTableViewLan",@"Last uppdate in hours singular"), (long)timeToDisplay];
            } else {
                /* Plural */
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Updated %ld hours ago",@"PullTableViewLan",@"Last uppdate in hours plural"), (long)timeToDisplay];
                
            }
            
        } else {
            timeToDisplay = (NSInteger) (timeSinceLastUpdate / aDay);
            if(timeToDisplay == /* Singular*/ 1) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Updated %ld day ago",@"PullTableViewLan",@"Last uppdate in days singular"), (long)timeToDisplay];
            } else {
                /* Plural */
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Updated %ld days ago",@"PullTableViewLan",@"Last uppdate in days plural"), (long)timeToDisplay];
            }
            
        }
        
    } else {
        _lastUpdatedLabel.text = nil;
    }
    
    // Center the status label if the lastupdate is not available
    
    if(!_lastUpdatedLabel.text) {
        _statusLabel.frame = CGRectMake(0.0f, midY - 8, self.frame.size.width, 20.0f);
    } else {
        _statusLabel.frame = CGRectMake(0.0f, midY - 18, self.frame.size.width, 20.0f);
    }
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage
{
    self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
    
    if(textColor) {
        self.lastUpdatedLabel.textColor = textColor;
        self.statusLabel.textColor = textColor;
    } else {
        self.lastUpdatedLabel.textColor = DEFAULT_TEXT_COLOR;
        self.statusLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    self.lastUpdatedLabel.shadowColor = [_lastUpdatedLabel.textColor colorWithAlphaComponent:0.1f];
    self.statusLabel.shadowColor = [_statusLabel.textColor colorWithAlphaComponent:0.1f];
    
    self.arrowImage.contents = (id)(arrowImage? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);
    
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (!self.hidden) {

	if (_status==TFQPullPulling && !isLoading) {
        [self startAnimatingWithScrollView:scrollView];
            if ([self.delegate respondsToSelector:@selector(viewDidPulledTrigger:type:)]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [self.delegate viewDidPulledTrigger:self type:_type];
                    if (!_type){
                        _date=[NSDate date];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self refreshScrollViewDataSourceDidFinishedLoading:scrollView];
                        if ([self.superview respondsToSelector:@selector(reloadData)]) {
                            [self.superview performSelector:@selector(reloadData)];
                        }
                    });
                });
            }
        }
	}
}

- (void)startAnimatingWithScrollView:(UIScrollView *) scrollView {
    isLoading = YES;
    
    [self setStatus:TFQPullLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    if (_type) {
        currentInsets.bottom =scrollView.bounds.size.height - MIN(scrollView.bounds.size.height, scrollView.contentSize.height)+ PULL_AREA_HEIGTH;

    }else
        currentInsets.top = PULL_AREA_HEIGTH;
    scrollView.contentInset = currentInsets;
    
    [UIView commitAnimations];
    
    if (_type) {
        if(scrollView.contentSize.height-(scrollView.contentOffset.y +  MIN(scrollView.bounds.size.height,  scrollView.contentSize.height))<= 0){
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + PULL_AREA_HEIGTH) animated:YES];
        } }else if(scrollView.contentOffset.y <= 0){
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -PULL_AREA_HEIGTH) animated:YES];
        }
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
    isLoading = NO;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    if (_type) {
        currentInsets.bottom =0;
        CGPoint offset= scrollView.contentOffset;
        offset.y= scrollView.contentOffset.y-PULL_AREA_HEIGTH;
        scrollView.contentOffset=offset;
    }else
        currentInsets.top = 0;
    scrollView.contentInset = currentInsets;
	[UIView commitAnimations];
	
	[self setStatus:TFQPullNormal];
    
}

- (void)refreshScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self refreshLastUpdatedDate];
}

+(TFQPullView *)addToView:(UIScrollView *)scrollView delegate:(id<TFQPullViewDelegate>) delegate{
    return  [self addToView:scrollView delegate:delegate  type:TFQPullViewTop BackgroundColor:nil textColor:nil arrowImage:nil];
}
+(TFQPullView *)addToView:(UIScrollView *)scrollView delegate:(id<TFQPullViewDelegate>) delegate type:(TFQPullType)type{
    return  [self addToView:scrollView  delegate:delegate type:type BackgroundColor:nil textColor:nil arrowImage:nil];
}
+(TFQPullView *)addToView:(UIScrollView *)scrollView delegate:(id<TFQPullViewDelegate>) delegate type:(TFQPullType)type BackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage
{
    return  [TFQPullView addToView:scrollView delegate:delegate type:type BackgroundColor:backgroundColor textColor:textColor arrowImage:arrowImage info:nil];

}

+(TFQPullView *) addToView:(UIScrollView*) scrollView delegate:(id<TFQPullViewDelegate>) delegate type:(TFQPullType)type BackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage info:(NSString*)info{
    TFQPullView* view=   [[TFQPullView alloc]init];
    [view addToView:scrollView delegate:delegate  type:type BackgroundColor:backgroundColor textColor:textColor arrowImage:arrowImage];
    view.info=info;
    view.scrollView=scrollView;
    return view;
}
-(void)addToView:(UIScrollView *)scrollView delegate:(id<TFQPullViewDelegate>) delegate  type:(TFQPullType)type BackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage
{
    
    scrollView.bounces=true;
    scrollView.alwaysBounceVertical=true;
    _isLoading = NO;
    [scrollView addSubview:self];
    _date=[NSDate date];
    self.delegate=delegate;
    if ((_type=type)){
        self.frame=CGRectMake(0, scrollView.contentSize.height>scrollView.frame.size.height?scrollView.contentSize.height:scrollView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 600) ;
        
    }else
        self.frame=CGRectMake(0, -PULL_AREA_HEIGTH, [UIScreen mainScreen].bounds.size.width, PULL_AREA_HEIGTH) ;
    [self setBackgroundColor:backgroundColor textColor:textColor arrowImage:arrowImage];
    [self setStatus:TFQPullNormal];
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}
-(void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    self.scrollView=nil;
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isEqual:[self superview]]) {
        UIScrollView* scrollView= object;
        if([@"contentOffset" isEqualToString:keyPath] ){
            if (_type) {
                CGFloat bottomOffset = (scrollView.frame.size.height<scrollView.contentSize.height?scrollView.contentSize.height:scrollView.frame.size.height)-scrollView.frame.size.height;
                if (_status == TFQPullLoading) {
                    
                    CGFloat offset = MAX(bottomOffset * -1, 0);
                    offset = MIN(offset, PULL_AREA_HEIGTH);
                    UIEdgeInsets currentInsets = scrollView.contentInset;
                    currentInsets.bottom = offset? offset + PULL_TRIGGER_HEIGHT: 0;
                    scrollView.contentInset = currentInsets;
                } else if (scrollView.isDragging) {
                    if (_status == TFQPullPulling && scrollView.contentOffset.y< bottomOffset +PULL_TRIGGER_HEIGHT&& scrollView.contentOffset.y> bottomOffset && !isLoading) {
                        [self setStatus:TFQPullNormal];
                    } else if (_status ==TFQPullNormal && scrollView.contentOffset.y> bottomOffset +PULL_TRIGGER_HEIGHT && !isLoading) {
                        [self setStatus:TFQPullPulling];
                        
                    }
                    
                    if (scrollView.contentInset.bottom != 0) {
                        UIEdgeInsets currentInsets = scrollView.contentInset;
                        currentInsets.bottom = 0;
                        scrollView.contentInset = currentInsets;
                    }
                    
                }else{
                    [self refreshScrollViewDidEndDragging:object];
                }
            }else{
                if (_status ==TFQPullLoading) {
                    CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
                    offset = MIN(offset, PULL_AREA_HEIGTH);
                    UIEdgeInsets currentInsets = scrollView.contentInset;
                    currentInsets.top = offset;
                    scrollView.contentInset = currentInsets;
                    
                } else if (scrollView.isDragging) {
                    [self refreshScrollViewWillBeginDragging:scrollView];
                    if (_status == TFQPullPulling && scrollView.contentOffset.y > -PULL_TRIGGER_HEIGHT && scrollView.contentOffset.y < 0.0f && !isLoading) {
                        [self setStatus:TFQPullNormal];
                    } else if (_status == TFQPullNormal && scrollView.contentOffset.y < -PULL_TRIGGER_HEIGHT && !isLoading) {
                        [self setStatus:TFQPullPulling];
                        
                    }
                    
                    if (scrollView.contentInset.top != 0) {
                        UIEdgeInsets currentInsets = scrollView.contentInset;
                        currentInsets.top = 0;
                        scrollView.contentInset = currentInsets;
                    }
                    
                }else {
                    [self refreshScrollViewDidEndDragging:object];
                }
                
            }
        }else if (_type==TFQPullViewBottom) {
            if([@"frame" isEqualToString: keyPath]){
                
                NSValue *value=[change objectForKey:@"old"];
                CGRect rect;
                [value getValue:&rect];
                if(scrollView.frame.size.height!=rect.size.height){
                    CGRect frame= self.frame;
                    frame.origin.y=scrollView.frame.size.height>scrollView.contentSize.height?scrollView.frame.size.height:scrollView.contentSize.height;
                    self.frame=frame;
                }
            }
            else if([@"contentSize" isEqualToString: keyPath]){
                NSValue *value=[change objectForKey:@"old"];
                CGSize size;
                [value getValue:&size];
                if(scrollView.contentSize.height!=size.height){
                    CGRect frame= self.frame;
                    frame.origin.y=scrollView.frame.size.height>scrollView.contentSize.height?scrollView.frame.size.height:scrollView.contentSize.height;
                    self.frame=frame;
                }
            }
        }
        
    }
}
@end
