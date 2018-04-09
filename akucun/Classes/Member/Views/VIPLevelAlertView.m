//
//  VIPLevelAlertView.m
//  akucun
//
//  Created by deepin do on 2018/2/28.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "VIPLevelAlertView.h"
#import "UIView+TYAlertView.h"

//#define imgW SCREEN_WIDTH-kOFFSET_SIZE
//#define imgH imgW*502/698
//#define btnW ceilf(imgW-8*kOFFSET_SIZE)
//#define btnH ceilf(btnW/5)
//#define strW ceilf(imgW-4*kOFFSET_SIZE)

@interface VIPLevelAlertView ()

@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) UIImageView *bottomImgView;

@property (nonatomic, strong) UILabel  *vipLevelLabel;
@property (nonatomic, strong) UILabel  *descripeLabel;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, assign) BOOL isBottomViewAction;

@property (nonatomic, assign) CGFloat titleH;
@property (nonatomic, assign) CGFloat subTitleH;

@property (nonatomic, assign) BOOL isShowTitle;
@property (nonatomic, assign) BOOL isShowSubTitle;
@property (nonatomic, assign) BOOL isShowActionBtn;

@end

@implementation VIPLevelAlertView

- (VIPLevelAlertView *)initWithType:(VIPLevelAlertType)type title:(NSString *)title subTitle:(NSString *)subTitle actionBtnTitle:(NSString *)actionBtnTitle
{
    /** 富文本显示如下 */
    NSMutableAttributedString *attStr = [self displayVIPAlertWithType:type andContent:subTitle];
    return [self initWithType:type title:title subTitleAttribute:attStr actionBtnTitle:actionBtnTitle];
}

- (VIPLevelAlertView *)initWithType:(VIPLevelAlertType)type title:(NSString *)title subTitleAttribute:(NSAttributedString *)subTitleAttribute actionBtnTitle:(NSString *)actionBtnTitle {
    return [self initWithType:type title:title subTitle:nil subTitleAttribute:subTitleAttribute actionBtnTitle:actionBtnTitle];
}

