//
//  ChartCell.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartCellFrame.h"
@class ChartCell;

@interface ChartCell : UITableViewCell
@property (nonatomic,strong) ChartCellFrame *cellFrame;
@property (nonatomic,strong) ChartContentView *chartView;
@end
