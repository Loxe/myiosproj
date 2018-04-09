//
//  MeSaleCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleH         15.0
#define kPriceH         30.0
#define kItemMargin     30.0
//#define kItemW          (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kItemMargin)/3
#define kItemH          kPriceH+kTitleH+0.5*kOFFSET_SIZE
#define kItemW          SCREEN_WIDTH/3

@protocol MeSaleCellDelegate <NSObject>

- (void)didSelectMeSaleCellTag:(NSInteger)index;

@end

@interface MeSaleCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *priceArray;

@property(nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, weak) id <MeSaleCellDelegate> delegate;

@end
