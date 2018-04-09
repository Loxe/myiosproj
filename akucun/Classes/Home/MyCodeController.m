//
//  MyCodeController.m
//  akucun
//
//  Created by deepin do on 2018/1/16.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "MyCodeController.h"
#import "MJRefresh.h"
#import "SGQRCode.h"
#import "UserManager.h"
#import "ShareActivity.h"

@interface MyCodeController ()

@property (nonatomic, strong) UIView      *contentView;

@property (nonatomic, strong) UILabel     *codeTitleLabel;
@property (nonatomic, strong) UILabel     *codeNumLabel;

@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UIImageView *codeBGImage;

@property (nonatomic, strong) UILabel     *scanDescLabel;
@property (nonatomic, strong) UIButton    *forwardButton;

@end

@implementation MyCodeController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    [self prepareSubView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self displayQRCode];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)prepareNav {
    
    self.view.backgroundColor   = WHITE_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的邀请码";
}

- (void)prepareSubView {
    
    [self.view addSubview:self.forwardButton];
    CGFloat height = isPad ? kFIELD_HEIGHT_PAD : 44;
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@(height+kSafeAreaBottomHeight));
    }];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = WHITE_COLOR;
    _contentView.layer.borderColor = WHITE_COLOR.CGColor;
    _contentView.layer.borderWidth = .5f;
    _contentView.alpha = 0.0f;
    [self.view addSubview:_contentView];
    
    [_contentView addSubview:self.codeTitleLabel];
    [_contentView addSubview:self.codeNumLabel];
    [_contentView addSubview:self.codeBGImage];
    [_contentView addSubview:self.codeImgView];
//    [_contentView addSubview:self.scanDescLabel];
    
    [self.codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(kOFFSET_SIZE);
        make.centerX.equalTo(_contentView);
        make.height.equalTo(@30);
    }];
    
    [self.codeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLabel.mas_bottom).offset(0.5*kOFFSET_SIZE);
        make.centerX.equalTo(_contentView);
        make.height.equalTo(@50);
    }];
    
    [self.codeBGImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeNumLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.centerX.equalTo(_contentView);
        make.width.equalTo(@(SCREEN_WIDTH*0.8));//SCREEN_WIDTH*0.5
        make.height.equalTo(@(568*SCREEN_WIDTH*0.8/500));//568*SCREEN_WIDTH*0.5/500
    }];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeBGImage).offset(8);
        make.centerX.equalTo(self.codeBGImage);
        make.width.height.equalTo(@(SCREEN_WIDTH*0.8*0.6));//@170
    }];
    
//    [self.scanDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.codeImgView.mas_bottom).offset(kOFFSET_SIZE);
//        make.centerX.equalTo(self.view);
//        make.height.equalTo(@50);
//    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-1);
        make.left.equalTo(self.view).offset(-1);
        make.right.equalTo(self.view).offset(1);
        make.bottom.equalTo(self.codeBGImage.mas_bottom).offset(kOFFSET_SIZE);
    }];
}

- (void)displayQRCode {
    
    self.codeNumLabel.text = self.code;
    
    CGFloat scale = 0.2;
    NSString *url = [NSString stringWithFormat:@"http://www.aikucun.com/m/download.php?code=%@",self.code];
    self.codeImgView.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:url logoImageName:@"icon_title_logo" logoScaleToSuperView:scale];
    
    self.forwardButton.alpha = 1.0f;
    self.contentView.alpha = 1.0f;
}

- (void)forward:(UIButton *)btn {
    
    UIImage *image = [self.contentView screenshot];
    [ShareActivity forwardWithImage:image parent:self view:nil finished:^(int flag) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功 ！"];
    } canceled:nil];
}

#pragma mark - LAZY
- (UILabel *)codeTitleLabel {
    if (_codeTitleLabel == nil) {
        _codeTitleLabel = [[UILabel alloc]init];
        _codeTitleLabel.text      = @"邀请码";
        _codeTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _codeTitleLabel.font      = [FontUtils normalFont];
    }
    return _codeTitleLabel;
}

- (UILabel *)codeNumLabel {
    if (_codeNumLabel == nil) {
        _codeNumLabel = [[UILabel alloc]init];
        _codeNumLabel.textColor = COLOR_MAIN;
        _codeNumLabel.font      = SYSTEMFONT(30);
    }
    return _codeNumLabel;
}

- (UIImageView *)codeBGImage {
    if (_codeBGImage == nil) {
        _codeBGImage = [[UIImageView alloc]init];
        _codeBGImage.image = [UIImage imageNamed:@"inviteBGQrcode"];
        _codeBGImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _codeBGImage;
}

- (UIImageView *)codeImgView {
    if (_codeImgView == nil) {
        _codeImgView = [[UIImageView alloc]init];
    }
    return _codeImgView;
}

//- (UILabel *)scanDescLabel {
//    if (_scanDescLabel == nil) {
//        _scanDescLabel = [[UILabel alloc]init];
//        _scanDescLabel.text      = @"扫一扫加入爱库存";
//        _scanDescLabel.textColor = COLOR_TEXT_DARK;
//        _scanDescLabel.font      = SYSTEMFONT(18);
//    }
//    return _scanDescLabel;
//}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _forwardButton.frame = CGRectMake(20, kOFFSET_SIZE, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _forwardButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
        _forwardButton.titleLabel.font = BOLDSYSTEMFONT(16);

        [_forwardButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_forwardButton setBackgroundColor:COLOR_SELECTED];
        [_forwardButton setNormalTitle:@"转 发"];
        
        [_forwardButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
        
        _forwardButton.alpha = 0.0f;
    }
    return _forwardButton;
}
@end
