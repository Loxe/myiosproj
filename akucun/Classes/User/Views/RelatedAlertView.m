//
//  RelatedAlertView.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RelatedAlertView.h"
#import "TipTextView.h"
#import "IconButton.h"

@interface RelatedAlertView ()

@property (nonatomic, strong) TipTextView *tipTextView1,*tipTextView2,*tipTextView3,*tipTextView4;

@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic, copy) voidBlock confirmBlock;

@end

@implementation RelatedAlertView

+ (void) showWithConfirmed:(voidBlock)confirmBlock
{
    RelatedAlertView *alertView = [[RelatedAlertView alloc] init];
    alertView.confirmBlock = confirmBlock;
    [alertView show];
}

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews
{
    self.type = MMPopupTypeAlert;
    
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    self.layer.cornerRadius = config.cornerRadius;
    self.clipsToBounds = YES;
    self.backgroundColor = config.backgroundColor;
    self.layer.borderWidth = MM_SPLIT_WIDTH;
    self.layer.borderColor = config.splitColor.CGColor;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;

    UIView *titleView = [UIView new];
    titleView.backgroundColor = RED_COLOR;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute);
        make.left.right.equalTo(self);
    }];
    
    UILabel *iconLabel = [UILabel new];
    iconLabel.layer.backgroundColor = WHITE_COLOR.CGColor;
    iconLabel.textColor = RED_COLOR;
    iconLabel.font = FA_ICONFONTSIZE(25);
    iconLabel.text = FA_ICONFONT_ALERT;
    iconLabel.textAlignment = NSTextAlignmentCenter;
    iconLabel.layer.masksToBounds = YES;
    iconLabel.layer.cornerRadius = 20;
    [titleView addSubview:iconLabel];
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(10);
        make.centerX.equalTo(titleView);
        make.width.height.equalTo(@(40));
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = BOLDSYSTEMFONT(19);
    titleLabel.textColor = WHITE_COLOR;
    titleLabel.text = @"向主账号发起关联申请";
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconLabel.mas_bottom).offset(5);
        make.centerX.equalTo(titleView);
    }];
    
    [titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    lastAttribute = titleView.mas_bottom;
    
    [self addSubview:self.tipTextView1];
    [self.tipTextView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(kOFFSET_SIZE);
        make.left.equalTo(self).offset(kOFFSET_SIZE);
        make.right.equalTo(self).offset(-kOFFSET_SIZE);
    }];

    [self addSubview:self.tipTextView2];
    [self.tipTextView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipTextView1.mas_bottom).offset(10);
        make.left.right.equalTo(self.tipTextView1);
    }];

    [self addSubview:self.tipTextView3];
    [self.tipTextView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipTextView2.mas_bottom).offset(10);
        make.left.right.equalTo(self.tipTextView1);
    }];
    
    [self addSubview:self.tipTextView4];
    [self.tipTextView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipTextView3.mas_bottom).offset(10);
        make.left.right.equalTo(self.tipTextView1);
    }];
    
    lastAttribute = self.tipTextView4.mas_bottom;

    IconButton *iconButton = [[IconButton alloc] init];
    [iconButton setTitleFont:BOLDSYSTEMFONT(14)];
    [iconButton setTitle:@"同意以上内容" icon:FA_ICONFONT_UNCHECK1];
    [iconButton setTextColor:RED_COLOR];
    [iconButton setIconColor:RED_COLOR];
    [iconButton addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(kOFFSET_SIZE);
        make.left.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.width.equalTo(@(200));
        make.height.equalTo(@(30));
    }];
    lastAttribute = iconButton.mas_bottom;
    
    UIView *buttonView = [UIView new];
    [self addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(config.innerMargin);
        make.left.right.equalTo(self);
    }];
    
    UIButton *cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(cancelAction:)];
    [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = MM_SPLIT_WIDTH;
    cancelButton.layer.borderColor = config.splitColor.CGColor;
    cancelButton.titleLabel.font = [FontUtils buttonFont];
    [buttonView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(buttonView);
        make.height.mas_equalTo(config.buttonHeight);
        make.left.equalTo(buttonView.mas_left).offset(-MM_SPLIT_WIDTH);
        make.right.equalTo(buttonView.mas_centerX);
    }];
    
    UIButton *okButton = [UIButton mm_buttonWithTarget:self action:@selector(okAction:)];
    [okButton setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
    [okButton setTitle:@"同意" forState:UIControlStateNormal];
    [okButton setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [okButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
    okButton.layer.borderWidth = MM_SPLIT_WIDTH;
    okButton.layer.borderColor = config.splitColor.CGColor;
    okButton.titleLabel.font = [FontUtils buttonFont];
    [buttonView addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(buttonView);
        make.height.mas_equalTo(config.buttonHeight);
        make.left.equalTo(cancelButton.mas_right).offset(-MM_SPLIT_WIDTH);
        make.right.equalTo(buttonView.mas_right).offset(MM_SPLIT_WIDTH);
    }];
    okButton.enabled = NO;
    self.okButton = okButton;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonView.mas_bottom);
    }];
}

- (void) iconButtonAction:(IconButton*)btn
{
    BOOL checked = btn.selected;
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    self.okButton.enabled = btn.selected;
}

- (void) okAction:(UIButton*)btn
{
    [self hide];
    
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void) cancelAction:(UIButton*)btn
{
    [self hide];
}


- (TipTextView *) tipTextView1
{
    if (_tipTextView1 == nil) {
        _tipTextView1 = [[TipTextView alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"账号关联后您的销售业绩将被关联至“主账号”所有的奖励都将发放给主账号。"];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5; // 行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(7, 8)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(7, 8)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(16, 5)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(16, 5)];
        [_tipTextView1 setAttributeText:attStr];
    }
    return _tipTextView1;
}

- (TipTextView *) tipTextView2
{
    if (_tipTextView2 == nil) {
        _tipTextView2 = [[TipTextView alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"您的账号将被标记为“关联” 今后不再享受任何奖励和排名。"];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5; // 行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(9, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(9, 4)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(17, 8)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(16, 8)];
        [_tipTextView2 setAttributeText:attStr];
    }
    return _tipTextView2;
}

- (TipTextView *) tipTextView3
{
    if (_tipTextView3 == nil) {
        _tipTextView3 = [[TipTextView alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"关联账号只能与主账号共享唯一收货地址、整套主账号体系下每月只能修改 5 次 地址。"];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5; // 行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(10, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(10, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(34, 4)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(34, 4)];
        [_tipTextView3 setAttributeText:attStr];
    }
    return _tipTextView3;
}

- (TipTextView *) tipTextView4
{
    if (_tipTextView4 == nil) {
        _tipTextView4 = [[TipTextView alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"请谨慎操作，一旦关联后不可解除，由此产生的法律纠纷自行承担。"];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5; // 行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
        [_tipTextView4 setAttributeText:attStr];
    }
    return _tipTextView4;
}


@end
