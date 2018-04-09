//
//  FriendSectionHeader.h
//  akucun
//
//  Created by deepin do on 2018/2/27.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kTopH        60
#define kBottomH     26
#define kRowMargin   10
#define kInviteW     (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kRowMargin)*0.4
#define kVip0W       (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kRowMargin)*0.3
#define kLostW       (SCREEN_WIDTH-2*kOFFSET_SIZE-2*kRowMargin)*0.3

#import <UIKit/UIKit.h>

@interface FriendSectionHeader : UIView

@property(nonatomic, strong) UILabel  *invitedTotalLabel;
@property(nonatomic, strong) UILabel  *invitedTotalCount;

@property(nonatomic, strong) UILabel  *vip0Label;
@property(nonatomic, strong) UILabel  *vip0Count;

@property(nonatomic, strong) UILabel  *lostLabel;
@property(nonatomic, strong) UILabel  *lostCount;

@property(nonatomic, strong) UIView  *separateLine;

@property(nonatomic, strong) UILabel  *friendLabel;
@property(nonatomic, strong) UILabel  *livenessLabel;
@property(nonatomic, strong) UIButton *levelLabel;  // ▴▼▲▾

@property(nonatomic, strong) UIView  *bottomLine;

@property(nonatomic, assign) NSInteger vipFlag;
@property(nonatomic, copy) intBlock actionBlock;

- (void)setInvitedCount:(NSInteger)invitedCount activeCount:(NSInteger)activeCount andLostCount:(NSInteger)lostCount;

@end
