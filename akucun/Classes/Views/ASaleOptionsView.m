//
//  ASaleOptionsView.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleOptionsView.h"
#import "NSString+akucun.h"

static NSString *const cellId = @"ASaleOptionsCell";

@interface ASaleOptionsView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *despLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@interface ASaleOptionsCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ASaleOptionsView

- (instancetype) initWithFrame:(CGRect)frame options:(NSArray *)options
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    
    _options = options;
    self.selectIndex = -1;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.despLabel];
    [self addSubview:self.collectionView];

    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    CGSize size = [@"Text" sizeWithMaxWidth:SCREEN_WIDTH andFont:[FontUtils normalFont]];
    self.height = size.height + offset * 2 + self.collectionView.height + 10.0f;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, kPIXEL_WIDTH)];
    lineView.backgroundColor = COLOR_SEPERATOR_LINE;
    [self addSubview:lineView];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-kPIXEL_WIDTH, SCREEN_WIDTH, kPIXEL_WIDTH)];
    lineView.backgroundColor = COLOR_SEPERATOR_LINE;
    [self addSubview:lineView];
    
    return self;
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void) setDespTitle:(NSString *)despTitle
{
    _despTitle = despTitle;
    self.despLabel.text = despTitle;
    [self.despLabel sizeToFit];
}

- (void) setOptions:(NSArray *)options
{
    _options = options;
    
    self.selectIndex = -1;
    
    self.despLabel.textColor = RED_COLOR;
    self.despLabel.text = self.despTitle;
    [self.despLabel sizeToFit];
    
    [self.collectionView reloadData];
}

- (void) selectItem:(NSInteger)index
{
    self.despLabel.textColor = COLOR_SELECTED;
    if (self.despOptions && index <= self.despOptions.count) {
        self.despLabel.text = self.despOptions[index];
        [self.despLabel sizeToFit];
    }
    else {
        self.despLabel.text = @"";
    }
    
    self.selectIndex = index;
    if (self.selectBlock) {
        self.selectBlock((int)index);
    }
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.titleLabel.top = offset;
    self.titleLabel.left = kOFFSET_SIZE;
    
    self.despLabel.top = offset;
    self.despLabel.right = self.width - kOFFSET_SIZE;
    
    self.collectionView.top = self.titleLabel.bottom + 10.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Views

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.textColor = COLOR_TEXT_DARK;
        _titleLabel.font = [FontUtils smallFont];
    }
    return _titleLabel;
}

- (UILabel *) despLabel
{
    if (!_despLabel) {
        _despLabel  = [[UILabel alloc] init];
        _despLabel.backgroundColor = CLEAR_COLOR;
        _despLabel.textColor = RED_COLOR;
        _despLabel.font = [FontUtils smallFont];
    }
    return _despLabel;
}

- (UICollectionView *) collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = (self.width - kOFFSET_SIZE * 4) / 3.0f - 4.0f;
        layout.itemSize = CGSizeMake(width, 30);
        
        CGFloat count = ceilf(self.options.count/3.0f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, self.width-kOFFSET_SIZE*2, 30*count+(count-1)*10.0f) collectionViewLayout:layout];
        _collectionView.backgroundColor = CLEAR_COLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_collectionView registerClass:[ASaleOptionsCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.options.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASaleOptionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = self.options[indexPath.row];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == indexPath.row) {
        return;
    }
    
    self.despLabel.textColor = COLOR_SELECTED;
    if (self.despOptions && indexPath.row <= self.despOptions.count) {
        self.despLabel.text = self.despOptions[indexPath.row];
        [self.despLabel sizeToFit];
    }
    else {
        self.despLabel.text = @"";
    }
    
    self.selectIndex = indexPath.row;
    if (self.selectBlock) {
        self.selectBlock((int)indexPath.row);
    }
    
    //    ModbusCollectionCell *cell = (ModbusCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = COLOR_APP_GREEN;
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    ModbusCollectionCell *cell = (ModbusCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = CLEAR_COLOR;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// 行的间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

// 列间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kOFFSET_SIZE;
}

@end

@implementation ASaleOptionsCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = CLEAR_COLOR;
    self.contentView.backgroundColor = COLOR_BG_LIGHTGRAY;
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2.0f;
    
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.font = [FontUtils smallFont];
    _textLabel.textColor = COLOR_TEXT_NORMAL;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_textLabel];
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.width = self.width;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.contentView.backgroundColor = selected ? COLOR_SELECTED : COLOR_BG_LIGHTGRAY;
    self.textLabel.textColor = selected ? WHITE_COLOR : COLOR_TEXT_NORMAL;
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.textLabel.textColor = highlighted ? RED_COLOR : COLOR_TEXT_NORMAL;
}

@end
