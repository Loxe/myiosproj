//
//  MeMoreCell.h
//  akucun
//
//  Created by deepin do on 2018/1/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define KPersonOrderTag     52001  //个人账单
#define KCustomerCheckTag   52002  //客户对账
#define KScanPickingTag     52003  //扫码分拣
#define KApplyFeedTag       52004  //申请售后
#define KCustomerServiceTag 52005  //联系客服
#define KInviteFriendTag    52006  //邀请好友
#define KMyTeamTag          52007  //我的团队

#import <UIKit/UIKit.h>


@protocol MeMoreCellDelegate <NSObject>

- (void)didSelectMeMoreCellTag:(NSInteger)index;

@end

@interface MeMoreCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *btnTitleArray;

@property(nonatomic, strong) NSMutableArray *btnImgArray;

@property(nonatomic, strong) NSMutableArray *btnBGColorArray;

@property(nonatomic, strong) NSMutableArray *btnTagArray;

@property (nonatomic, weak) id <MeMoreCellDelegate> delegate;

- (void)updateItemAt:(NSInteger)index;

- (void)showGuideAt:(NSInteger)index;

@end
