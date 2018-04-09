//
//  DDCollegeController.m
//  akucun
//
//  Created by deepin do on 2018/3/1.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "DDCollegeController.h"

@interface DDCollegeController ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel    *navLabel;
@property (nonatomic, strong) UIButton   *backBtn;

//@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) UILabel     *descLabel;
@property (nonatomic, strong) UIImageView *QRCodeImgView;

@end

@implementation DDCollegeController

- (instancetype)initWithFlag:(BOOL)showTitle
{
    self = [self init];
    if (self) {
        self.showTitle = showTitle;
    }
    return self;
}

- (void) setupContent
{
    [self prepareNav];
    [self prepareSubView];
}

- (void) initViewData
{
    [super initViewData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)prepareNav {
    
    self.view.backgroundColor   = WHITE_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"代代商学院";
}

- (void)prepareSubView {
    
    CGFloat offset = kOFFSET_SIZE;
    CGFloat statusH = kSafeAreaTopHeight - 44;
    
    [self.view addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    self.navLabel.hidden = YES;
    self.backBtn.hidden = YES;
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.navLabel];
    // 考虑导航栏的高
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0.5*offset);
        make.top.equalTo(self.view).offset(statusH);
        make.width.height.equalTo(@44);
    }];
    
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusH);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    CGFloat top = kOFFSET_SIZE*2;
    if (self.showTitle) {
        top = kSafeAreaTopHeight+kOFFSET_SIZE*2;
    }
    
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(top);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-1*kOFFSET_SIZE));
    }];

    [self.view addSubview:self.QRCodeImgView];
    [self.QRCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.descLabel.mas_bottom).offset(2*kOFFSET_SIZE);
        make.width.height.equalTo(@(SCREEN_WIDTH-10*kOFFSET_SIZE));
    }];
}

- (void)setShowTitle:(BOOL)showTitle
{
    [super setShowTitle:showTitle];

    self.navLabel.hidden = !showTitle;
    self.backBtn.hidden = !showTitle;
    
    CGFloat top = kOFFSET_SIZE*2;
    if (showTitle) {
        top = kSafeAreaTopHeight+kOFFSET_SIZE*2;
    }
    [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(top);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-1*kOFFSET_SIZE));
    }];
    [self.QRCodeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.descLabel.mas_bottom).offset(2*kOFFSET_SIZE);
        make.width.height.equalTo(@(SCREEN_WIDTH-10*kOFFSET_SIZE));
    }];
}

- (void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LAZY
- (UIImageView *)bgImgView {
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:@"aboutCollegeBG"];
    }
    return _bgImgView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"collegeBack"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)navLabel {
    if (_navLabel == nil) {
        _navLabel = [[UILabel alloc]init];
        _navLabel.text = @"代代商学院";
        _navLabel.font = BOLDSYSTEMFONT(18);
        _navLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return _navLabel;
}

- (UIImageView *)QRCodeImgView {
    if (_QRCodeImgView == nil) {
        _QRCodeImgView = [[UIImageView alloc]init];
        _QRCodeImgView.image = [UIImage imageNamed:@"sellerCode"];
    }
    return _QRCodeImgView;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.numberOfLines = 0;

        NSString *preStr  = @"专业导师手把手教你销售秘籍，\n再给自己一个月的时间，相信自己一定能达标！\n";
        NSString *suffStr = @"扫描下面二维码关注代代商学院公众号\n回复关键词“我要学习” 即可获得学习资料\n通过考核后可以再次申请成为VIP1会员";
        NSString *fullStr = FORMAT(@"%@%@",preStr,suffStr);
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.paragraphSpacing = 10;
        style.lineSpacing = 5;
        [style setAlignment:NSTextAlignmentCenter];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:fullStr];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(16) range:NSMakeRange(0, fullStr.length)];
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, fullStr.length)];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_DARK range:NSMakeRange(0, preStr.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(preStr.length, suffStr.length)];
        
        _descLabel.attributedText = attStr;
    }
    return _descLabel;
}

//- (UITextView *)textView {
//    if (!_textView) {
//        _textView = [[UITextView alloc]init];
//        _textView.textAlignment = NSTextAlignmentCenter;
//        [_textView setEditable:NO];
//
//        NSString *preStr  = @"专业导师手把手教你销售秘籍，\n再给自己一个月的时间，相信自己一定能达标！\n";
//        NSString *suffStr = @"扫描下面二维码关注代代商学院公众号\n回复关键词“我的学习” 即可获得学习资料\n通过考核后可以再次申请成为VIP1公员";
//        NSString *fullStr = FORMAT(@"%@%@",preStr,suffStr);
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//        style.paragraphSpacing = 10;
//        style.lineSpacing = 5;
//
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:fullStr];
//        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(0, fullStr.length)];
//        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, fullStr.length)];
//
//        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_DARK range:NSMakeRange(0, preStr.length)];
//        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(preStr.length, suffStr.length)];
//
//        _textView.attributedText = attStr;
//
//    }
//    return _textView;
//}


@end
