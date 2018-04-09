//
//  ProductTableCell.h
//  akucun
//
//  Created by Jarry on 2017/3/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKTableViewCell.h"
#import "ProductCellLayout.h"

@interface ProductTableCell : AKTableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,assign) BOOL hideForward;

@property (nonatomic,copy) void(^clickedImageCallback)(ProductTableCell* cell, NSInteger imageIndex);

@property (nonatomic,copy) void(^clickedAvatarCallback)(ProductTableCell* cell, ProductModel *model);

@property (nonatomic,copy) void(^clickedMenuCallback)(ProductTableCell* cell);

//@property (nonatomic,copy) void(^clickedCommentCallback)(ProductTableCell* cell, ProductModel *model);
//@property (nonatomic,copy) void(^clickedCancelCallback)(ProductTableCell* cell, ProductModel *model, Comment *comment);

@property (nonatomic,copy) void(^clickedForwardCallback)(ProductTableCell* cell, ProductModel *model);

@property (nonatomic,copy) void(^clickedBuyCallback)(ProductTableCell* cell, ProductModel *model, ProductSKU *sku);

@property (nonatomic,copy) void(^clickedFollowCallback)(ProductTableCell* cell, ProductModel *model);

@property (nonatomic,copy) void(^clickedKefuCallback)(ProductTableCell* cell, ProductModel *model);

//- (void) hideMenu;


@end
