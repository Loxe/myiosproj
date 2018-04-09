//
//  ASaleStepView.m
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleStepView.h"

@interface ASaleStepView ()
{
    CGFloat _lineWidth;
    CGFloat _iconWidth;
}

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *stepIcon1, *stepIcon2, *stepIcon3, *stepIcon4;
@property (nonatomic, strong) UILabel *stepLabel1, *stepLabel2, *stepLabel3, *stepLabel4;
@property (nonatomic, strong) UIView *stepLine1, *stepLine2, *stepLine3;

@property (nonatomic, strong) UILabel *wuliuLabel;

@end

@implementation ASaleStepView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    
    _iconWidth = 26.0f;
    _lineWidth = (SCREEN_WIDTH - kOFFSET_SIZE*4 - (_iconWidth+20)*4)/ 3.0f;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.wuliuLabel];

    self.stepIcon1 = [self iconLabel];
    [self addSubview:self.stepIcon1];
    self.stepIcon2 = [self iconLabel];
    [self addSubview:self.stepIcon2];
    self.stepIcon3 = [self iconLabel];
    [self addSubview:self.stepIcon3];
    self.stepIcon4 = [self iconLabel];
    [self addSubview:self.stepIcon4];
    
    self.stepLabel1 = [self stepLabel];
    [self setStepText:self.stepLabel1 text:@"提交申请" color:COLOR_APP_GREEN];
    [self addSubview:self.stepLabel1];
    self.stepLabel2 = [self stepLabel];
    [self setStepText:self.stepLabel2 text:@"爱库存售后\n审核" color:RED_COLOR];
    [self addSubview:self.stepLabel2];
    self.stepLabel3 = [self stepLabel];
    [self addSubview:self.stepLabel3];
    self.stepLabel4 = [self stepLabel];
    [self addSubview:self.stepLabel4];
    
    self.stepLine1 = [self lineView];
    [self addSubview:self.stepLine1];
    self.stepLine2 = [self lineView];
    [self addSubview:self.stepLine2];
    self.stepLine3 = [self lineView];
    [self addSubview:self.stepLine3];

    return self;
}

