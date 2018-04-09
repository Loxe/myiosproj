//
//  AboutViewController.m
//  akucun
//
//  Created by Jarry on 2017/5/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AboutViewController.h"
#import "YYText.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *versionLabel;

@property (nonatomic, strong) UILabel     *textLabel;
@property (nonatomic, strong) UILabel     *copyrightLabel;

@end

@implementation AboutViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.logoView];
    [self.scrollView addSubview:self.versionLabel];
    [self.scrollView addSubview:self.textLabel];
    [self.scrollView addSubview:self.copyrightLabel];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.scrollView.mas_top).with.offset(kOFFSET_SIZE*2);
        make.width.mas_equalTo(@(180));
        make.height.mas_equalTo(@(80));
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.logoView.mas_bottom).with.offset(kOFFSET_SIZE);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.versionLabel.mas_bottom).with.offset(kOFFSET_SIZE*2);
        make.left.equalTo(self.view.mas_left).offset(kOFFSET_SIZE);
        make.right.equalTo(self.view.mas_right).offset(-kOFFSET_SIZE);
    }];

    
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kOFFSET_SIZE-kSafeAreaBottomHeight);
    }];
}

- (void) initViewData
{
    [super initViewData];
    
    self.title = @"关于我们";    
}

- (void) setShowTitle:(BOOL)showTitle
{
    [super setShowTitle:showTitle];
    
    if (showTitle) {
        self.scrollView.frame = CGRectMake(0, self.titleView.bottom, SCREEN_WIDTH, self.view.height-self.titleView.height);
        
        self.showTitleLine = YES;
        self.leftButton.top = isIPhoneX ? 44 : 20;
        self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, kOFFSET_SIZE, 0, 0);
        [self.titleView addSubview:self.leftButton];
    }
}

#pragma mark - Views

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = CLEAR_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIImageView *) logoView
{
    if (!_logoView) {
        UIImage *image = IMAGENAMED(@"logo");
        _logoView = [[UIImageView alloc] initWithImage:image];
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoView;
}

- (UILabel *) versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = [FontUtils normalFont];
        _versionLabel.textColor = COLOR_TEXT_NORMAL;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        
        _versionLabel.text = FORMAT(@"V%@ build %@", APP_VERSION, BUILD_VERSION);
#if DEBUG
        _versionLabel.text = FORMAT(@"Beta V%@ build %@", APP_VERSION, BUILD_VERSION);
#endif
    }
    return _versionLabel;
}

- (UILabel *) textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [FontUtils normalFont];
        _textLabel.textColor = COLOR_TEXT_NORMAL;
        _textLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"爱库存 – 让成交变简单\n\n爱库存由上海众旦信息科技有限公司于2017年创办，致力于成为全球领先的网络众包分销平台。\n\n我们为职业代购提供正品低价库存货，是品牌不良资产的处理专家。\n\n平台通过独有的S2b2C模式，打通品牌方的库存API，将品牌库存数字化、图片化，再通过爱库存APP提供给分销商进行分销。"];
        
        attributedText.yy_font = [FontUtils normalFont];
        attributedText.yy_color = COLOR_TEXT_NORMAL;
//        attributedText.yy_lineSpacing = 5.0f;
        
        _textLabel.attributedText = attributedText;
    }
    return _textLabel;
}

- (UILabel *) copyrightLabel
{
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] init];
        _copyrightLabel.font = [FontUtils smallFont];
        _copyrightLabel.textColor = COLOR_TEXT_NORMAL;
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.numberOfLines = 0;
        
        _copyrightLabel.text = @"© 2017-2018\n上海众旦信息科技有限公司";
    }
    return _copyrightLabel;
}

@end
