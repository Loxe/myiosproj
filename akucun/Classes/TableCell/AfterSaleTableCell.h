//
//  AfterSaleTableCell.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, eAfterSaleType)
{
    ASaleTypeAll = 0 ,
    ASaleTypeQuehuo = 1 ,
    ASaleTypeCancel ,
    ASaleTypeTuihuo ,
    ASaleTypeYituihuo ,
    ASaleTypeList = 100
};

@interface AfterSaleTableCell : UITableViewCell

@property (nonatomic, copy) intBlock selectBlock;

- (void) setOrderCount1:(NSInteger)count1
                 count2:(NSInteger)count2
                 count3:(NSInteger)count3
                 count4:(NSInteger)count4
                 count5:(NSInteger)count5;

@end