- (VIPLevelAlertView *)initWithType:(VIPLevelAlertType)type title:(NSString *)title subTitle:(NSString *)subTitle subTitleAttribute:(NSAttributedString *)subTitleAttribute actionBtnTitle:(NSString *)actionBtnTitle {
    
    self.alertType       = type;
    self.vipLevelText    = title;
    self.descriptionText = subTitle;
    
    // 总高度
    CGFloat totoalH = 0.0;
    CGFloat imgW = SCREEN_WIDTH-kOFFSET_SIZE;
    CGFloat imgH = imgW*502/698;
    CGFloat btnW = ceilf(imgW-8*kOFFSET_SIZE);
    CGFloat btnH = ceilf(btnW/5);
    CGFloat strW = ceilf(imgW-4*kOFFSET_SIZE);
    
    // 标题
    if([title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        self.isShowTitle = YES;
        self.vipLevelLabel.text = title;
        
        CGSize  sz   = CGSizeMake(strW, CGFLOAT_MAX);
        CGSize  size = [self.vipLevelLabel sizeThatFits:sz];
        CGFloat ht   = ceilf(size.height);
        self.titleH  = ht;
        totoalH += (0.5*ht+10);
    } else {
        self.isShowTitle = NO;
        self.titleH = 0;
        totoalH += 10;
    }
    
    // 子内容
    if(([subTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) || (subTitleAttribute.length > 0)) {
        self.isShowSubTitle = YES;
        if (subTitleAttribute == nil) {
            self.descripeLabel.text = subTitle;
        } else {
            self.descripeLabel.attributedText = subTitleAttribute;
        }
        
        CGSize sz   = CGSizeMake(strW, CGFLOAT_MAX);
        CGSize size = [self.descripeLabel sizeThatFits:sz];
        CGFloat ht  = ceilf(size.height);
        self.subTitleH = ht;
        totoalH += (ht+20);
    } else {
        self.isShowSubTitle = NO;
        self.subTitleH = 0;
        totoalH += 0;
    }
    
    // 操作按钮
    if ([actionBtnTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        self.isShowActionBtn = YES;
        [self.actionBtn setNormalTitle:actionBtnTitle];
        totoalH += (btnH+20);
    } else {
        self.isShowActionBtn = NO;
        totoalH += 10;
    }
    
    CGRect newFrame;
    
    if (totoalH <= 0.5*imgH) {
        totoalH  = imgH;
        newFrame = CGRectMake(0.5*kOFFSET_SIZE, 0.5*(SCREEN_HEIGHT-totoalH), imgW, totoalH);
    } else {
        CGFloat flagH = totoalH - 0.5*imgH;
        totoalH  = flagH+imgH;
        newFrame = CGRectMake(0.5*kOFFSET_SIZE, 0.5*(SCREEN_HEIGHT-totoalH), imgW, totoalH);
    }
    
    return [self initWithFrame:newFrame];
}

// 实例化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithFrame:frame];
    }
    return self;
}

// 布局
- (void)setupUIWithFrame:(CGRect)frame{
    
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    CGFloat imgW2 = SCREEN_WIDTH-kOFFSET_SIZE;
    CGFloat imgH2 = imgW2*502/698;
    CGFloat btnW = ceilf(imgW2-8*kOFFSET_SIZE);
    CGFloat btnH = ceilf(btnW/5);
    CGFloat strW = ceilf(imgW2-4*kOFFSET_SIZE);
    
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.bottomImgView];
    [self.bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];


    if (self.isShowTitle) {
        [self addSubview:self.vipLevelLabel];
        [self.vipLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(strW));
            make.centerX.equalTo(self.bottomImgView);
            make.centerY.equalTo(self.bottomImgView.mas_top).offset(0.5*imgH2);
        }];
    }

    if (self.isShowSubTitle) {
        [self addSubview:self.descripeLabel];
        [self.descripeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@(strW));
            make.top.equalTo(self.vipLevelLabel.mas_bottom).offset(10);
        }];
    }
    
    if (self.isShowActionBtn) {
        [self addSubview:self.actionBtn];
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.descripeLabel.mas_bottom).offset(10);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
    }

    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-kOFFSET_SIZE);
        make.width.height.equalTo(@30);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidTap)];
    [self.bottomView setUserInteractionEnabled:YES];
    [self.bottomView addGestureRecognizer:tap];
}

- (void)setAlertType:(VIPLevelAlertType)alertType {
    _alertType = alertType;
    
    CGFloat imgW3 = SCREEN_WIDTH-kOFFSET_SIZE;
    CGFloat imgH3 = imgW3*502/698;
    
    UIImage *img;
    switch (alertType) {
        case VIPLevelAlertTypeUpgrade:
            img = [UIImage imageNamed:@"crownRed"];
            break;
        case VIPLevelAlertTypeGrading:
            img = [UIImage imageNamed:@"crownBlue"];
            break;
        case VIPLevelAlertTypeDemotion:
            img = [UIImage imageNamed:@"crownLight"];
            break;
        default:
            img = [UIImage imageNamed:@"crownRed"];
            break;
    }
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0.5*imgH3, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
    self.bottomImgView.image = img;
    
}

- (void)setVipLevelText:(NSString *)vipLevelText {
    _vipLevelText = vipLevelText;
    
    self.vipLevelLabel.text = vipLevelText;
}

- (void)setDescriptionText:(NSString *)descriptionText {
    _descriptionText = descriptionText;
    
    self.descripeLabel.text = descriptionText;
}

- (void)setDescriptionAttributedText:(NSAttributedString *)descriptionAttributedText {
    _descriptionAttributedText = descriptionAttributedText;
    
    self.descripeLabel.attributedText = descriptionAttributedText;
}

- (void)setIsShowCloseBtn:(BOOL)isShowCloseBtn {
    _isShowCloseBtn = isShowCloseBtn;
    
    [self.closeBtn setHidden:!isShowCloseBtn];
}

