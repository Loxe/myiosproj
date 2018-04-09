//
//  MyOrderTableCell.h
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TableCellBase.h"

typedef NS_ENUM(int, eOrderType)
{
    OrderTypeAll = 0 ,
    OrderTypeDaifukuan = 1 ,
    OrderTypeDaifahuo ,
    OrderTypeJianhuo ,
    OrderTypeYifahuo ,
    OrderTypeCanceled
};

@interface MyOrderTableCell : UITableViewCell

@property (nonatomic, copy) intBlock selectBlock;

- (void) setOrderCount1:(NSInteger)count1
                 count2:(NSInteger)count2
                 count3:(NSInteger)count3
                 count4:(NSInteger)count4
                 count5:(NSInteger)count5;

@end
