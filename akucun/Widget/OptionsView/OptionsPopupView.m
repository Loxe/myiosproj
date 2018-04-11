//
//  OptionsPopupView.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OptionsPopupView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface OptionsPopupView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *imageUrls;

@end

@implementation OptionsPopupView

- (void) actionOK
{
    [self hide];
    
    if (self.completeBolck) {
        NSString *option = self.options[self.selectedIndex];
        self.completeBolck((int)self.selectedIndex, option);
    }
}

- (void) actionCancel
{
    [self hide];
}

- (void) show
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:(self.options.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    [self showWithBlock:^(MMPopupView *popupView, BOOL flag) {
        if (self.selectedIndex >= 0 && self.selectedIndex < self.options.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }];
}

- (instancetype) initWithTitle:(NSString *)title
                       options:(NSArray *)options
                        images:(NSArray *)images
                      selected:(NSInteger)index
{
    self.imageUrls = images;
    return [self initWithTitle:title options:options selected:index];
}

- (instancetype) initWithTitle:(NSString *)title
                       options:(NSArray *)options
                      selected:(NSInteger)index
{
    self = [super init];
    
    if ( self )
    {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeSheet;
        self.title = title;
        self.options = options;
        
        self.selectedIndex = index;

        self.backgroundColor = MMHexColor(0xCCCCCCFF);
        
        [self setupContent];
    }
    
    return self;
}

- (void) setupContent
{
    self.offset = kOFFSET_SIZE*2;

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    if ( self.title.length > 0 )
    {
        self.titleView = [UIView new];
        [self addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
        self.titleView.backgroundColor = WHITE_COLOR;
        
        CGFloat insets = kOFFSET_SIZE * 0.8f;
        self.titleLabel = [UILabel new];
        [self.titleView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(insets, insets, insets, insets));
        }];
        self.titleLabel.textColor = COLOR_TEXT_NORMAL;
        self.titleLabel.font = SYSTEMFONT(15);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = self.title;
        
        lastAttribute = self.titleView.mas_bottom;
    }
//    
    [self addSubview:self.tableView];
    NSInteger count = MIN(10, self.options.count);
    CGFloat height = kTableCellHeight * count;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lastAttribute).offset(1.0f);
        make.height.mas_equalTo(@(height));
    }];
    lastAttribute = self.tableView.mas_bottom;

    self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
    [self addSubview:self.cancelButton];
    self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
    CGFloat okHeight = isIPhoneX ? (44+kSafeAreaBottomHeight) : 60;
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(okHeight);
        make.top.equalTo(lastAttribute).offset(8.0f);
    }];
    self.cancelButton.titleLabel.font = [FontUtils buttonFont];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateDisabled];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_SELECTED forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:RED_COLOR forState:UIControlStateHighlighted];
    [self.cancelButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
    lastAttribute = self.cancelButton.mas_bottom;

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
    
}

#pragma mark - TableViewDatasouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionPopupCell * cell = [[OptionPopupCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.offset = self.offset;
    
    cell.nameLabel.text = self.options[indexPath.row];
    if (self.selectedIndex == indexPath.row) {
        cell.nameLabel.textColor = COLOR_APP_RED;
        cell.detailTextLabel.text = FA_ICONFONT_SELECT;
    }
    else {
        cell.nameLabel.textColor = COLOR_TEXT_DARK;
        cell.detailTextLabel.text = @"";
    }
    
    if (self.imageUrls) {
        cell.imageUrl = self.imageUrls[indexPath.row];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == indexPath.row) {
        return;
    }
    
    self.selectedIndex = indexPath.row;
    [self actionOK];
    
    /*
    NSMutableArray *indexPaths = [NSMutableArray array];
    if (self.selectedIndex >= 0) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    }
    
    self.selectedIndex = indexPath.row;

    [indexPaths addObject:indexPath];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
     */
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *options = self.optionsArray[tableView.tag];
//    OptionItem *item = options[indexPath.row];
//    item.isSelected = NO;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = kTableCellHeight;
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.alwaysBounceVertical = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end

@implementation OptionPopupCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = WHITE_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;
    
//    self.textLabel.backgroundColor = CLEAR_COLOR;
//    self.textLabel.textColor = COLOR_TEXT_DARK;
//    self.textLabel.font = SYSTEMFONT(15);
    
    self.detailTextLabel.backgroundColor = CLEAR_COLOR;
    self.detailTextLabel.textColor = COLOR_APP_RED;
    self.detailTextLabel.font = FA_ICONFONTSIZE(16);

    [self.contentView addSubview:self.logoImage];
    [self.contentView addSubview:self.nameLabel];

    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1 / [UIScreen mainScreen].scale)];
    seperatorLine.bottom = kTableCellHeight;
    seperatorLine.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    [self.contentView addSubview:seperatorLine];
    
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.width.height.mas_equalTo(@(26));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
    }];
    
    return self;
}

- (void) setOffset:(CGFloat)offset
{
    _offset = offset;
    /*
    [self.logoImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(offset);
        make.width.height.mas_equalTo(@(26));
    }];*/
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(offset);
    }];
}

- (void) setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;

//    MASViewAttribute *leftAttribute = self.contentView.mas_left;
    if (imageUrl && imageUrl.length > 0) {
        self.logoImage.hidden = NO;
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageDelayPlaceholder];
//        leftAttribute = self.logoImage.mas_right;
    }
    else {
        self.logoImage.hidden = YES;
        self.logoImage.image = nil;
    }
//    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(leftAttribute).offset(self.offset);
//    }];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundColor = highlighted ? RGBCOLOR(0xF0, 0xF0, 0xF0) : WHITE_COLOR;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
//    self.logoImage.frame = CGRectMake(self.offset, (self.height-26)/2.0f, 26, 26);
//    if (self.imageUrl && self.imageUrl.length > 0) {
//        self.textLabel.left = self.logoImage.right + kOFFSET_SIZE;
//    }
//    else {
//        self.textLabel.left = self.offset;
//    }
//    self.logoImage.centerY = self.centerY;
    self.detailTextLabel.right = SCREEN_WIDTH-kOFFSET_SIZE;
}

- (UIImageView *) logoImage
{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, 26, 26)];
        _logoImage.backgroundColor = WHITE_COLOR;
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.clipsToBounds = YES;
        
        _logoImage.layer.cornerRadius = 3.0f;
        _logoImage.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
        _logoImage.layer.borderWidth = kPIXEL_WIDTH;
        _logoImage.hidden = YES;
    }
    return _logoImage;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = [FontUtils normalFont];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

@end
