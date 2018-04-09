//
//  RelatedApplyController.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RelatedApplyController.h"
#import "SCImageView.h"

@interface RelatedApplyController ()

@property (nonatomic, strong) SCImageView *iconImgView;
@property (nonatomic, strong) UIButton *applyButton;


@end

@implementation RelatedApplyController

- (void) initViewData
{
    [super initViewData];
    
    self.title = @"关联账号管理";
    
    [self.view addSubview:self.iconImgView];
    [self.view addSubview:self.applyButton];

    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-kOFFSET_SIZE*4));
        make.height.equalTo(@(44));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-self.view.height/4);
        make.width.height.equalTo(@(110));
    }];
}

- (IBAction) applyAction:(id)sender
{
    
}

#pragma mark - Request



#pragma mark -

- (SCImageView *) iconImgView
{
    if (_iconImgView == nil) {
        _iconImgView = [[SCImageView alloc] init];
        _iconImgView.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
        _iconImgView.image = [UIImage imageNamed:@"icon_related"];
        _iconImgView.contentMode = UIViewContentModeCenter;
        
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.layer.cornerRadius = 110*0.5f;
        
        @weakify(self)
        _iconImgView.clickedBlock = ^{
            @strongify(self)
            [self applyAction:nil];
        };
    }
    return _iconImgView;
}

- (UIButton *) applyButton
{
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.backgroundColor = COLOR_BG_BUTTON;
        _applyButton.layer.masksToBounds = YES;
        _applyButton.layer.cornerRadius = 5;
        
        _applyButton.titleLabel.font = [FontUtils buttonFont];
        
        [_applyButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_applyButton setNormalTitle:@"申请关联主账号"];
        
        [_applyButton addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

@end
