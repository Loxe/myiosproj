//
//  FriendListCell.h
//  akucun
//
//  Created by deepin do on 2018/2/27.
//  Copyright © 2018年 Sucang. All rights reserved.
//
#define kAvatorWH        30
#define kLiveProgressH   10
#define kMargin          10
#define kNameItemW       (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kMargin)*0.4
#define kLevelItemW      (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kMargin)*0.3
#define kProgresItemW    (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kMargin)*0.3

#import <UIKit/UIKit.h>
#import "DDProgressView.h"
#import "Member.h"

@interface FriendListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatorImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *levelLabel;

@property (nonatomic, strong) UILabel *livenessLabel;

@property (nonatomic, strong) DDProgressView *livenessProgress;

@property (nonatomic, strong) UIView  *separateLine;

@property (nonatomic, assign) CGFloat trackLength;

@property (nonatomic, strong) NSString *livenessStr;

@property (nonatomic, strong) Member *model;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) BOOL usershadow; // 是否是关联账号的显示

- (void)setTrackLength:(CGFloat)trackLength andLivenessStr:(NSString *)livenessStr;

@end
