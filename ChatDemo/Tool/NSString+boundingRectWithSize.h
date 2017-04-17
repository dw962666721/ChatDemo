//
//  NSString+boundingRectWithSize.h
//  CBNClient
//
//  Created by mac on 14-3-5.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSString (boundingRectWithSize)
-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing;


+(NSAttributedString*)stringWithString:(NSString*)string withFont:(UIFont*)font withLineSpacing:(CGFloat)lineSpacing;
@end
@interface NSObject(unSafePointer)
-(const void *)unSafePointer;
@end