- (void) setAsaleService:(ASaleService *)asaleService
{
    _asaleService = asaleService;
    
    self.actionButton.hidden = YES;
    self.wuliuLabel.hidden = YES;
    
    self.stepIcon1.hidden = NO;
    self.stepIcon2.hidden = NO;
    self.stepIcon3.hidden = YES;
    self.stepIcon4.hidden = YES;
    self.stepLine1.hidden = NO;
    self.stepLine2.hidden = YES;
    self.stepLine3.hidden = YES;
    [self setStepIcon:self.stepIcon1 icon:kIconChecked];
    [self setStepText:self.stepLabel3 text:@"" color:RED_COLOR];
    [self setStepText:self.stepLabel4 text:@"" color:RED_COLOR];

    [self setStepIcon:self.stepIcon2 icon:kIconChecked];
    [self setStepText:self.stepLabel2 text:@"爱库存售后\n审核" color:COLOR_APP_GREEN];
    self.stepLine1.backgroundColor = COLOR_APP_GREEN;

    if (asaleService.chulizhuangtai == ASaleStatusRejected) {
        self.detailLabel.text = @"您的售后申请审核未通过";
        [self.detailLabel sizeToFit];
        
        self.stepLine1.backgroundColor = RED_COLOR;
        [self setStepIcon:self.stepIcon2 icon:kIconClose];
        [self setStepText:self.stepLabel2 text:@"爱库存售后\n拒绝" color:RED_COLOR];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusSubmit) {
        self.stepLine1.backgroundColor = RED_COLOR;
        [self setStepIcon:self.stepIcon2 icon:nil];
        [self setStepText:self.stepLabel2 text:@"爱库存售后\n审核" color:RED_COLOR];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusPending) {

        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = RED_COLOR;
        
        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:nil];
        [self setStepText:self.stepLabel3 text:@"售后处理中" color:RED_COLOR];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusTuihuoPending) {
        self.detailLabel.text = @"退货处理中";
        [self.detailLabel sizeToFit];

        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = RED_COLOR;
        
        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:nil];
        [self setStepText:self.stepLabel3 text:@"退货处理中" color:RED_COLOR];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusLoufaBufa) {
        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = COLOR_APP_GREEN;
        
        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:kIconChecked];
        [self setStepText:self.stepLabel3 text:@"已补发" color:COLOR_APP_GREEN];
        
        self.detailLabel.text = @"货品已补发";
        [self.detailLabel sizeToFit];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusLoufaTuikuan) {
        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = COLOR_APP_GREEN;
        
        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:kIconChecked];
        [self setStepText:self.stepLabel3 text:@"已退款" color:COLOR_APP_GREEN];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusTuihuoBufa) {

        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = COLOR_APP_GREEN;
        self.stepLine3.hidden = NO;
        self.stepLine3.backgroundColor = COLOR_APP_GREEN;

        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:kIconChecked];
        [self setStepText:self.stepLabel3 text:@"退回货品" color:COLOR_APP_GREEN];

        self.stepIcon4.hidden = NO;
        [self setStepIcon:self.stepIcon4 icon:kIconChecked];
        [self setStepText:self.stepLabel4 text:@"已补发" color:COLOR_APP_GREEN];
        
        self.detailLabel.text = @"货品已补发";
        [self.detailLabel sizeToFit];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusTuihuoTuikuan) {
        
        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = COLOR_APP_GREEN;
        self.stepLine3.hidden = NO;
        self.stepLine3.backgroundColor = COLOR_APP_GREEN;
        
        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:kIconChecked];
        [self setStepText:self.stepLabel3 text:@"退回货品" color:COLOR_APP_GREEN];
        
        self.stepIcon4.hidden = NO;
        [self setStepIcon:self.stepIcon4 icon:kIconChecked];
        [self setStepText:self.stepLabel4 text:@"已退款" color:COLOR_APP_GREEN];
    }
    else if (asaleService.chulizhuangtai == ASaleStatusCanceled) {
        self.stepLine2.hidden = NO;
        self.stepLine2.backgroundColor = COLOR_APP_GREEN;
        
        self.stepIcon3.hidden = NO;
        [self setStepIcon:self.stepIcon3 icon:kIconClose];
        self.stepIcon3.textColor = COLOR_TEXT_NORMAL;
        self.stepIcon3.layer.borderColor = COLOR_TEXT_NORMAL.CGColor;
        [self setStepText:self.stepLabel3 text:@"已撤销" color:COLOR_TEXT_NORMAL];
        
        self.detailLabel.textColor = COLOR_TEXT_NORMAL;
        self.detailLabel.text = @"售后申请已撤销";
        [self.detailLabel sizeToFit];
    }

    if (asaleService.servicetype <= 2) {
        //
        if (asaleService.chulizhuangtai == ASaleStatusSubmit) {           self.detailLabel.text = @"漏发申请已提交, 客服审核中";
            [self.detailLabel sizeToFit];
        }
        else if (asaleService.chulizhuangtai == ASaleStatusPending) {
            self.detailLabel.text = @"漏发申请审核已通过, 售后处理中";
            [self.detailLabel sizeToFit];
        }
        else if (asaleService.chulizhuangtai == ASaleStatusLoufaTuikuan) {
//            self.detailLabel.text = @"漏发申请审核已通过, 已退款到您的账户余额";
            self.detailLabel.text = @"漏发申请审核已通过, 已退款";
            [self.detailLabel sizeToFit];
        }
    }
    
    else {
        //
        if (asaleService.chulizhuangtai == ASaleStatusSubmit ||asaleService.chulizhuangtai == ASaleStatusPending) {
            self.actionButton.width = 100;
            self.actionButton.hidden = NO;
            [self.actionButton setNormalTitle:@"填写退货单号"];

            if (asaleService.refundhao && asaleService.refundhao.length > 0) {
                self.detailLabel.text = @"售后处理中";
                [self.detailLabel sizeToFit];
            }
            else {
                self.detailLabel.text = @"请填写退货的物流单号";
                [self.detailLabel sizeToFit];
            }
        }
        else if (asaleService.chulizhuangtai == ASaleStatusLoufaTuikuan) {
//            self.detailLabel.text = @"已退款到您的账户余额";
            self.detailLabel.text = @"已退款";
            [self.detailLabel sizeToFit];
        }
        else if (asaleService.chulizhuangtai == ASaleStatusTuihuoTuikuan) {
//            self.detailLabel.text = @"客服已收到您退回的货品，已退款到您的账户余额";
            self.detailLabel.text = @"客服已收到您退回的货品，已退款";
            [self.detailLabel sizeToFit];
        }
        else if (asaleService.chulizhuangtai == ASaleStatusTuihuoPending) {
            self.detailLabel.text = @"退货处理中";
            [self.detailLabel sizeToFit];
        }
        else if (asaleService.chulizhuangtai == ASaleStatusCanceled) {
            self.detailLabel.textColor = COLOR_TEXT_NORMAL;
            self.detailLabel.text = @"售后申请已撤销";
            [self.detailLabel sizeToFit];
        }
    }
    
    if (asaleService.reissuehao && asaleService.reissuehao.length > 0) {
        self.actionButton.width = 80;
        [self.actionButton setNormalTitle:@"查看物流"];
        self.actionButton.hidden = NO;
        
        self.wuliuLabel.hidden = NO;
        self.wuliuLabel.text = FORMAT(@"补发单号： %@ %@", asaleService.reissuecorp, asaleService.reissuehao);
        [self.wuliuLabel sizeToFit];
    }
    else if ((asaleService.refundhao && asaleService.refundhao.length > 0) && (asaleService.chulizhuangtai == ASaleStatusPending || asaleService.chulizhuangtai == ASaleStatusTuihuoPending)) {
        self.actionButton.width = 100;
        [self.actionButton setNormalTitle:@"查看退货物流"];
        self.actionButton.hidden = NO;

        self.wuliuLabel.hidden = NO;
        self.wuliuLabel.text = FORMAT(@"退货单号： %@ %@", asaleService.refundcorp, asaleService.refundhao);
        [self.wuliuLabel sizeToFit];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.titleLabel.top = offset;
    self.titleLabel.left = kOFFSET_SIZE;
    
    self.stepIcon1.top = self.titleLabel.bottom + 20.0f;
    self.stepIcon2.top = self.stepIcon1.top;
    self.stepIcon3.top = self.stepIcon1.top;
    self.stepIcon4.top = self.stepIcon1.top;
    self.stepIcon1.left = kOFFSET_SIZE + 15.0f;
    self.stepIcon2.left = self.stepIcon1.right + _lineWidth + 20.0f;
    self.stepIcon3.left = self.stepIcon2.right + _lineWidth + 20.0f;
    self.stepIcon4.left = self.stepIcon3.right + _lineWidth + 20.0f;

    self.stepLabel1.top = self.stepIcon1.bottom + 10.0f;
    self.stepLabel2.top = self.stepLabel1.top;
    self.stepLabel3.top = self.stepLabel1.top;
    self.stepLabel4.top = self.stepLabel1.top;
    self.stepLabel1.centerX = self.stepIcon1.centerX;
    self.stepLabel2.centerX = self.stepIcon2.centerX;
    self.stepLabel3.centerX = self.stepIcon3.centerX;
    self.stepLabel4.centerX = self.stepIcon4.centerX;
    
    self.stepLine1.centerY = self.stepIcon1.centerY;
    self.stepLine2.centerY = self.stepIcon1.centerY;
    self.stepLine3.centerY = self.stepIcon1.centerY;
    self.stepLine1.left = self.stepIcon1.right + 10.0f;
    self.stepLine2.left = self.stepIcon2.right + 10.0f;
    self.stepLine3.left = self.stepIcon3.right + 10.0f;

    self.actionButton.right = self.width - kOFFSET_SIZE;
    self.actionButton.bottom = self.height - offset;
    
//    self.height = 140.0f + offset * 2;

    if (self.wuliuLabel.hidden == NO) {
//        self.height = 160.0f + offset * 2;

        self.wuliuLabel.left = kOFFSET_SIZE;
        self.wuliuLabel.bottom = self.height - offset;
        self.actionButton.bottom = self.wuliuLabel.top - offset*0.5f;
    }
    
    self.detailLabel.left = kOFFSET_SIZE;
    self.detailLabel.bottom = self.actionButton.bottom;
}

