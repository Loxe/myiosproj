//
//  MeMoreCell.m
//  akucun
//
//  Created by deepin do on 2018/1/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kItemWH     60
#define kItemMargin (SCREEN_WIDTH-2*kOFFSET_SIZE-4*kItemWH)/3-10


#import "MeMoreCell.h"
#import "MoreCollectionCell.h"
#import "UserManager.h"
#import "UserGuideManager.h"

@interface MeMoreCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MeMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareData];
        [self setupUI];
    }
    return self;
}

- (void)updateItemAt:(NSInteger)index {
    
    MoreCollectionCell *cell = (MoreCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (!cell) {
        return;
    }
    
    cell.badgeBgColor = COLOR_SELECTED;
    cell.badgeCenterOffset = CGPointMake(-12, 3);
    [cell clearBadge];

    if (index == 5) { // 新的邀请需要开通
        UserInfo *userInfo = [UserManager instance].userInfo;
        if (userInfo.inviteCount > 0) { // 新的邀请
            [cell showBadgeWithStyle:WBadgeStyleNumber value:userInfo.inviteCount animationType:WBadgeAnimTypeBounce];
        }
        else {
            [cell showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeBounce];
        }
    }
    else if (index == 6) {
        [cell showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeBounce];
    }
}

- (void)showGuideAt:(NSInteger)index {
    MoreCollectionCell *cell = (MoreCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (!cell) {
        return;
    }
    
    if (index == 5) { // 新的邀请需要开通
        UserInfo *userInfo = [UserManager instance].userInfo;
        if (userInfo.inviteCount > 0) { // 新的邀请
            [UserGuideManager createUserGuide:kUserGuideNewInvitation title:@"您有新的好友加入啦，\n实时关注您的好友列表" focusedView:cell offset:18];
        }
        else {
            [UserGuideManager createUserGuide:kUserGuideFuncInvite title:@"爱库存邀请奖励机制全新推出，快去邀请好友加入吧" focusedView:cell offset:18];
        }
    }
    else if (index == 6) {
        [UserGuideManager createUserGuide:kUserGuideNewTeam title:@"您有新的好友加入啦，\n实时关注您的好友列表" focusedView:cell offset:18];
    }
}

- (void)prepareData {

    self.btnBGColorArray = [NSMutableArray arrayWithArray:@[RGBCOLOR(231, 100, 100), COLOR_APP_RED, RGBCOLOR(0x48, 0xCD, 0x3D), RGBCOLOR(104, 200, 250), RGBCOLOR(0xFF, 0x92, 0x04)]];

    self.btnTitleArray  = [NSMutableArray arrayWithArray:@[@"个人账单", @"客户对账", @"扫码分拣", @"申请售后", @"联系客服"]];
    self.btnImgArray    = [NSMutableArray arrayWithArray:@[@"jiaoyi", @"duizhang", @"scan", @"feed", @"customer"]];
    self.btnTagArray    = [NSMutableArray arrayWithArray:@[@KPersonOrderTag,@KCustomerCheckTag,@KScanPickingTag,@KApplyFeedTag,@KCustomerServiceTag]];
    
//    /** 获取当前登录用户的信息 */
//    UserInfo *userInfo = [UserManager instance].userInfo;
//    BOOL inviteStatus  = userInfo.prcstatu;
//    if (inviteStatus) {
//        [self.btnTitleArray addObject:@"邀请好友"];
//        [self.btnImgArray addObject:@"invite"];
//        [self.btnTagArray addObject:@KInviteFriendTag];
//    }
//    if (userInfo.memberCount > 0) {
//        [self.btnTitleArray addObject:@"我的团队"];
//        [self.btnImgArray addObject:@"tongji"];
//        [self.btnTagArray addObject:@KMyTeamTag];
//    }

}

- (void)setupUI {
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.btnImgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCollectionCell" forIndexPath:indexPath];
    
    cell.badgeBgColor = COLOR_SELECTED;
    cell.badgeCenterOffset = CGPointMake(-12, 3);
    [cell clearBadge];
    
    // 获取数据，并赋值
    UIColor  *color = self.btnBGColorArray[indexPath.item];
    UIImage  *img   = [UIImage imageNamed:self.btnImgArray[indexPath.item]];
    NSString *title = self.btnTitleArray[indexPath.item];
    [cell updateUIWith:img imgBGColor:color title:title];
    
//    if (indexPath.item == 4 || indexPath.item == 5 || indexPath.item == 6) {
//        [cell.noticeLabel setHidden:NO];
//        cell.nameLabel.textColor = COLOR_TEXT_LIGHT;
//    }
    
//    if (indexPath.item == 6) {
//        [cell showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeBounce];
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectMeMoreCellTag:)]) {
        [self.delegate didSelectMeMoreCellTag:[self.btnTagArray[indexPath.item] integerValue]];
    }
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kItemWH, kItemWH);
        flowLayout.minimumLineSpacing      = kOFFSET_SIZE;
        flowLayout.minimumInteritemSpacing = kItemMargin;
        flowLayout.sectionInset = UIEdgeInsetsMake(kOFFSET_SIZE, kOFFSET_SIZE, kOFFSET_SIZE, kOFFSET_SIZE);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.frame collectionViewLayout:flowLayout];
        _collectionView = collectionView;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource      = self;
        collectionView.delegate        = self;
        collectionView.showsVerticalScrollIndicator   = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        collectionView.pagingEnabled = NO;
        collectionView.bounces       = NO;
        
        //注册cell
        [collectionView registerClass:[MoreCollectionCell class] forCellWithReuseIdentifier:@"MoreCollectionCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)btnTitleArray {
    if (_btnTitleArray == nil) {
        _btnTitleArray = [NSMutableArray array];
    }
    return _btnTitleArray;
}

- (NSMutableArray *)btnImgArray {
    if (_btnImgArray == nil) {
        _btnImgArray = [NSMutableArray array];
    }
    return _btnImgArray;
}

- (NSMutableArray *)btnBGColorArray {
    if (_btnBGColorArray == nil) {
        _btnBGColorArray = [NSMutableArray array];
    }
    return _btnBGColorArray;
}

- (NSMutableArray *)btnTagArray {
    if (_btnTagArray == nil) {
        _btnTagArray = [NSMutableArray array];
    }
    return _btnTagArray;
}

@end
