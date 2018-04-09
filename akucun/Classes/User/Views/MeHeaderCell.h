//
//  MeHeaderCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"
#import "TextButton.h"
#import "SCImageView.h"

#define kAvatorWH     50
#define kProgressH    10
#define kProgressw    150

@protocol MeHeaderCellDelegate <NSObject>

- (void)didSelectMeHeaderCellTag:(NSInteger)index;

@end

typedef void(^LevelRuleBlock)(id nsobject);

@interface MeHeaderCell : UITableViewCell

@property (nonatomic, strong) SCImageView *avatorImgView;

@property (nonatomic, strong) UIImageView *authImgView;

@property (nonatomic, strong) TextButton *nameLabel;

@property (nonatomic, strong) UILabel *vipLevelLabel;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *codeTitleLabel;

@property (nonatomic, strong) UILabel *codeLabel;

@property (nonatomic, strong) DDProgressView *progressView;

@property (nonatomic, strong) UILabel *saleCountLabel;

@property (nonatomic, assign) CGFloat trackLength;

@property (nonatomic, assign) CGFloat trackPercent;

@property (nonatomic, strong) NSString *saleCountStr;

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) TextButton *levelRuleBtn;

@property (nonatomic, copy) LevelRuleBlock levelRuleBlock;

@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UIButton *rechargeButton;

@property (nonatomic, copy) voidBlock avatarBlock;
@property (nonatomic, copy) voidBlock rechargeBlock;
@property (nonatomic, copy) voidBlock accountBlock;


//- (void)setTrackLength:(CGFloat)trackLength andSaleCountStr:(NSString *)saleCountStr;
- (void)setTrackPercent:(CGFloat)trackPercent andSaleCountStr:(NSString *)saleCountStr;

- (void)setAuthened:(BOOL)isAuthed;

- (void)updateData;

@end

