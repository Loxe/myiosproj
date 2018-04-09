//
//  MeOrderCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeOrderCellDelegate <NSObject>

- (void)didSelectMeOrderCellTag:(NSInteger)index;

@end

@interface MeOrderCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *btnTitleArray;

@property(nonatomic, strong) NSMutableArray *btnImgArray;

@property (nonatomic, weak) id <MeOrderCellDelegate> delegate;

@property(nonatomic, strong) NSArray *countArray;

- (void)showGuideAt:(NSInteger)index;

@end
