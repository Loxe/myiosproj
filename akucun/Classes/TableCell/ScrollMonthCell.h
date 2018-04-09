//
//  ScrollMonthCell.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kMonthH         30.0
#define kYearH          20.0
#define kRedBarH        3.0
#define kMonthItemW     SCREEN_WIDTH/5
#define kMonthItemH     kMonthH+kYearH+kRedBarH

#import <UIKit/UIKit.h>

@protocol ScrollMonthCellDelegate <NSObject>

- (void)didSelectScrollMonthCellTag:(NSInteger)index;

@end

@interface ScrollMonthCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) UIView  *separateLine;

@property(nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, weak) id <ScrollMonthCellDelegate> delegate;

@end
