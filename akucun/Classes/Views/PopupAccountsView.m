//
//  PopupAccountsView.m
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "PopupAccountsView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OptionAccountCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImage;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *primaryLabel;

@property (nonatomic, strong) UIView *seperatorLine;

@property (nonatomic, strong) SubUser *account;

@end

@interface PopupAccountsView () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _rowHeight;
}

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *options;

@end

@implementation PopupAccountsView

- (void) actionCanel
{
    [self hide];
}

- (instancetype) initWithTitle:(NSString *)title
                      accounts:(NSArray *)accounts
{
    self = [super init];
    if (self)
    {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeSheet;
        self.title = title;
        self.options = accounts;
        
        self.backgroundColor = MMHexColor(0xCCCCCCFF);
        
        [self setupContent];
    }
    
    return self;
}

- (void) setupContent
{
//    self.offset = kOFFSET_SIZE*2;
    
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
    NSInteger count = self.options.count;
    CGFloat height = _rowHeight * count;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lastAttribute).offset(1.0f);
        make.height.mas_equalTo(@(height));
    }];
    lastAttribute = self.tableView.mas_bottom;
    
    self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCanel)];
    [self addSubview:self.cancelButton];
    self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
    CGFloat btnHeight = isIPhoneX ? (44+kSafeAreaBottomHeight) : 60;
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(btnHeight);
        make.top.equalTo(lastAttribute).offset(8.0f);
    }];
    self.cancelButton.titleLabel.font = [FontUtils buttonFont];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateDisabled];
    [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xEFEDE7FF)] forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
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
    OptionAccountCell * cell = [[OptionAccountCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.account = self.options[indexPath.row];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSMutableArray *indexPaths = [NSMutableArray array];
    if (self.selectedIndex >= 0) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    }
    
    self.selectedIndex = indexPath.row;
    self.okButton.enabled = (self.selectedIndex >= 0);
    
    [indexPaths addObject:indexPath];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
     */
    
    [self hide];
    if (self.completeBolck) {
        SubUser *item = self.options[indexPath.row];
        self.completeBolck((int)indexPath.row, item);
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rowHeight = kTableCellHeight*1.2;
        _tableView.rowHeight = _rowHeight;
        //        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.alwaysBounceVertical = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end

@implementation OptionAccountCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = WHITE_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;
    self.textLabel.backgroundColor = CLEAR_COLOR;
    self.textLabel.textColor = COLOR_TEXT_DARK;
    self.textLabel.font = SYSTEMFONT(15);
    
    self.detailTextLabel.backgroundColor = CLEAR_COLOR;
    self.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
    self.detailTextLabel.font = SYSTEMFONT(11);
    
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1 / [UIScreen mainScreen].scale)];
    seperatorLine.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    [self.contentView addSubview:seperatorLine];
    self.seperatorLine = seperatorLine;
    
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.primaryLabel];

    return self;
}

- (void) setAccount:(SubUser *)account
{
    _account = account;
    
    if (account.avatar && account.avatar.length > 0) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:nil options:SDWebImageDelayPlaceholder];
    }
    else {
        self.avatarImage.image = IMAGENAMED(@"userAvator");
    }
    self.textLabel.text = account.subusername;
    self.detailTextLabel.text = [account.shoujihao displayMobile];
    
    if (account.islogin) {
        self.statusLabel.hidden = NO;
        self.statusLabel.text = FORMAT(@"[%@已登录]", account.devicename);
        [self.statusLabel sizeToFit];
    }
    else {
        self.statusLabel.hidden = YES;
    }
    
    self.primaryLabel.hidden = ![account isPrimaryAccount];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundColor = highlighted ? RGBCOLOR(0xF0, 0xF0, 0xF0) : WHITE_COLOR;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarImage.centerY = self.height/2.0f;
    self.seperatorLine.bottom = self.height;
    
    self.textLabel.top = self.avatarImage.top;
    self.textLabel.left = self.avatarImage.right + kOFFSET_SIZE;
    self.detailTextLabel.left = self.textLabel.left;
    self.detailTextLabel.bottom = self.avatarImage.bottom;
    
    self.primaryLabel.centerY = self.textLabel.centerY;
    self.primaryLabel.left = self.textLabel.right + 5;
    
    self.statusLabel.top = self.detailTextLabel.top;
    self.statusLabel.left = self.detailTextLabel.right + 10;
}

- (UIImageView *) avatarImage
{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, 36, 36)];
        _avatarImage.backgroundColor = COLOR_BG_LIGHT;
        _avatarImage.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.userInteractionEnabled = YES;
        
        _avatarImage.layer.cornerRadius = 18.0f;
//        _avatarImage.layer.borderColor = COLOR_SEPERATOR_LIGHT.CGColor;
//        _avatarImage.layer.borderWidth = kPIXEL_WIDTH;
    }
    return _avatarImage;
}

- (UILabel *) statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.textColor = COLOR_TEXT_NORMAL;
        _statusLabel.font = SYSTEMFONT(11);
        _statusLabel.text = @"[iPhone6 已登录]";
        [_statusLabel sizeToFit];
    }
    return _statusLabel;
}

- (UILabel *) primaryLabel
{
    if (_primaryLabel == nil) {
        _primaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 15)];
        _primaryLabel.backgroundColor     = COLOR_MAIN;
        _primaryLabel.layer.cornerRadius  = 4.0;
        _primaryLabel.layer.masksToBounds = YES;
        _primaryLabel.textColor = WHITE_COLOR;
        _primaryLabel.font      = BOLDSYSTEMFONT(9);
        _primaryLabel.textAlignment = NSTextAlignmentCenter;
        _primaryLabel.text = @"主账号";
    }
    return _primaryLabel;
}

@end
