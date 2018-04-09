//
//  CorpTableCell.h
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "CorpCellLayout.h"

@interface CorpTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,copy) void(^clickedImageCallback)(CorpTableCell* cell, NSInteger imageIndex);

@property (nonatomic,copy) void(^clickedForwardCallback)(CorpTableCell* cell, CorpInfo *model);

@property (nonatomic,copy) void(^clickedOpenCallback)(CorpTableCell* cell, BOOL isOpen);

@end
