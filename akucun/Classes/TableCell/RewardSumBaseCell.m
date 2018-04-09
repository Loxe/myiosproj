//
//  RewardSumBaseCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RewardSumBaseCell.h"
#import "RewardSumItemBaseCell.h"
#import "UIView+DDExtension.h"

@interface RewardSumBaseCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation RewardSumBaseCell

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
//    self.nameArray   = [NSMutableArray arrayWithArray:@[@" 待入账奖励", @" 已入账金额"]];
//    self.priceArray  = @[@0.0, @0.0];
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
    
    RewardSumItemBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RewardSumItemBaseCell" forIndexPath:indexPath];
    
    // 获取数据，并赋值
    NSNumber *price    = self.priceArray[indexPath.item];
    NSString *priceStr = [self.contentView getPriceStringNoComma:price];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
    cell.priceLabel.attributedText = attrText;
    
    NSString *name  = self.nameArray[indexPath.item];
    cell.nameLabel.text  = name;
    
    if (indexPath.item == 1) {
        cell.priceLabel.textColor = COLOR_MAIN;
        cell.nameLabel.textColor  = COLOR_MAIN;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectRewardSumBaseCellTag:)]) {
        [self.delegate didSelectRewardSumBaseCellTag:indexPath.item];
    }
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kRewardItemW, kRewardItemH);
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
        [collectionView registerClass:[RewardSumItemBaseCell class] forCellWithReuseIdentifier:@"RewardSumItemBaseCell"];
    }
    return _collectionView;
}
/*
 - (NSMutableArray *)priceArray {
 if (_priceArray == nil) {
 _priceArray = [NSMutableArray array];
 }
 return _priceArray;
 }*/

- (NSMutableArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

@end
