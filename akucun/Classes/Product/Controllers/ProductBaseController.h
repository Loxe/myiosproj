//
//  ProductBaseController.h
//  akucun
//
//  Created by Jarry on 2017/8/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductsManager.h"
#import "CommentView.h"
#import "ProductTableCell.h"

@interface ProductBaseController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) BOOL isImageBrowser;

//@property (nonatomic, strong) CommentView *commentView;
@property (nonatomic, strong) NSIndexPath *clickedIndexPath;

//- (void) forwardAction:(ProductModel *)product checked:(BOOL)checked updated:(idBlock)updatedBlock;

- (void) buyProduct:(ProductModel *)product sku:(ProductSKU *)sku finished:(idBlock)finishedBlock;

- (void) productFollowCancelled:(ProductModel *)product index:(NSIndexPath *)indexPath;

//- (void) commentAction:(ProductModel *)product;
//- (void) hideCommentView;

//- (void) cancelComment:(Comment *)comment product:(ProductModel *)product finished:(idBlock)finishedBlock;

- (void) updateRowAtIndex:(NSIndexPath *)indexPath model:(ProductModel *)model;

- (void) configueCell:(ProductTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end
