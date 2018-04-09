//
//  OrderProductsController.h
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "CartCellLayout.h"
#import "OrderDetailTableCell.h"
#import "MJRefresh.h"


@interface OrderProductsController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger pageNo;

- (void) refreshData;

- (void) updateDataSource:(NSArray *)products;

- (void) configureCell:(OrderDetailTableCell *)cell;
- (void) callbackWithCell:(OrderDetailTableCell *)cell;

@end
