//
//  ChartImageMessage.m
//  ChatMessageDemo
//
//  Created by admin on 15-1-8.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kIconMarginX 5

#import "ChartImageMessage.h"
#import "UIImageView+WebCache.h"
#import "ChatDemo-Swift.h"
#import "SDImageCache.h"

#import "ChartCellFrame.h"
#import "ChartImageView.h"
@interface ChartImageMessage(){
    __weak ChartCellFrame*_chartCellFrame;
    NSString* _picture;
}
@end
@implementation ChartImageMessage
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _picture = [NSString stringWithFormat:@"%@%@",[ServerURL4Objc serverURL],dictionary[@"picture"]];
        _imageUrl = [NSURL URLWithString:_picture];
    }
    return self;
}
// get ImageCell 标示符
-(NSString *)cellIdentifier{
    return @"ImageCell";
}
-(UIImage *)image{
    if(!_image){
        if (!(_image=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_picture]))
        {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_picture] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (error)
                _image=[UIImage imageNamed:@"加载失败"];
                [self setFrame];
                [self.delegate imageDidDownLoad];
            }];
        }
    }
    return _image;
}

-(void)setFrame{
    CGFloat iconWidth=40;
    CGFloat contentX=CGRectGetMaxX(_chartCellFrame.iconRect)+kIconMarginX;
    
    CGFloat contentY=kIconMarginY;
    CGSize size;
    if (self.image){
        if(self.image.size.height<120&&self.image.size.width<120){
            size=self.image.size;
        }else{
            size=CGSizeMake(120, 120);
            size.height*=(self.image.size.height/self.image.size.width);
            CGFloat ratio=size.width/size.height;
            ratio = ratio<1 ? ratio : 1;
            size.width = size.width*ratio;
            size.height = size.height*ratio;
        }
    }else{
        size=CGSizeMake(72, 72);
    }
    if(self.messageType==kMessageTo)
    {
        contentX=kScreenWidth-kIconMarginX-size.width-iconWidth;
    }
    
    _chartCellFrame.chartViewRect=CGRectMake(contentX, contentY, size.width,size.height);
    _chartCellFrame.cellHeight=MAX(CGRectGetMaxY(_chartCellFrame.iconRect), CGRectGetMaxY(_chartCellFrame.chartViewRect))+kIconMarginY;
    
}
-(void)setFrameAt:(ChartCellFrame *)chartCellFrame{
    _chartCellFrame=chartCellFrame;
    [self setFrame];
}
// get method
-(ChartContentView *)chartContentView{
    
    ChartContentView * temp=[[ChartImageView alloc] init];
    temp.chartMessage=self;
    return temp;
}
@end
