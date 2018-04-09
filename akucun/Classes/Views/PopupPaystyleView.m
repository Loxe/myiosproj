//
//  PopupPaystyleView.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PopupPaystyleView.h"
#import "PaystyleTableCell.h"
#import "PayType.h"

@interface PopupPaystyleView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *okButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSArray *payTypes;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation PopupPaystyleView

- (void) actionOK
{
    [self hide];
    
    PayType *payType = self.payTypes[self.selectedIndex];
    if (self.selectBlock) {
        self.selectBlock((int)payType.paytype);
    }
}

- (instancetype) initWithTitle:(NSString *)title types:(NSArray *)payTypes value:(NSInteger)value
{
    self = [super init];
    
    if ( self )
    {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeSheet;
        self.title = title;
        self.payTypes = payTypes;
        self.value = value;
        self.selectedIndex = 0;
        
        self.backgroundColor = MMHexColor(0xCCCCCCFF);
        
        [self setupContent];
    }
    
    return self;
}

- (void) setupContent
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;
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
    self.titleLabel.textColor = COLOR_SELECTED;
    self.titleLabel.font = [FontUtils bigFont];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.title;
    
    lastAttribute = self.titleView.mas_bottom;
    
    UIView *textView = [UIView new];
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lastAttribute).offset(1.0f);
    }];
    textView.backgroundColor = WHITE_COLOR;
    UILabel *textLabel = [UILabel new];
    textLabel.font = [FontUtils normalFont];
    textLabel.textColor = COLOR_TEXT_NORMAL;
    textLabel.text = @"选择支付方式：";
    [textView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textView).insets(UIEdgeInsetsMake(insets, insets, insets, insets));
    }];
    lastAttribute = textView.mas_bottom;

    //
    [self addSubview:self.tableView];
    NSInteger count = self.payTypes.count;
    CGFloat h = isPad ? kPadCellHeight : kTableCellHeight;
    CGFloat height = h * 1.5f * count;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lastAttribute).offset(.5f);
        make.height.mas_equalTo(@(height));
    }];
    lastAttribute = self.tableView.mas_bottom;
    
    self.okButton = [UIButton mm_buttonWithTarget:self action:@selector(actionOK)];
    [self addSubview:self.okButton];
    self.okButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
    CGFloat okHeight = isIPhoneX ? (44+kSafeAreaBottomHeight) : 60;
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(okHeight);
        make.top.equalTo(lastAttribute);
    }];
    self.okButton.titleLabel.font = [FontUtils buttonFont];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:COLOR_SELECTED] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:WHITE_COLOR] forState:UIControlStateDisabled];
    [self.okButton setBackgroundImage:[UIImage mm_imageWithColor:[COLOR_SELECTED colorWithAlphaComponent:0.6f]] forState:UIControlStateHighlighted];
    [self.okButton setTitle:@"确 定" forState:UIControlStateNormal];
    [self.okButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [self.okButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateHighlighted];
    [self.okButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
    lastAttribute = self.okButton.mas_bottom;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
    
    PayType *payType = self.payTypes[self.selectedIndex];
    [self.okButton setNormalTitle:FORMAT(@"%@ ¥ %ld", payType.name, (long)self.value)];
}

#pragma mark - TableViewDatasouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payTypes.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaystyleTableCell * cell = [[PaystyleTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    PayType *payType = self.payTypes[indexPath.row];
    if (payType.paytype == kPayTypeWEIXIN) {
        cell.imageView.image = IMAGENAMED(@"logo_wxpay");
        cell.textLabel.text = @"微信支付";
        cell.detailTextLabel.text = @"微信安全支付";
    }
    else if (payType.paytype == kPayTypeALIPAY) {
        cell.imageView.image = IMAGENAMED(@"logo_alipay");
        cell.textLabel.text = @"支付宝";
        cell.detailTextLabel.text = @"支付宝安全支付";
    }
    else if (payType.paytype == kPayTypeUMFWXPay) {
        cell.imageView.image = IMAGENAMED(@"logo_wxpay");
        cell.textLabel.text = payType.name;
        cell.detailTextLabel.text = payType.content;
    }
    else if (payType.paytype == kPayTypeUMFAliPay) {
        cell.imageView.image = IMAGENAMED(@"logo_alipay");
        cell.textLabel.text = payType.name;
        cell.detailTextLabel.text = payType.content;
    }
    else if (payType.paytype == kPayTypeUMFChinaUnionPay) {
        cell.imageView.image = IMAGENAMED(@"logo_umpay");
        cell.textLabel.text = payType.name;
        cell.detailTextLabel.text = payType.content;
    }
    else {
        cell.textLabel.text = payType.name;
    }

    cell.checked = (indexPath.row == self.selectedIndex);

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TableCellBase *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionDisabled) {
        return;
    }
    
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
    PayType *payType = self.payTypes[indexPath.row];
    [self.okButton setNormalTitle:FORMAT(@"%@ ¥ %ld", payType.name, (long)self.value)];
    /*
    */
}

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
        _tableView.rowHeight = height * 1.5f;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.alwaysBounceVertical = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
