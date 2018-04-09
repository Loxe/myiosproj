//
//  VideoPreViewController.m
//  Discovery
//
//  Created by deepin do on 2017/11/24.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import "VideoPreViewController.h"
//#import <PLPlayerKit/PLPlayerKit.h>
//#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import "ABMediaView.h"
#import "AliManger.h"
#import "RequestGetVideoInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoPreViewController ()<AliyunVodPlayerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UIView   *aliplayerView;

@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIButton *saveButton;

//@property (nonatomic, strong) UILabel  *progressLabel;

//@property (nonatomic, assign) BOOL isLock;

@property (nonatomic, assign) BOOL isFullScreen;

@end

@implementation VideoPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubViews];
    [self prepareAliEditionPlayer];      // 阿里高级播放器
    //[self prepareABMediaViewPlayer];   // ABMedia播放器
    //[self preparePLPlayer];            // PL播放器
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self.player play];                                // PL播放器-自动播放
    //[self.mediaView setAutoPlayAfterPresentation:YES]; // ABMedia播放器-自动播放
    //[self.aliPlayer setAutoPlay:YES];                  // 阿里高级播放器-自动播放
}

- (void)setVid:(NSString *)vid
{
    _vid = vid;
    
    if (vid && vid.length > 0) {
        self.saveButton.hidden = NO;
    }
}

- (void)prepareSubViews {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.dumyView.frame = self.showRect;
    [self.view addSubview:self.dumyView];
    [self.dumyView sd_setImageWithURL:[NSURL URLWithString:self.coverPath] placeholderImage:nil options:SDWebImageDelayPlaceholder];

    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:viewTap];
}

- (void)prepareAliEditionPlayer {
    
    AliyunVodPlayer *aliPlayer = [[AliyunVodPlayer alloc] init];
    self.aliPlayer = aliPlayer;
    self.aliPlayer.circlePlay = YES;
    self.aliPlayer.quality = AliyunVodPlayerVideoHD;
    self.aliPlayer.autoPlay = YES;
    
    //设置播放器代理
    aliPlayer.delegate = self;
    
    //获取播放器视图
    UIView *pv = aliPlayer.playerView;
    pv.frame = self.view.bounds;
    pv.alpha = 0.0f;
    self.aliplayerView = pv;

    //添加播放器视图到需要展示的界面上
    [self.view addSubview:pv];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
    [_activityView startAnimating];

    // 添加页面上的子控件
    [self prepareAddins];
    
    //设置缓存目录路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    //在创建播放器类,并在调用prepare方法之前设置。
    //比如：maxSize设置500M时缓存文件超过500M后会优先覆盖最早缓存的文件。
    //maxDuration设置为300秒时表示超过300秒的视频不会启用缓存功能。
    [self.aliPlayer setPlayingCache:YES saveDir:docDir maxSize:500 maxDuration:300];
    
    //MARK: 根据url来判断播放方式
    if ((self.videoPath == nil || self.videoPath.length == 0) && (self.vid == nil || self.vid.length == 0)) { // video的path和vid都不存在
        
        POPUPINFO(@"该视频不存在");
        
    } else if ((self.videoPath == nil || self.videoPath.length == 0) && (self.vid != nil && self.vid.length > 0)) { // video的path不存在、vid存在
        
        // 先判断token是否过期
        NSString *expireTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiration"];
        NSLog(@"expireTime-----> %@",expireTime);
        if (expireTime == nil) { //不存在改字段，说明没有创建过token
            [[AliManger new] requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
                if (error) {
                    NSLog(@"%@",error.description);
                    return ;
                }
                [self.aliPlayer prepareWithVid:self.vid accessKeyId:keyId accessKeySecret:keySecret securityToken:token];
            }];

        } else {

            BOOL isExpire = [[AliManger new] judgeWhetherTokenExpireWithTime:expireTime];
            if (isExpire) { //过期
                [[AliManger new] requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
                    if (error) {
                        NSLog(@"%@",error.description);
                        return ;
                    }
                    [self.aliPlayer prepareWithVid:self.vid accessKeyId:keyId accessKeySecret:keySecret securityToken:token];
                }];

            } else { //未过期
                NSString *loaclToken      = [[NSUserDefaults standardUserDefaults] objectForKey:@"secToken"];
                NSString *localKeyId      = [[NSUserDefaults standardUserDefaults] objectForKey:@"akId"];
                NSString *localKeySecret  = [[NSUserDefaults standardUserDefaults] objectForKey:@"akSecret"];
                [self.aliPlayer prepareWithVid:self.vid accessKeyId:localKeyId accessKeySecret:localKeySecret securityToken:loaclToken];
            }
        }
        
    } else {
        NSURL *url = [NSURL URLWithString:self.videoPath];
        [self.aliPlayer prepareWithURL:url];
    }
}

