//
//  LogisticsTransferCell.m
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LogisticsTransferCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LogisticsTransferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.brandImageView];
    [self.contentView addSubview:self.brandLabel];

    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
    CGFloat offset = kOFFSET_SIZE;
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(self.contentView).offset(offset);
        make.centerY.equalTo(self.brandLabel);
    }];
    
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.brandImageView.mas_right).offset(offset*0.5);
        make.height.equalTo(@(height));
    }];
    
    [self.contentView addSubview:self.totalCountLabel];
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brandLabel);
        make.right.equalTo(self.contentView).offset(-offset);
        make.height.equalTo(@(height));
    }];
    
    UIView *line1 = [self separateLine];
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(height);
        make.left.equalTo(self.brandImageView);
        make.width.equalTo(@(SCREEN_WIDTH-offset));
        make.height.equalTo(@(kPIXEL_WIDTH));
    }];

    [self.contentView addSubview:self.orderNumberTitle];
    [self.orderNumberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self.contentView).offset(offset);
        make.height.equalTo(@(height));
    }];
    
    [self.contentView addSubview:self.orderNumberLabel];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumberTitle);
        make.left.equalTo(self.orderNumberTitle.mas_right);
        make.height.equalTo(@(height));
    }];
    
    UIView *line2 = [self separateLine];
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(height*2);
        make.left.equalTo(self.orderNumberTitle);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(kPIXEL_WIDTH));
    }];
    
    [self.contentView addSubview:self.sendTimeTitle];
    [self.sendTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom);
        make.left.equalTo(self.contentView).offset(offset);
        make.height.equalTo(@(height));
    }];
    
    [self.contentView addSubview:self.sendTimeLabel];
    [self.sendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendTimeTitle);
        make.left.equalTo(self.sendTimeTitle.mas_right);
        make.height.equalTo(@(height));
    }];
}

- (void) setAdOrder:(AdOrder *)adOrder
{
    _adOrder = adOrder;
    
    self.brandLabel.text = adOrder.pinpai;
    self.sendTimeLabel.text = adOrder.optime;
    self.sendTimeTitle.text = @"发货时间：";
    self.orderNumberTitle.text = @"发货单号：";
    self.orderNumberLabel.text = adOrder.odorderstr;

    if (adOrder.substatu > 1 && adOrder.pnum > 0) {
        self.totalCountLabel.text = FORMAT(@"共 %ld 件", (long)adOrder.pnum);
    }
    else {
        self.totalCountLabel.text = @"";
    }
    
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:adOrder.pinpaiURL] placeholderImage:nil options:SDWebImageDelayPlaceholder];
}

- (void) setOrder:(OrderModel *)order
{
    _order = order;
    
    self.brandLabel.text = order.pinpai;
    self.sendTimeLabel.text = order.dingdanshijian;
    self.sendTimeTitle.text = @"下单时间：";
    self.orderNumberTitle.text = @"订单编号：";
    self.orderNumberLabel.text = order.displayOrderId;

    self.totalCountLabel.text = @"";
//    self.totalCountLabel.text = FORMAT(@"共 %ld 件", (long)order.shangpinjianshu);

    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:order.pinpaiURL] placeholderImage:nil options:SDWebImageDelayPlaceholder];
}

#pragma mark lazy
- (UIImageView *)brandImageView {
    if (_brandImageView == nil) {
        _brandImageView = [[UIImageView alloc]init];
        _brandImageView.image = [UIImage imageNamed:@"logo"];
        _brandImageView.clipsToBounds = YES;
        _brandImageView.layer.cornerRadius = 3.0f;
    }
    return _brandImageView;
}

- (UILabel *)brandLabel {
    
    if (_brandLabel == nil) {
        _brandLabel = [[UILabel alloc]init];
        _brandLabel.text = @"品牌名称";
        _brandLabel.font = [FontUtils normalFont];
        _brandLabel.textAlignment = NSTextAlignmentLeft;
        _brandLabel.textColor = COLOR_TEXT_DARK;
    }
    return _brandLabel;
}

- (UILabel *)totalCountLabel {
    
    if (_totalCountLabel == nil) {
        _totalCountLabel = [[UILabel alloc]init];
        _totalCountLabel.text = @"共 -- 件";
        _totalCountLabel.font = [FontUtils normalFont];
        _totalCountLabel.textAlignment = NSTextAlignmentRight;
        _totalCountLabel.textColor = COLOR_TEXT_DARK;
    }
    return _totalCountLabel;
}

- (UILabel *)orderNumberTitle {
    
    if (_orderNumberTitle == nil) {
        _orderNumberTitle = [[UILabel alloc]init];
        _orderNumberTitle.text = @"发货单号：";
        _orderNumberTitle.font = [FontUtils normalFont];
        _orderNumberTitle.textAlignment = NSTextAlignmentLeft;
        _orderNumberTitle.textColor = COLOR_TEXT_NORMAL;
    }
    return _orderNumberTitle;
}

- (UILabel *)orderNumberLabel {
    
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc]init];
        _orderNumberLabel.text = @"";
        _orderNumberLabel.font = [FontUtils normalFont];
        _orderNumberLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumberLabel.textColor = COLOR_TEXT_DARK;
    }
    return _orderNumberLabel;
}

- (UILabel *)sendTimeTitle {
    
    if (_sendTimeTitle == nil) {
        _sendTimeTitle = [[UILabel alloc]init];
        _sendTimeTitle.text = @"发货时间：";
        _sendTimeTitle.font = [FontUtils normalFont];
        _sendTimeTitle.textAlignment = NSTextAlignmentLeft;
        _sendTimeTitle.textColor = COLOR_TEXT_NORMAL;
    }
    return _sendTimeTitle;
}

- (UILabel *)sendTimeLabel {
    
    if (_sendTimeLabel == nil) {
        _sendTimeLabel = [[UILabel alloc]init];
        _sendTimeLabel.text = @"";
        _sendTimeLabel.font = [FontUtils normalFont];
        _sendTimeLabel.textAlignment = NSTextAlignmentLeft;
        _sendTimeLabel.textColor = COLOR_TEXT_DARK;
    }
    return _sendTimeLabel;
}

//分割线
- (UIView *) separateLine
{
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE, 1.0f)];
    separateLine.backgroundColor = COLOR_SEPERATOR_LIGHT;
    return separateLine;
}

@end
