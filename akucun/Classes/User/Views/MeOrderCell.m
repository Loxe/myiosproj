//
//  MeOrderCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kItemWH     50
#define kItemMargin (SCREEN_WIDTH-2*kOFFSET_SIZE-5*kItemWH)/4

#import "MeOrderCell.h"
#import "OrderCollectionCell.h"
#import "WZLBadgeImport.h"

@interface MeOrderCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareData];
        [self setupUI];
    }
    return self;
}

- (void)showGuideAt:(NSInteger)index {
    
    OrderCollectionCell *cell = (OrderCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (!cell) {
        return;
    }
    
    if (index == 0) {
        [UserGuideManager createUserGuide:kUserGuideNewOrderToPay title:@"您有未支付的订单，请尽快进入完成支付\n超时未支付 系统将取消您的订单" focusedView:cell offset:10];
    }
}

- (void)prepareData {
    self.btnTitleArray   = [NSMutableArray arrayWithArray:@[@"待支付", @"待发货", @"拣货中", @"已发货", @"已取消"]];
    self.btnImgArray     = [NSMutableArray arrayWithArray:@[@"icon_dfk", @"icon_dfh", @"icon_dsh", @"icon_yfh", @"icon_cancel"]];
}

- (void)setupUI {
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.btnImgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrderCollectionCell" forIndexPath:indexPath];
    
    // 获取数据，并赋值
    UIImage  *img   = [UIImage imageNamed:self.btnImgArray[indexPath.item]];
    NSString *title = self.btnTitleArray[indexPath.item];
    [cell updateUIWith:img title:title];
    cell.badgeBgColor = COLOR_SELECTED;
    cell.badgeFont = BOLDSYSTEMFONT(11);
    cell.badgeCenterOffset = CGPointMake(-12, 3);
    NSInteger count = [self.countArray[indexPath.item] integerValue];
    if (indexPath.item == 0) {
        [cell showBadgeWithStyle:WBadgeStyleNumber value:count animationType:WBadgeAnimTypeBounce];
    } else {
        [cell showBadgeWithStyle:WBadgeStyleNumber value:count animationType:WBadgeAnimTypeNone];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectMeOrderCellTag:)]) {
        [self.delegate didSelectMeOrderCellTag:indexPath.item];
    }
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kItemWH, kItemWH);
        flowLayout.minimumLineSpacing      = kOFFSET_SIZE;
        flowLayout.minimumInteritemSpacing = kItemMargin;
        flowLayout.sectionInset = UIEdgeInsetsMake(kOFFSET_SIZE, kOFFSET_SIZE, kOFFSET_SIZE, kOFFSET_SIZE);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.frame collectionViewLayout:flowLayout];
        _collectionView = collectionView;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource      = self;
        collectionView.delegate        = self;
        collectionView.showsVerticalScrollIndicator   = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        collectionView.pagingEnabled = NO;
        collectionView.bounces       = NO;
        
        //注册cell
        [collectionView registerClass:[OrderCollectionCell class] forCellWithReuseIdentifier:@"OrderCollectionCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)btnTitleArray {
    if (_btnTitleArray == nil) {
        _btnTitleArray = [NSMutableArray array];
    }
    return _btnTitleArray;
}

- (NSMutableArray *)btnImgArray {
    if (_btnImgArray == nil) {
        _btnImgArray = [NSMutableArray array];
    }
    return _btnImgArray;
}

@end