- (void)prepareAddins {
    
    // 全屏按钮
    [self.aliplayerView addSubview:self.fullScreenBtn];
    [self.aliplayerView addSubview:self.saveButton];
//    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.aliplayerView).offset(-20);
//        make.bottom.equalTo(self.aliplayerView).offset(-(20+kSafeAreaBottomHeight));
//        make.width.equalTo(@40);
//        make.height.equalTo(@40);
//    }];
    
    // 时间进度
//    [self.aliplayerView addSubview:self.progressLabel];
//    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.aliplayerView).offset(30);
//        make.bottom.equalTo(self.aliplayerView).offset(-30);
//        make.width.equalTo(@200);
//        make.height.equalTo(@20);
//    }];
}

//- (void)showProgress {
//    //获取播放的当前时间，单位为秒
//    NSTimeInterval currentTime = self.aliPlayer.currentTime;
//    //获取视频的总时长，单位为秒
//    NSTimeInterval duration = self.aliPlayer.duration;
//    //计算当前进度，可以把当前进度值设置给进度条在界面上显示
//    //float progress = currentTime/duration;
//
//    NSLog(@"-- 播放 %lf  总时长 %lf  --",currentTime,duration);
//    NSString *showStr = [NSString stringWithFormat:@"播放 %lf / 总时长 %lf",currentTime,duration];
//    NSLog(@"-->>>>> %@",showStr);
//    self.progressLabel.text = [NSString stringWithFormat:@"播放 %lf / 总时长 %lf",currentTime,duration];
//}

//- (void)prepareABMediaViewPlayer {
//    
//    ABMediaView *mediaView = [[ABMediaView alloc]initWithFrame:self.view.bounds];
//    self.mediaView = mediaView;
//    [mediaView setAutoPlayAfterPresentation:YES];
//    [mediaView setAllowLooping:YES];
//    [mediaView setPlayButtonHidden:YES];
//    [mediaView setCloseButtonHidden:NO];
//    mediaView.contentMode = UIViewContentModeScaleAspectFit;
//    [mediaView changeVideoToAspectFit: YES];
//    
//    [mediaView setVideoURL:self.videoPath withThumbnailURL:self.coverPath];
//    [self.view addSubview:mediaView];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
//    [mediaView addGestureRecognizer:tap];
//}

- (void)preparePLPlayer {
    
    //    PLPlayerOption *option = [PLPlayerOption defaultOption];
    //
    //    // 更改需要修改的 option 属性键所对应的值
    //    [option setOptionValue:@15 forzKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    //    [option setOptionValue:@(kPLPLAY_FORMAT_MP4) forKey:PLPlayerOptionKeyVideoPreferFormat];
    //    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    //    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    //    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    ////    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    //
    //    // 初始化 PLPlayer
    //    self.player = [PLPlayer playerWithURL:self.videoURL option:option];
    //    // 设定代理 (optional)
    //    //self.player.delegate = self;
    //
    //    self.player.launchView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.coverURL]];
    //    self.player.launchView.contentMode = UIViewContentModeScaleAspectFit;
    //    [self.view addSubview:self.player.launchView];
    //
    //    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    //    self.player.rotationMode = PLPlayerNoRotation;
    //    [self.view addSubview:self.player.playerView];
    //
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    //    [self.player.playerView addGestureRecognizer:tap];
}


