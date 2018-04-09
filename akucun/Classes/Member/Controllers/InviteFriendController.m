//
//  InviteFriendController.m
//  akucun
//
//  Created by deepin do on 2018/1/30.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "InviteFriendController.h"
#import "MJRefresh.h"
#import "SGQRCode.h"
#import "UserManager.h"
#import "ShareActivity.h"
#import "RequestShareCode.h"

@interface InviteFriendController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton     *forwardButton;

@property (nonatomic, strong) UIImageView *bannerImgView;
@property (nonatomic, strong) UILabel     *noticeLabel;
@property (nonatomic, strong) UIView      *contentView;

@property (nonatomic, strong) UILabel     *codeTitleLabel;
@property (nonatomic, strong) UILabel     *codeNumLabel;

@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UIImageView *codeBGImage;

@end

@implementation InviteFriendController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    [self prepareSubView];
}

- (void) viewWillAppear:(BOOL)animated {
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
    self.title = @"邀请好友";
}

- (void)prepareSubView {
    
    // 第一层
    [self.view addSubview:self.forwardButton];
    CGFloat btnHeight = isPad ? kFIELD_HEIGHT_PAD : 44;
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@(btnHeight+kSafeAreaBottomHeight));
    }];

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.forwardButton.mas_top);
    }];
    self.scrollView.contentSize = CGSizeMake(0, 273*SCREEN_WIDTH/621+30+50+568*SCREEN_WIDTH*0.8/500+kOFFSET_SIZE);
    
    // 第二层
    [self.scrollView addSubview:self.bannerImgView];
    [self.bannerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);// 此处左右相对于self.view设置约束，会显示不对，不知为何
        make.height.equalTo(@(273*SCREEN_WIDTH/621));
    }];
    
    [self.scrollView addSubview:self.noticeLabel];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bannerImgView.mas_bottom).offset(-kOFFSET_SIZE*0.5);
        make.right.equalTo(self.bannerImgView).offset(-kOFFSET_SIZE);
//        make.height.equalTo(@30);
    }];

    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerImgView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(30+50+568*SCREEN_WIDTH*0.7/500+kOFFSET_SIZE*2));
    }];
    
    // 第三层
    [self.contentView addSubview:self.codeTitleLabel];
    [self.contentView addSubview:self.codeNumLabel];
    [self.contentView addSubview:self.codeBGImage];
    [self.contentView addSubview:self.codeImgView];

    [self.codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0.5*kOFFSET_SIZE);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];

    [self.codeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLabel.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];

    [self.codeBGImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeNumLabel.mas_bottom).offset(3);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(SCREEN_WIDTH*0.7));//SCREEN_WIDTH*0.5
        make.height.equalTo(@(568*SCREEN_WIDTH*0.7/500));//568*SCREEN_WIDTH*0.5/500
    }];

    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeBGImage).offset(8);
        make.centerX.equalTo(self.codeBGImage);
        make.width.height.equalTo(@(SCREEN_WIDTH*0.7*0.6));//@170
    }];
}

- (void)displayQRCode {
    
    self.codeNumLabel.text = self.code;
    
    CGFloat scale = 0.2;
    NSString *url = [NSString stringWithFormat:@"http://www.aikucun.com/m/download.php?code=%@",self.code];
    self.codeImgView.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:url logoImageName:@"icon_title_logo" logoScaleToSuperView:scale];

    self.contentView.alpha = 1.0f;
}

- (void)forward:(UIButton *)btn {
    
    //UIImage *image = [self.contentView screenshot];
    UIImage *image = [self screenshotFor:self.contentView];
    [ShareActivity forwardWithImage:image parent:self view:nil finished:^(int flag) {
        [self requestShareCode];
        
    } canceled:nil];
}

- (UIImage *) screenshotFor:(UIView *)view 
{
    CGFloat scale = [UIScreen screenScale];
    
    if(scale > 1.5) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
//    if (isIOS7) {
//        [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
//    }
//    else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (void) requestShareCode
{
    RequestShareCode *request = [RequestShareCode new];
    request.refCode = self.code;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD showSuccessWithStatus:@"分享成功 ！"];
        GCD_DELAY(^{
            [self.navigationController popViewControllerAnimated:YES];
        }, 2.0f);
                                    
    } onFailed:nil];
}

#pragma mark - LAZY
- (UIImageView *)bannerImgView {
    if (_bannerImgView == nil) {
        _bannerImgView = [[UIImageView alloc]init];
        _bannerImgView.image = [UIImage imageNamed:@"inviteFriendBanner"];
        _bannerImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bannerImgView;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.text      = @"* 爱库存保留活动规则的最终解释权";
        _noticeLabel.textColor = WHITE_COLOR;
        _noticeLabel.font      = SYSTEMFONT(9);
        _noticeLabel.textAlignment = NSTextAlignmentRight;
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.hidden = YES;
    }
    return _noticeLabel;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.borderColor = WHITE_COLOR.CGColor;
        _contentView.layer.borderWidth = .5f;
        _contentView.alpha = 0.0f;
    }
    return _contentView;
}

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

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _forwardButton.frame = CGRectMake(20, kOFFSET_SIZE, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _forwardButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight*0.5, 0);
        _forwardButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_forwardButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_forwardButton setBackgroundColor:COLOR_SELECTED];
        [_forwardButton setNormalTitle:@"立即邀请"];
        
        [_forwardButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardButton;
}

@end