- (void)setIsShowActionBtn:(BOOL)isShowActionBtn {
    _isShowActionBtn = isShowActionBtn;
    
    [self.actionBtn setHidden:!isShowActionBtn];
}

- (void)setActionBtnTitle:(NSString *)actionBtnTitle {
    _actionBtnTitle = actionBtnTitle;
    
    [self.actionBtn setNormalTitle:actionBtnTitle];
}

- (void)showWithBGTapDismiss:(BOOL)isEnable {
    self.isBottomViewAction = isEnable;
    
    [self showInWindowWithBackgoundTapDismissEnable:isEnable];
}

- (void)close:(UIButton*)btn {
    [self hideInWindow];
}

- (void)actionBtn:(UIButton*)btn {
    if (self.actionHandle) {
        [self hideInWindow];
        self.actionHandle(btn);
    }
}

- (void)viewDidTap {
    if (self.isBottomViewAction) {
        [self hideInWindow];
    }
}

- (NSMutableAttributedString *)displayVIPAlertWithType:(VIPLevelAlertType)type andContent:(NSString *)descText
{
    if (type == VIPLevelAlertTypeUpgrade) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:descText];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.paragraphSpacing = 10; //段落间距
        style.lineSpacing = 2; // 行间距
        //第一行头缩进
        //[paragraphStyle setFirstLineHeadIndent:15.0];
        //头部缩进
        //[paragraphStyle setHeadIndent:15.0];
        //尾部缩进
        //[paragraphStyle setTailIndent:250.0];
        //最小行高
        //[paragraphStyle setMinimumLineHeight:20.0];
        //最大行高
        //[paragraphStyle setMaximumLineHeight:20.0];
        [style setAlignment:NSTextAlignmentCenter];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, descText.length)];
        
        // 关键字改变颜色或者字体
        // 关键字内容确定的如下
        NSString *keyStr1 = @"VIP";
        NSString *keyStr2 = @"更多专享特权等着你呦！";
        NSRange keyRange1;
        NSRange keyRange2;
        if ([descText rangeOfString:keyStr1].location != NSNotFound) {
            keyRange1 = [descText rangeOfString:keyStr1];
            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(keyRange1.location, keyRange1.length+1)];
            [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(keyRange1.location, keyRange1.length+1)];
        }
        
        if ([descText rangeOfString:keyStr2].location != NSNotFound) {
            keyRange2 = [descText rangeOfString:keyStr2];
            [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(keyRange2.location, keyRange2.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0xF6, 0x8F, 0x0B) range:NSMakeRange(keyRange2.location, keyRange2.length)];
        }
        
        // 关键字内容不确定(即两个关键字之间的范围)的如下
        NSString *keyStr3 = @"¥";
        NSString *keyStr4 = @"元";
        NSRange keyRange3;
        NSRange keyRange4;
        if (([descText rangeOfString:keyStr3].location != NSNotFound) && ([descText rangeOfString:keyStr4].location != NSNotFound)) {
            keyRange3 = [descText rangeOfString:keyStr3];
            keyRange4 = [descText rangeOfString:keyStr4];
            if (keyRange4.location > keyRange3.location) {
                NSRange keyRange = NSMakeRange(keyRange3.location, keyRange4.location - keyRange3.location);
                [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:keyRange];
                [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:keyRange];
            }
        }
        
        return attStr;
    }
    else if (type == VIPLevelAlertTypeGrading) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:descText];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.paragraphSpacing = 10; //段落间距
        style.lineSpacing = 2; // 行间距
        [style setAlignment:NSTextAlignmentCenter];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, descText.length)];
        
        // 关键字改变颜色或者字体
        // 关键字内容确定的如下
        NSString *keyStr1 = @"保级";
        NSString *keyStr2 = @"你可以的，继续加油！";
        NSRange keyRange1;
        NSRange keyRange2;
        if ([descText rangeOfString:keyStr1].location != NSNotFound) {
            keyRange1 = [descText rangeOfString:keyStr1];
            [attStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(119, 173, 233) range:NSMakeRange(keyRange1.location, keyRange1.length)];
            [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(16) range:NSMakeRange(keyRange1.location, keyRange1.length)];
        }
        
        if ([descText rangeOfString:keyStr2].location != NSNotFound) {
            keyRange2 = [descText rangeOfString:keyStr2];
            [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(17) range:NSMakeRange(keyRange2.location, keyRange2.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0xF6, 0x8F, 0x0B) range:NSMakeRange(keyRange2.location, keyRange2.length)];
        }
        
        // 关键字内容不确定(即两个关键字之间的范围)的如下
        NSString *keyStr3 = @"¥";
        NSString *keyStr4 = @"元";
        NSRange keyRange3;
        NSRange keyRange4;
        if (([descText rangeOfString:keyStr3].location != NSNotFound) && ([descText rangeOfString:keyStr4].location != NSNotFound)) {
            keyRange3 = [descText rangeOfString:keyStr3];
            keyRange4 = [descText rangeOfString:keyStr4];
            if (keyRange4.location > keyRange3.location) {
                NSRange keyRange = NSMakeRange(keyRange3.location, keyRange4.location - keyRange3.location);
                [attStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(119, 173, 233) range:keyRange];
                [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(16) range:keyRange];
            }
        }
        
        return attStr;
    }
    else {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:descText];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.paragraphSpacing = 10;
        style.lineSpacing = 2;
        [style setAlignment:NSTextAlignmentCenter];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, descText.length)];
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, descText.length)];
        
        // 关键字改变颜色或者字体
        // 关键字内容确定的如下
        NSString *keyStr1 = @"降级";
        NSRange keyRange1;
        if ([descText rangeOfString:keyStr1].location != NSNotFound) {
            keyRange1 = [descText rangeOfString:keyStr1];
            [attStr addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(keyRange1.location, keyRange1.length)];
        }
        
        // 关键字内容不确定(即两个关键字之间的范围)的如下
        NSString *keyStr2 = @"至";
        NSString *keyStr3 = @"\n";
        NSRange keyRange2;
        NSRange keyRange3;
        if (([descText rangeOfString:keyStr2].location != NSNotFound) && ([descText rangeOfString:keyStr3].location != NSNotFound)) {
            keyRange2 = [descText rangeOfString:keyStr2];
            keyRange3 = [descText rangeOfString:keyStr3];
            if (keyRange3.location > keyRange2.location) {
                NSRange keyRange = NSMakeRange(keyRange2.location+1, keyRange3.location - keyRange2.location-1);
                [attStr addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:keyRange];
                [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:keyRange];
            }
        }
        
        return attStr;
    }
}

