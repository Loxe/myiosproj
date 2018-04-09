//
//  RewardSumBaseCell.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kTitleH         15.0
#define kPriceH         30.0
#define kItemMargin     30.0
#define kRewardItemW    (SCREEN_WIDTH-2*kOFFSET_SIZE-kItemMargin)/2
#define kRewardItemH    kPriceH+kTitleH+0.5*kOFFSET_SIZE

#import <UIKit/UIKit.h>

@protocol RewardSumBaseCellDelegate <NSObject>

@optional
- (void)didSelectRewardSumBaseCellTag:(NSInteger)index;

@end


@interface RewardSumBaseCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *priceArray;

@property(nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, weak) id <RewardSumBaseCellDelegate> delegate;

@end
