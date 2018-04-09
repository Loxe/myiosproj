//
//  MeFeedSaleCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kItemWH     50
#define kItemMargin (SCREEN_WIDTH-2*kOFFSET_SIZE-5*kItemWH)/4

#import "MeFeedSaleCell.h"
#import "FeedSaleCollectionCell.h"

@interface MeFeedSaleCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MeFeedSaleCell

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

- (void)prepareData {
    self.nameArray = @[@"平台缺货", @"用户取消", @"退货中", @"已退货", @"售后记录"];
    self.countArray  = @[@0, @0, @0, @1, @1];
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
    return self.nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedSaleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedSaleCollectionCell" forIndexPath:indexPath];
    
    // 获取数据，并赋值
    NSNumber *count = self.countArray[indexPath.item];
    NSString *name  = self.nameArray[indexPath.item];
    cell.countLabel.text = [count stringValue];
    cell.nameLabel.text  = name;
    
    cell.countLabel.textColor = (count.integerValue > 0) ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectMeFeedSaleCellTag:)]) {
        [self.delegate didSelectMeFeedSaleCellTag:indexPath.item];
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
        [collectionView registerClass:[FeedSaleCollectionCell class] forCellWithReuseIdentifier:@"FeedSaleCollectionCell"];
    }
    return _collectionView;
}

- (NSArray *)countArray {
    if (_countArray == nil) {
        _countArray = [NSArray array];
    }
    return _countArray;
}

- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = [NSArray array];
    }
    return _nameArray;
}

@end
