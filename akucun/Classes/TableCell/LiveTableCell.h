//
//  LiveTableCell.h
//  akucun
//
//  Created by Jarry on 2017/7/1.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "YugaoCellLayout.h"

@interface LiveTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic, assign) BOOL showPinpai;

@property (nonatomic,copy) void(^clickedImageCallback)(LiveTableCell* cell, NSInteger imageIndex);

@property (nonatomic,copy) void(^clickedForwardCallback)(LiveTableCell* cell, LiveInfo *model);

@property (nonatomic,copy) void(^clickedPinpaiCallback)(LiveTableCell* cell, LiveInfo *model);

@property (nonatomic,copy) void(^clickedOpenCallback)(LiveTableCell* cell, BOOL isOpen);

@end
