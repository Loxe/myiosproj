//
//  VideoPreViewController.h
//  Discovery
//
//  Created by deepin do on 2017/11/24.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <PLPlayer.h>
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>

@interface VideoPreViewController : UIViewController

//@property (nonatomic, strong)  PLPlayer *player;
//@property(nonatomic, strong) ABMediaView *mediaView;

@property(nonatomic, strong) AliVcMediaPlayer    *mediaPlayer;
@property(nonatomic, strong) AliyunVodPlayer     *aliPlayer;
//@property(nonatomic, strong) AliyunVodPlayerView *uiPlayerView;
@property(nonatomic, strong) NSString            *vid;

//@property (nonatomic, strong)  NSURL     *videoURL;
//@property (nonatomic, strong)  NSURL     *coverURL;

@property (nonatomic, strong)  NSString  *videoPath;
@property (nonatomic, strong)  NSString  *coverPath;

@property (nonatomic, strong)  UIImageView  *dumyView;
@property (nonatomic, assign)  CGRect       showRect;


@end

