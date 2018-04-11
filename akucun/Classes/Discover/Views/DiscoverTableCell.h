//
//  DiscoverTableCell.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "DiscoverCellLayout.h"

@interface DiscoverTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,copy) void(^clickedImageCallback)(DiscoverTableCell* cell, NSInteger imageIndex);

@property (nonatomic,copy) void(^clickedVideoCallback)(DiscoverTableCell* cell, DiscoverData *model, UIImageView *imageView);

@property (nonatomic,copy) void(^clickedCommentCallback)(DiscoverTableCell* cell, DiscoverData *model);

@property (nonatomic,copy) void(^clickedForwardCallback)(DiscoverTableCell* cell, DiscoverData *model);

@property (nonatomic,copy) void(^clickedSaveCallback)(DiscoverTableCell* cell, DiscoverData *model);

@property (nonatomic,copy) void(^clickedOpenCallback)(DiscoverTableCell* cell, DiscoverData *model, BOOL open);

@end