#pragma mark - LAZY
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIImageView *)bottomImgView {
    if (_bottomImgView == nil) {
        _bottomImgView = [[UIImageView alloc]init];
    }
    return _bottomImgView;
}

- (UILabel *)vipLevelLabel {
    if (_vipLevelLabel == nil) {
        _vipLevelLabel = [[UILabel alloc]init];
        _vipLevelLabel.textColor = RGBCOLOR(0xF6, 0x8F, 0x0B);
        _vipLevelLabel.font      = BOLDSYSTEMFONT(30);
        _vipLevelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipLevelLabel;
}

- (UILabel *)descripeLabel {
    if (_descripeLabel == nil) {
        _descripeLabel = [[UILabel alloc]init];
        _descripeLabel.textColor = COLOR_TEXT_DARK;
        _descripeLabel.font      = BOLDSYSTEMFONT(16);
        _descripeLabel.numberOfLines = 0;
        _descripeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descripeLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"alertClose"] forState:UIControlStateNormal];
        _closeBtn.layer.cornerRadius = 3;
        _closeBtn.layer.masksToBounds = YES;
        
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        [_actionBtn setNormalTitle:@"确定"];
        _actionBtn.titleLabel.font = BOLDSYSTEMFONT(16);
        [_actionBtn setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_actionBtn setBackgroundColor:COLOR_MAIN];
        _actionBtn.layer.cornerRadius  = 3;
        _actionBtn.layer.masksToBounds = YES;
        
        [_actionBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end





