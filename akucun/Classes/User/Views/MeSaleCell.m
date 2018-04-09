//
//  MeSaleCell.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MeSaleCell.h"
#import "SaleCollectionCell.h"
#import "UIView+DDExtension.h"
#import "UserManager.h"

@interface MeSaleCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UIPageControl *pageControl;

@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UIButton *leftButton;

@end

@implementation MeSaleCell

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
    self.nameArray   = [NSMutableArray arrayWithArray:@[@" 今日销售额", @" 今日代购费", @" 本月代购费",@" 本月销售额", @" 上月销售额", @" 上月代购费"]];
    self.priceArray  = @[@0.0, @0.0, @0.0, @0.0, @0.0, @0.0];
}

- (void)setupUI {
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@10);
    }];
    
    self.leftButton.hidden = YES;
    [self.contentView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.equalTo(@12);
    }];
    
    self.rightButton.hidden = NO;
    [self.contentView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.width.equalTo(@12);
    }];
}

- (IBAction) leftAction:(id)sender
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height);
    [self.collectionView scrollRectToVisible:rect animated:YES];
}
- (IBAction) rightAction:(id)sender
{
    CGRect rect = CGRectMake(self.width, 0, self.width, self.height);
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

- (void) pageClicked:(UIPageControl*)sender
{
    CGRect rect = CGRectMake(sender.currentPage * self.width, 0, self.width, self.height);
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

/*
- (NSString *) getPriceString:(NSNumber*)price
{
    NSString *priceStr = @"";
    CGFloat value = price.integerValue / 100.0f;
    if (value > 9) {
        priceStr = FORMAT(@"¥ %.0f ", value);
    }
    else {
        priceStr = FORMAT(@"¥ %.1f ", value);
    }
    return priceStr;
}*/

#pragma mark collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SaleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SaleCollectionCell" forIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor orangeColor];
    
//    if ([UserManager isPrimaryAccount]) {
        cell.priceLabel.font = SYSTEMFONT(25);
        // 获取数据，并赋值
        NSNumber *price = self.priceArray[indexPath.item];
        NSString *priceStr = [self getPriceString:price];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
        cell.priceLabel.attributedText = attrText;
//    }
//    else {
//        cell.priceLabel.font = SYSTEMFONT(40);
//        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@"***"];
//        cell.priceLabel.attributedText = attrText;
//    }
    
    NSString *name  = self.nameArray[indexPath.item];
    cell.nameLabel.text  = name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectMeSaleCellTag:)]) {
        [self.delegate didSelectMeSaleCellTag:indexPath.item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > SCREEN_WIDTH*0.5) {
        self.pageControl.currentPage = 1;
        self.leftButton.hidden = NO;
        self.rightButton.hidden = YES;
    } else {
        self.pageControl.currentPage = 0;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = NO;
    }
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(kItemW, kItemH);
//        flowLayout.minimumLineSpacing      = kOFFSET_SIZE;
//        flowLayout.minimumInteritemSpacing = kItemMargin;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, kOFFSET_SIZE, 0);
        flowLayout.itemSize = CGSizeMake(kItemW, kItemH);
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
        
        collectionView.pagingEnabled = YES;
        collectionView.bounces       = NO;
        
        //注册cell
        [collectionView registerClass:[SaleCollectionCell class] forCellWithReuseIdentifier:@"SaleCollectionCell"];
    }
    return _collectionView;
}

/*
- (NSMutableArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}
 */

- (NSMutableArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
//        _pageControl.backgroundColor = [UIColor blueColor];
        _pageControl.currentPage   = 0;
        _pageControl.numberOfPages = 2;
        _pageControl.currentPageIndicatorTintColor = COLOR_MAIN;
        _pageControl.pageIndicatorTintColor        = COLOR_TEXT_LIGHT;
        [_pageControl addTarget:self action:@selector(pageClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControl;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_arrow_bg"]];
        [_leftButton setNormalImage:@"icon_arrow_left" hilighted:nil selectedImage:nil];
        
        [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.alpha = 0.8f;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_arrow_bg"]];
        [_rightButton setNormalImage:@"icon_arrow_right" hilighted:nil selectedImage:nil];
        
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.alpha = 0.8f;
    }
    return _rightButton;
}


@end
