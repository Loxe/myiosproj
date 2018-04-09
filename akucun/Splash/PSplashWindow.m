//
//  PSplashWindow.m
//  akucun
//
//  Created by Jarry on 16/6/14.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "PSplashWindow.h"
#import "RequestUserInfo.h"
#import "RequestAddrList.h"
#import "UserManager.h"
#import "ProductsManager.h"
#import "RequestIdeos.h"
#import "UIImageView+WebCache.h"
#import <GTSDK/GeTuiSdk.h>

@interface PSplashWindow ()

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel     *textLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel     *statusLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation PSplashWindow

+ (PSplashWindow *) instance
{
    static dispatch_once_t  onceToken;
    static PSplashWindow * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PSplashWindow alloc] init];
    });
    return sharedInstance;
}

+ (void) splashFinished:(voidBlock)block
{
    [PSplashWindow instance].block = block;
    [[PSplashWindow instance] show];
}

- (id) init
{
    CGRect screenBound = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenBound];
    if (self) {
        // Initialization code
        self.hidden = NO;
        self.windowLevel = UIWindowLevelStatusBar + 100.0f;
        self.backgroundColor = CLEAR_COLOR;
        
        [self initViews];
        
        [self setRootViewController:self.viewController];
        [self becomeKeyWindow];
    }
    return self;
}

- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void) initViews
{
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.viewController.view addSubview:_activityView];
    [self.viewController.view addSubview:self.statusLabel];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewController.view.mas_centerX);
        make.centerY.equalTo(self.viewController.view.mas_centerY);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewController.view.mas_centerX);
        make.top.equalTo(_activityView.mas_bottom).offset(10.0f);
    }];
    
    //
    CGFloat top = SCREEN_HEIGHT * 0.382;
    CGFloat offset = isIPhoneX ? 44 : 0;
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewController.view.mas_centerX);
        make.centerY.equalTo(self.viewController.view.mas_top).with.offset(top/2.0f+offset);
        make.width.mas_equalTo(@(180));
        make.height.mas_equalTo(@(60));
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewController.view.mas_centerX);
        make.bottom.equalTo(self.viewController.view.mas_bottom).offset(-kOFFSET_SIZE*2-kSafeAreaBottomHeight);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.viewController.view);
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) show
{
    __block PSplashWindow *bSelf = self;
    
    [UIView animateWithDuration:.25f
                     animations:^
    {
        bSelf.logoImageView.alpha = 1.0f;
        bSelf.textLabel.alpha = 1.0f;
    }
                     completion:^(BOOL finished)
    {
        [bSelf finished];
    }];
}

- (void) dismiss
{
//    [_activityView stopAnimating];
    
    self.block();
    
    [UIView animateWithDuration:.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         self.textLabel.alpha = 0.0f;
         self.statusLabel.alpha = 0.0f;
         self.viewController.view.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         [self resignKeyWindow];
         [self setHidden:YES];
     }];
}

- (void) finished
{
    [_activityView startAnimating];

    @weakify(self)
    GCD_DELAY(^{
        @strongify(self)
        if ([UserManager isValidToken]) {
            self.statusLabel.alpha = 1.0f;
            [self requestUserInfo];
        }
        else {
//            [self dismiss];
            BOOL hideGuide = [[NSUserDefaults standardUserDefaults] boolForKey:APP_VERSION];
            if (hideGuide) {
                [self requestPromotion];
            }
            else {
                [self dismiss];
            }
        }
    }, 1.0f);
}

- (void) showImageView
{
    [_activityView stopAnimating];
    self.statusLabel.alpha = 0.0f;

//    self.imageView.image = IMAGENAMED(@"start.jpg");

    @weakify(self)
    [UIView animateWithDuration:.5f
                          delay:.5f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         @strongify(self)
         self.imageView.alpha = 1.0f;
         
         
     } completion:^(BOOL finished) {
         @strongify(self)
         GCD_DELAY(^{
             [self dismiss];
         }, 3.0f);
     }];
}

#pragma mark -

- (UIViewController *) viewController
{
    if (!_viewController) {
        _viewController = [[UIViewController alloc] init];
        _viewController.view.backgroundColor = COLOR_MAIN;
        [_viewController.view addSubview:self.logoImageView];
        [_viewController.view addSubview:self.textLabel];
        [_viewController.view addSubview:self.imageView];
    }
    return _viewController;
}

- (UIImageView *) logoImageView
{
    if (!_logoImageView) {
        UIImage *image = IMAGENAMED(@"logo_w");
        _logoImageView = [[UIImageView alloc] initWithImage:image];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _logoImageView.alpha = 0.0f;
    }
    return _logoImageView;
}

- (UIImageView *) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.alpha = 0.0f;
    }
    return _imageView;
}

- (UILabel *) textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [FontUtils smallFont];
        _textLabel.textColor = WHITE_COLOR;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        
        _textLabel.text = @"© 2017-2018\n上海众旦信息科技有限公司";
        
        _textLabel.alpha = 0.0f;
    }
    return _textLabel;
}

- (UILabel *) statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [FontUtils smallFont];
        _statusLabel.textColor = WHITE_COLOR;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        
        _statusLabel.text = @"　自动登录中...";
        
        _statusLabel.alpha = 0.0f;
    }
    return _statusLabel;
}

#pragma mark -

- (void) requestUserInfo
{
    RequestUserInfo *request = [RequestUserInfo new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         // 绑定个推别名
         [GeTuiSdk bindAlias:[UserManager userId] andSequenceNum:@"seq-1"];
         //
         [self requestUserAddress];
     }
                                 onFailed:^(id content)
     {
         //
         [UserManager clearToken];
         [self dismiss];
     }
                                  onError:^(id content)
     {
         //
         [self dismiss];
     }];
}

- (void) requestUserAddress
{
    RequestAddrList *request = [RequestAddrList new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         BOOL hideGuide = [[NSUserDefaults standardUserDefaults] boolForKey:APP_VERSION];
         if (hideGuide) {
             [self requestPromotion];
         }
         else {
             [self dismiss];
         }
     }
                                 onFailed:^(id content)
     {
         //
         [self dismiss];
     }
                                  onError:^(id content)
     {
         //
         [self dismiss];
     }];
}

- (void) requestPromotion
{
    RequestIdeos *request = [RequestIdeos new];
    request.type = 0;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSString *url = response.responseData;
         if (url && url.length > 0) {
             SDWebImageManager* manager = [SDWebImageManager sharedManager];
             [manager loadImageWithURL:[NSURL URLWithString:url]
                               options:0
                              progress:nil
                             completed:^(UIImage * _Nullable image,
                                         NSData * _Nullable data,
                                         NSError * _Nullable error,
                                         SDImageCacheType cacheType,
                                         BOOL finished,
                                         NSURL * _Nullable imageURL)
              {
                  [self.imageView setImage:image];
                  [self showImageView];
              }];
         }
         else {
             [self dismiss];
         }
         
     } onFailed:^(id content) {
         [self dismiss];
     } onError:^(id content) {
         [self dismiss];
     }];
}

/*
- (void) syncProducts
{
    self.statusLabel.text = @"　数据初始化...";
    [ProductsManager syncProducts:^{
        //
        [self dismiss];
    } failed:^{
        //
        [self dismiss];
    }];
}
*/
@end
