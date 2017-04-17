//
//  NSString+boundingRectWithSize.m
//  CBNClient
//
//  Created by mac on 14-3-5.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import "NSString+boundingRectWithSize.h"

@implementation NSString (boundingRectWithSize)
-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    CGSize textSize = [attributedStr boundingRectWithSize:size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil].size;

    return textSize;
}

+(NSAttributedString*)stringWithString:(NSString*)string withFont:(UIFont*)font withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];

    return attributedStr;
}
@end
@implementation NSObject(unSafePointer)
-(const void *)unSafePointer{
    return ((__bridge const void *)self);
}@end