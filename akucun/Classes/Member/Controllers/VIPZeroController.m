//
//  VIPZeroController.m
//  akucun
//
//  Created by deepin do on 2018/2/28.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kBtnWH  (SCREEN_WIDTH-4*kOFFSET_SIZE)/3

#import "VIPZeroController.h"
#import "VIPPurchaseController.h"
#import "AboutViewController.h"
#import "InputCodeController.h"
#import "TextButton.h"
#import "RequestUserLogout.h"

@interface VIPZeroController ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIButton *inputCodeBtn;
@property (nonatomic, strong) UIButton *buyVIPBtn;
@property (nonatomic, strong) UIButton *aboutBtn;

@property (nonatomic, strong) TextButton *logoutBtn;

@end

@implementation VIPZeroController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    [self prepareSubView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)prepareNav {
    
    self.view.backgroundColor   = WHITE_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)prepareSubView {
    
    CGFloat offset  = kOFFSET_SIZE;
    CGFloat bMargin = 4*kOFFSET_SIZE;
    CGFloat h  = 44;             
    CGFloat lW = SCREEN_WIDTH-4*kOFFSET_SIZE;// 较长的按钮
    CGFloat sW = (lW-10)*0.5;                // 较短的按钮
    
    [self.view addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(kSafeAreaBottomHeight+offset));
        make.centerX.equalTo(self.view);
//        make.right.equalTo(self.view).offset(-2*offset);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
    
    [self.view addSubview:self.buyVIPBtn];
    [self.buyVIPBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.logoutBtn.mas_top).offset(-bMargin);
        make.left.equalTo(self.view).offset(2*offset);
        make.width.equalTo(@(sW));
        make.height.equalTo(@(h));
    }];
    
    [self.view addSubview:self.aboutBtn];
    [self.aboutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-2*offset);
        make.bottom.equalTo(self.buyVIPBtn);
        make.width.equalTo(@(sW));
        make.height.equalTo(@(h));
    }];
    
    [self.view addSubview:self.inputCodeBtn];
    [self.inputCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(2*offset);
        make.right.equalTo(self.view).offset(-2*offset);
        make.bottom.equalTo(self.buyVIPBtn.mas_top).offset(-kOFFSET_SIZE);
        make.width.height.equalTo(@(lW));
        make.height.equalTo(@(h));
    }];
}

- (void)inputCode:(UIButton*)btn {
    InputCodeController *vc = [InputCodeController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buyVIP:(UIButton*)btn {
    VIPPurchaseController *vc = [VIPPurchaseController new];
    typeof(self) __weak weakSelf = self;
    vc.completionBlock = ^(id nsobject) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowed"];// 当vip非0的时候设置这个
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIP0_UPGRADED object:nil];
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)aboutAKC:(UIButton*)btn {
    AboutViewController *vc = [[AboutViewController alloc] init];
    vc.showTitle = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logoutAction:(id)sender
{
    RequestUserLogout *request = [RequestUserLogout new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
     } onFailed:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    [SVProgressHUD showSuccessWithStatus:@"账号已退出"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOKEN_EXPIRED object:nil];
}

#pragma mark - LAZY
- (UIImageView *)bgImgView {
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:@"vip0BG"];
    }
    return _bgImgView;
}

- (UIButton *)inputCodeBtn {
    if (!_inputCodeBtn) {
        _inputCodeBtn = [[UIButton alloc]init];
        [_inputCodeBtn setNormalTitle:@"输入邀请码"];
        _inputCodeBtn.titleLabel.font = BOLDSYSTEMFONT(16);
        [_inputCodeBtn setNormalColor:COLOR_MAIN highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_inputCodeBtn setBackgroundColor:WHITE_COLOR];
        _inputCodeBtn.layer.cornerRadius = 3;
        _inputCodeBtn.layer.masksToBounds = YES;

        [_inputCodeBtn addTarget:self action:@selector(inputCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputCodeBtn;
}

- (UIButton *)buyVIPBtn {
    if (!_buyVIPBtn) {
        _buyVIPBtn = [[UIButton alloc]init];
        [_buyVIPBtn setNormalTitle:@"购买VIP"];
        _buyVIPBtn.titleLabel.font = SYSTEMFONT(16);
        [_buyVIPBtn setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        _buyVIPBtn.layer.cornerRadius = 1;
        _buyVIPBtn.layer.masksToBounds = YES;
        _buyVIPBtn.layer.borderColor = WHITE_COLOR.CGColor;
        _buyVIPBtn.layer.borderWidth = 1.f;

        [_buyVIPBtn addTarget:self action:@selector(buyVIP:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyVIPBtn;
}

- (UIButton *)aboutBtn {
    if (!_aboutBtn) {
        _aboutBtn = [[UIButton alloc]init];
        [_aboutBtn setNormalTitle:@"了解爱库存"];
        _aboutBtn.titleLabel.font = SYSTEMFONT(16);
        [_aboutBtn setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        _aboutBtn.layer.cornerRadius = 1;
        _aboutBtn.layer.masksToBounds = YES;
        _aboutBtn.layer.borderColor = WHITE_COLOR.CGColor;
        _aboutBtn.layer.borderWidth = 1.f;

        [_aboutBtn addTarget:self action:@selector(aboutAKC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aboutBtn;
}

- (TextButton *) logoutBtn
{
    if (!_logoutBtn) {
        _logoutBtn = [TextButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitleAlignment:NSTextAlignmentCenter];
        [_logoutBtn setTitleFont:SYSTEMFONT(16)];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"退出登录"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSForegroundColorAttributeName value:WHITE_COLOR range:titleRange];
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_logoutBtn setAttributedTitle:title forState:UIControlStateNormal];
        
        NSMutableAttributedString *titleHl = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [titleHl addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_LIGHT range:titleRange];
        [_logoutBtn setAttributedTitle:titleHl forState:UIControlStateHighlighted];
        
        [_logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}

@end
