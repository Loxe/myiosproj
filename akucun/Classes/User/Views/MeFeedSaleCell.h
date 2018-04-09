//
//  MeFeedSaleCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeFeedSaleCellDelegate <NSObject>

- (void)didSelectMeFeedSaleCellTag:(NSInteger)index;

@end

@interface MeFeedSaleCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *countArray;

@property(nonatomic, strong) NSArray *nameArray;

@property (nonatomic, weak) id <MeFeedSaleCellDelegate> delegate;

@end
