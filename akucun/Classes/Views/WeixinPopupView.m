//
//  WeixinPopupView.m
//  akucun
//
//  Created by Jarry on 2017/4/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "WeixinPopupView.h"

#define kViewHeight     (kOFFSET_SIZE*3+260+44)

@interface WeixinPopupView ()

@property (nonatomic, strong) UIButton *handerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *weixinImage;

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *nameLabel, *weixinLabel;


@end

@implementation WeixinPopupView

+ (void) showWithCompeted:(idBlock)completeBolck
{
    WeixinPopupView *pickerView = [[WeixinPopupView alloc] init];
    [pickerView showWithComplete:completeBolck];
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kViewHeight);
        
    [self setupViews];
    
    return self;
}

- (void) setupViews
{
    UIView * separateLine = [self separateLine];
    [self addSubview:separateLine];
    
    [self addSubview:self.titleLabel];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44.0f)];
    topView.backgroundColor = WHITE_COLOR;
    [topView addSubview:self.titleLabel];
    separateLine = [self separateLine];
    separateLine.top = topView.height - separateLine.height;
    [topView addSubview:separateLine];
    [self addSubview:topView];
    
    self.logoView.top = topView.bottom + kOFFSET_SIZE;
    [self addSubview:self.logoView];
    self.nameLabel.left = self.logoView.right + kOFFSET_SIZE;
    self.nameLabel.top = self.logoView.top;
    [self addSubview:self.nameLabel];
    
    self.weixinLabel.left = self.nameLabel.left;
    self.weixinLabel.bottom = self.logoView.bottom;
    [self addSubview:self.weixinLabel];
    
    self.weixinImage.top = self.logoView.bottom + kOFFSET_SIZE;
//    self.weixinImage.height = self.height - self.weixinImage.top - kOFFSET_SIZE;
    [self addSubview:self.weixinImage];
}

#pragma mark - Public

- (void) showWithComplete:(idBlock)completeBolck
{
    self.completeBolck = completeBolck;
    [self show];
}

- (void) show
{    
    if (!_handerView) {
        _handerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handerView setFrame:[UIScreen mainScreen].bounds];
        [_handerView setBackgroundColor:[BLACK_COLOR colorWithAlphaComponent:0.4f]];
        [_handerView addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_handerView addSubview:self];
        _handerView.tag = 100;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
        
    _handerView.alpha = 0.f;
    CGPoint center = self.center;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         _handerView.alpha = 1.f;
         self.center = CGPointMake(center.x, SCREEN_HEIGHT-self.height/2);
     }
                     completion:^(BOOL finished)
     {
         
         
     }];
}

- (void) dismiss
{
    CGPoint center = self.center;
    [UIView animateWithDuration:0.3f animations:^{
        self.center = CGPointMake(center.x, SCREEN_HEIGHT+self.height/2);
        _handerView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        _handerView = nil;
    }];
}

#pragma mark - Actions

- (void) cancelAction
{
    [self dismiss];
}

#pragma mark - 

- (UIImageView *) weixinImage
{
    if (!_weixinImage) {
        UIImage *image = IMAGENAMED(@"weixin.jpeg");
        _weixinImage = [[UIImageView alloc] initWithImage:image];
        _weixinImage.frame = CGRectMake((self.width-220)/2.0f, 44.0f, 220, 220);
        _weixinImage.contentMode = UIViewContentModeScaleAspectFit;
        
//        _weixinImage.clipsToBounds = YES;
//        _weixinImage.layer.cornerRadius = 20;
        //        _logoView.layer.borderWidth = 4.0f;
        //        _logoView.layer.borderColor = COLOR_APP_RED.CGColor;
    }
    return _weixinImage;
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0f)];
        _titleLabel.font = SYSTEMFONT(15);
        _titleLabel.textColor = COLOR_TEXT_DARK;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请加客服微信号";
    }
    return _titleLabel;
}

- (UIImageView *) logoView
{
    if (!_logoView) {
        UIImage *image = IMAGENAMED(@"weixin_logo.jpeg");
        _logoView = [[UIImageView alloc] initWithImage:image];
        _logoView.frame = CGRectMake((self.width-220)/2.0f+12, kOFFSET_SIZE, 40, 40);
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
        
        _logoView.clipsToBounds = YES;
        _logoView.layer.cornerRadius = 3.0f;
    }
    return _logoView;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = [FontUtils normalFont];
        _nameLabel.text = @"爱库存代购直播号";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *) weixinLabel
{
    if (!_weixinLabel) {
        _weixinLabel  = [[UILabel alloc] init];
        _weixinLabel.backgroundColor = CLEAR_COLOR;
        _weixinLabel.textColor = COLOR_TEXT_DARK;
        _weixinLabel.font = [FontUtils smallFont];
        _weixinLabel.text = @"微信号：akucun003";
        [_weixinLabel sizeToFit];
    }
    return _weixinLabel;
}

//分割线
- (UIView *) separateLine
{
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = COLOR_SEPERATOR_LINE;
    return separateLine;
}

@end
