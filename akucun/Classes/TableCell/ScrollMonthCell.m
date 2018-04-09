//
//  ScrollMonthCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ScrollMonthCell.h"
#import "MonthCollectionCell.h"

@interface ScrollMonthCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, assign) NSInteger chooseIndex;

@end

@implementation ScrollMonthCell

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
}

- (void)setupUI {
    
    self.chooseIndex = 0;
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.monthArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MonthCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MonthCollectionCell" forIndexPath:indexPath];
    NSString *dateStr = self.monthArray[indexPath.item];
    if (dateStr.length > 0) {
        cell.yearLabel.text  = [dateStr componentsSeparatedByString:@"-"][0];
        NSString *month = [dateStr componentsSeparatedByString:@"-"][1];
        cell.monthLabel.text = [NSString stringWithFormat:@"%@ 月",month];
    } else {
        NSLog(@"未取到数据");
    }
    
    if (indexPath.item == self.chooseIndex) {
        cell.isChoosed = YES;
    } else {
        cell.isChoosed = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.chooseIndex = indexPath.item;
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didSelectScrollMonthCellTag:)]) {
        [self.delegate didSelectScrollMonthCellTag:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kMonthItemW, kMonthItemH);
        flowLayout.minimumLineSpacing      = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
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
        [collectionView registerClass:[MonthCollectionCell class] forCellWithReuseIdentifier:@"MonthCollectionCell"];
    }
    return _collectionView;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _separateLine;
}

- (NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}


@end