- (void) setStepText:(UILabel *)label text:(NSString *)text color:(UIColor *)color
{
    label.textColor = color;
    label.text = text;
    [label sizeToFit];
    label.width = 100.0f;
}

- (void) setStepIcon:(UILabel *)label icon:(NSString *)icon
{
    if (icon && [icon isEqualToString:kIconChecked]) {
        label.text = icon;
        label.textColor = COLOR_APP_GREEN;
        label.layer.borderColor = COLOR_APP_GREEN.CGColor;
    }
    else if (icon && [icon isEqualToString:kIconClose]) {
        label.text = icon;
        label.textColor = RED_COLOR;
        label.layer.borderColor = RED_COLOR.CGColor;
    }
    else {
        label.text = @"";
        label.textColor = RED_COLOR;
        label.layer.borderColor = RED_COLOR.CGColor;
    }
}

#pragma mark - Views

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.backgroundColor = CLEAR_COLOR;
        _titleLabel.textColor = COLOR_TEXT_DARK;
        _titleLabel.font = [FontUtils smallFont];
        _titleLabel.text = @"售后进度";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *) detailLabel
{
    if (!_detailLabel) {
        _detailLabel  = [[UILabel alloc] init];
        _detailLabel.backgroundColor = CLEAR_COLOR;
        _detailLabel.textColor = RED_COLOR;
        _detailLabel.font = [FontUtils smallFont];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *) wuliuLabel
{
    if (!_wuliuLabel) {
        _wuliuLabel  = [[UILabel alloc] init];
        _wuliuLabel.textColor = COLOR_TEXT_NORMAL;
        _wuliuLabel.font = [FontUtils smallFont];
    }
    return _wuliuLabel;
}

- (UIButton *) actionButton
{
    if (_actionButton) {
        return _actionButton;
    }
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(0, 0, 80, 24);
    _actionButton.backgroundColor = CLEAR_COLOR;
    _actionButton.clipsToBounds = YES;
    _actionButton.layer.cornerRadius = 3.0f;
    _actionButton.layer.borderWidth = 0.5f;
    _actionButton.layer.borderColor = RED_COLOR.CGColor;
    
    _actionButton.titleLabel.font = [FontUtils smallFont];
    [_actionButton setNormalColor:RED_COLOR highlighted:COLOR_TEXT_NORMAL selected:nil];
        
    _actionButton.hidden = YES;
    
    return _actionButton;
}

- (UILabel *) iconLabel
{
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _iconWidth, _iconWidth)];
    iconLabel.font = ICON_FONT(18);
    iconLabel.textColor = RED_COLOR;
    iconLabel.text = @"";
    iconLabel.textAlignment = NSTextAlignmentCenter;
    
    iconLabel.clipsToBounds = YES;
    iconLabel.layer.cornerRadius = _iconWidth/2.0f;
    iconLabel.layer.borderWidth = 2.0f;
    iconLabel.layer.borderColor = RED_COLOR.CGColor;
    
    iconLabel.hidden = YES;
    
    return iconLabel;
}

- (UILabel *) stepLabel
{
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.font = [FontUtils smallFont];
    stepLabel.textColor = RED_COLOR;
    stepLabel.textAlignment = NSTextAlignmentCenter;
    stepLabel.numberOfLines = 0;
    return stepLabel;
}

- (UIView *) lineView
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lineWidth, 2)];
    lineView.backgroundColor = RED_COLOR;
    lineView.hidden = YES;
    return lineView;
}

@end
