//
//  InviteCodeController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/10/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "InviteCodeController.h"
#import "RequestInviteCode.h"
#import "TextButton.h"
#import "ShareActivity.h"
#import "InvitedListController.h"

@interface InviteCodeController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) TextButton *shareButton;

@property (nonatomic, strong) UILabel *codeTitleLabel, *codeValueLabel;

@property (nonatomic, strong) UIImageView *qrcodeImage;

@property (nonatomic, strong) TextButton *invitedButton;

@end

@implementation InviteCodeController

- (void) setupContent
{
    [super setupContent];
    
    self.title = @"我的邀请码";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = WHITE_COLOR;
    _contentView.layer.borderColor = WHITE_COLOR.CGColor;
    _contentView.layer.borderWidth = .5f;
    [self.view addSubview:_contentView];
    
    [self.view addSubview:self.invitedButton];

    [_contentView addSubview:self.codeTitleLabel];
    [_contentView addSubview:self.codeValueLabel];
    [_contentView addSubview:self.qrcodeImage];

    [self.codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kOFFSET_SIZE*2);
        make.centerX.equalTo(self.view);
    }];
    [self.codeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.centerX.equalTo(self.view);
    }];
    
    [self.qrcodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeValueLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(@(SCREEN_WIDTH-kOFFSET_SIZE*4));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-1);
        make.left.equalTo(self.view).offset(-1);
        make.right.equalTo(self.view).offset(1);
        make.bottom.equalTo(self.qrcodeImage).offset(kOFFSET_SIZE*2);
    }];
    
    [self.invitedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kOFFSET_SIZE*2);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.codeValueLabel.text.length == 0) {
        [self requestInviteCode];
    }
}

- (IBAction) shareAction:(id)sender
{
    UIImage *image = [self.contentView screenshot];

    [ShareActivity forwardWithImage:image parent:self view:nil finished:^(int flag) {
        //
        [SVProgressHUD showSuccessWithStatus:@"分享成功 ！"];
    } canceled:nil];
}

- (IBAction) invitedAction:(id)sender
{
    InvitedListController *controller = [InvitedListController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) requestInviteCode
{
    [SVProgressHUD showWithStatus:nil];
    RequestInviteCode *request = [RequestInviteCode new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD dismiss];
        
        HttpResponseBase *response = content;
        NSDictionary *jsonData = response.responseData;
        NSString *code = [jsonData getStringForKey:@"referralcode"];
        
        self.codeTitleLabel.text = @"邀请码";
        self.codeValueLabel.text = code;
        self.qrcodeImage.alpha = 1.0f;
        self.invitedButton.alpha = 1.0f;

    } onFailed:^(id content) {
        
    }];
}

#pragma mark -

- (UILabel *) codeTitleLabel
{
    if (!_codeTitleLabel) {
        _codeTitleLabel = [[UILabel alloc] init];
        _codeTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _codeTitleLabel.font = [FontUtils normalFont];
//        _codeTitleLabel.text = @"邀请码";
    }
    return _codeTitleLabel;
}

- (UILabel *) codeValueLabel
{
    if (!_codeValueLabel) {
        _codeValueLabel = [[UILabel alloc] init];
        _codeValueLabel.textColor = COLOR_APP_RED;
        _codeValueLabel.font = BOLDSYSTEMFONT(30);
//        _codeValueLabel.text = @"6GE9JH";
    }
    return _codeValueLabel;
}

- (UIImageView *) qrcodeImage
{
    if (!_qrcodeImage) {
        _qrcodeImage = [[UIImageView alloc] initWithImage:IMAGENAMED(@"image_invite_qrcode")];
        _qrcodeImage.contentMode = UIViewContentModeScaleAspectFit;
        _qrcodeImage.alpha = 0.0f;
    }
    return _qrcodeImage;
}

- (TextButton *) shareButton
{
    if (!_shareButton) {
        _shareButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(0, kIOS7Offset, 44, 44);
        
        [_shareButton setTitleFont:FA_ICONFONTSIZE(20)];
        [_shareButton setTitleAlignment:NSTextAlignmentRight];
        
        [_shareButton setTitle:FA_ICONFONT_SHARE forState:UIControlStateNormal];
        [_shareButton setTitleColor:COLOR_TITLE forState:UIControlStateNormal];
        [_shareButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (TextButton *) invitedButton
{
    if (!_invitedButton) {
        _invitedButton = [TextButton buttonWithType:UIButtonTypeCustom];
        
        [_invitedButton setTitleFont:[FontUtils normalFont]];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"我的邀请记录"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSForegroundColorAttributeName value:COLOR_SELECTED range:titleRange];
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_invitedButton setAttributedTitle:title forState:UIControlStateNormal];
        
        NSMutableAttributedString *titleHl = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [titleHl addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:titleRange];
        [_invitedButton setAttributedTitle:titleHl forState:UIControlStateHighlighted];
        
        [_invitedButton addTarget:self action:@selector(invitedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _invitedButton.alpha = 0.0f;
    }
    return _invitedButton;
}

@end
