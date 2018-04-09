//
//  AKTableViewCell.h
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKCellLayout.h"

@class LWAsyncDisplayView;

@interface AKTableViewCell : UITableViewCell

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic, assign) BOOL showSeperator;

@property (nonatomic,strong) AKCellLayout* cellLayout;

- (void) initContent;

- (void) customLayoutViews;

- (void) updateData;

- (void) updateDisplay;

- (void) coverScreenshotAndDelayRemoved:(UITableView *)tableView
                             cellHeight:(CGFloat)cellHeight;

@end