#pragma mark - AliyunVodPlayerDelegate
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event {
    //这里监控播放事件回调
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
        {
            //播放准备完成时触发
            DEBUGLOG(@"AliyunVodPlayerEventPrepareDone");
//            [self.aliPlayer start];
            [self.activityView stopAnimating];
        }
            break;
            
        case AliyunVodPlayerEventPlay:
            DEBUGLOG(@"AliyunVodPlayerEventPlay");
            //暂停后恢复播放时触发
            break;
            
        case AliyunVodPlayerEventFirstFrame:
        {
            DEBUGLOG(@"AliyunVodPlayerEventFirstFrame");
            //播放视频首帧显示出来时触发
            [UIView animateWithDuration:.2f animations:^{
                self.aliplayerView.alpha = 1.0f;
//                self.dumyView.alpha = 0.0f;
            }];
        }
            break;
            
        case AliyunVodPlayerEventPause:
            DEBUGLOG(@"AliyunVodPlayerEventPause");
            //视频暂停时触发
            break;
            
        case AliyunVodPlayerEventStop:
            DEBUGLOG(@"AliyunVodPlayerEventStop");
            //主动使用stop接口时触发
            break;
            
        case AliyunVodPlayerEventFinish:
            DEBUGLOG(@"AliyunVodPlayerEventFinish");
            //视频正常播放完成时触发
            break;
            
        case AliyunVodPlayerEventBeginLoading:
            DEBUGLOG(@"AliyunVodPlayerEventBeginLoading");
            //视频开始载入时触发
            break;
            
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            DEBUGLOG(@"AliyunVodPlayerEventEndLoading");
            break;
            
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            DEBUGLOG(@"AliyunVodPlayerEventSeekDone");
            break;
            
        default:
            break;
    }
}
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(ALPlayerVideoErrorModel *)errorModel{
    //播放出错时触发，通过errorModel可以查看错误码、错误信息、视频ID、视频地址和requestId。
    ALPlayerVideoErrorModel *model = errorModel;
    NSString *show = [NSString stringWithFormat:@"%d %@",model.errorCode,model.errorMsg];
    POPUPINFO(show);
    [self.activityView stopAnimating];

    GCD_DELAY(^{
        [self close];
    }, 2.0)
}
- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer willSwitchToQuality:(AliyunVodPlayerVideoQuality)quality{
    //将要切换清晰度时触发
//    NSLog(@"willSwitchToQuality");
}
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality{
    //清晰度切换完成后触发
//    NSLog(@"didSwitchToQuality");
}
- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality{
    //清晰度切换失败触发
//    NSLog(@"failSwitchToQuality");
}

// MARK: 展示全屏的方法
- (void)displayFullScreen {
    if (!self.isFullScreen) {
        [UIView animateWithDuration:.3f animations:^{
            self.aliplayerView.bounds = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            self.aliplayerView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            self.aliplayerView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.fullScreenBtn.right = SCREEN_HEIGHT - (10+kSafeAreaBottomHeight);
            self.fullScreenBtn.bottom = SCREEN_WIDTH - 10;
            [self.fullScreenBtn setNormalImage:@"icon_exitscreen" selectedImage:nil];
        } completion:^(BOOL finished) {
            self.isFullScreen = YES;
        }];
    }
    else {
        [UIView animateWithDuration:.3f animations:^{
            self.aliplayerView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.aliplayerView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            self.aliplayerView.transform = CGAffineTransformMakeRotation(0);
            self.fullScreenBtn.right = SCREEN_WIDTH - 10;
            self.fullScreenBtn.bottom = SCREEN_HEIGHT - (10+kSafeAreaBottomHeight);
            [self.fullScreenBtn setNormalImage:@"icon_fullscreen" selectedImage:nil];
        } completion:^(BOOL finished) {
            self.isFullScreen = NO;
        }];
    }
}

