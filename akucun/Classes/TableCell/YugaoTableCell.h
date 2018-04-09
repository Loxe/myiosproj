//
//  YugaoTableCell.h
//  akucun
//
//  Created by Jarry on 2017/4/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "YugaoCellLayout.h"

@interface YugaoTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,copy) void(^clickedImageCallback)(YugaoTableCell* cell, NSInteger imageIndex);

@property (nonatomic,copy) void(^clickedForwardCallback)(YugaoTableCell* cell, Trailer *model);

@property (nonatomic,copy) void(^clickedOpenCallback)(YugaoTableCell* cell, BOOL isOpen);

@property (nonatomic,copy) void(^clickedPinpaiCallback)(YugaoTableCell* cell);

@end