- (void)close {
    [self.aliPlayer stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 下载视频

- (IBAction)downloadAction:(id)sender
{
    [SVProgressHUD showWithStatus:@"视频下载中，请稍候..."];
    [self requestVideoInfo:self.vid];
}

- (void) requestVideoInfo:(NSString *)videoId
{
    RequestGetVideoInfo *request = [RequestGetVideoInfo new];
    request.videoId = videoId;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         VideoInfo *videoInfo = [VideoInfo yy_modelWithDictionary:response.responseData];
         [self downloadVideo:videoInfo.playURL name:videoInfo.title];
         
     } onFailed:^(id content) {
         
     }];
}

- (void) downloadVideo:(NSString *)videoUrl name:(NSString *)videoName
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/video.mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    [SCHttpServiceFace serviceWithDownloadURL:videoUrl
                                         path:path
                                        onSuc:^(id content)
     {
         // 从沙盒保存到相册
         [self saveVideo:[NSURL URLWithString:path] fileName:videoName];
     }
                                      onError:^(id content)
     {
         [SVProgressHUD showErrorWithStatus:@"下载视频出错了"];
     }];
}

- (void) saveVideo:(NSURL*)url fileName:(NSString *)fileName
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:url
                                completionBlock:^(NSURL *assetURL, NSError *error)
     {
         if (error) {
             NSLog(@"保存视频到相册失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"保存视频到相册失败"];
         }
         else {
             [SVProgressHUD showSuccessWithStatus:@"视频已保存至相册"];
         }
     }];
}

// 在当前控制器中添加是否允许旋转的事件
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    if (self.isLock) {
//        return toInterfaceOrientation = UIInterfaceOrientationPortrait;
//    }else{
//        return YES;
//    }
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (BOOL)shouldAutorotate {
//    return !self.isLock;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if (self.isLock) {
//        return UIInterfaceOrientationMaskPortrait;
//    } else {
//        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
//    }
//}

#pragma mark - LAZY
- (UIButton *)fullScreenBtn {
    if (_fullScreenBtn == nil) {
        _fullScreenBtn = [[UIButton alloc] init];
        _fullScreenBtn.frame = CGRectMake(0, 0, 40, 40);
        _fullScreenBtn.right = SCREEN_WIDTH - 10;
        _fullScreenBtn.bottom = SCREEN_HEIGHT - (10+kSafeAreaBottomHeight);
        
        [_fullScreenBtn setNormalImage:@"icon_fullscreen" selectedImage:nil];
        
//        _fullScreenBtn.titleLabel.font = FA_ICONFONTSIZE(20);
//        [_fullScreenBtn setTitle:@"\uF065" forState:UIControlStateNormal];
//        [_fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(displayFullScreen) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
        _saveButton.centerY = self.fullScreenBtn.centerY;
        _saveButton.right = self.fullScreenBtn.left - kOFFSET_SIZE;
        
        _saveButton.titleLabel.font = ICON_FONT(20);
        [_saveButton setTitle:kIconDownload forState:UIControlStateNormal];
        [_saveButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_saveButton setTitleColor:COLOR_SELECTED forState:UIControlStateHighlighted];
        
        [_saveButton addTarget:self action:@selector(downloadAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
        _saveButton.hidden = YES;
    }
    return _saveButton;
}

//- (UILabel *)progressLabel {
//    if (_progressLabel == nil) {
//        _progressLabel = [[UILabel alloc]init];
//        _progressLabel.textColor = [UIColor orangeColor];
//        _progressLabel.font = [UIFont systemFontOfSize:16];
//    }
//    return _progressLabel;
//}

- (UIImageView *)dumyView {
    if (_dumyView == nil) {
        _dumyView = [[UIImageView alloc]init];
        _dumyView.contentMode = UIViewContentModeScaleAspectFill;
//        _dumyView.backgroundColor = RED_COLOR;
    }
    return _dumyView;
}


@end

