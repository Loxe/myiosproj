//
//  PopupLivesView.m
//  akucun
//
//  Created by Jarry Z on 2018/3/20.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "PopupLivesView.h"

@implementation PopupLivesView

- (instancetype) initWithTitle:(NSString *)title
                         lives:(NSArray *)lives
                      selected:(NSInteger)index
{
    self = [self initWithTitle:title options:lives selected:index];
    if (self) {
        self.offset = kOFFSET_SIZE;
    }
    return self;
}

#pragma mark - TableViewDatasouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LivesPopupCell * cell = [[LivesPopupCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.offset = self.offset;

    id item = self.options[indexPath.row];
    if ([item isKindOfClass:[LiveInfo class]]) {
        cell.liveInfo = item;
    }
    else {
        cell.nameLabel.text = item;
        cell.imageUrl = @"";
    }
    
    if (self.selectedIndex == indexPath.row) {
        cell.nameLabel.textColor = COLOR_APP_RED;
        cell.detailTextLabel.text = FA_ICONFONT_SELECT;
    }
    else {
        cell.nameLabel.textColor = COLOR_TEXT_DARK;
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

@end

@implementation LivesPopupCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self.contentView addSubview:self.newLabel];
    [self.contentView addSubview:self.vipIconView];
    [self.contentView addSubview:self.qiangIconView];

//    [self.logoImage mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
//        make.width.height.mas_equalTo(@(26));
//    }];
    
//    [self.vipIconView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.nameLabel.mas_right).offset(5);
//        make.width.mas_equalTo(@(38));
//        make.height.mas_equalTo(@(16));
//    }];
//    [self.newLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.vipIconView.mas_right).offset(5);
//        make.width.mas_equalTo(@(25));
//        make.height.mas_equalTo(@(14));
//    }];
    
    return self;
}

- (void) setLiveInfo:(LiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    
    NSInteger levelFlag = [liveInfo levelFlag];
    BOOL isNew = [liveInfo isTodayLive];
    
    self.newLabel.hidden = !isNew;
    self.vipIconView.hidden = (levelFlag <= 0);
    self.qiangIconView.hidden = !liveInfo.isTop;
    
    CGFloat maxWidth = SCREEN_WIDTH-56-2.8*kOFFSET_SIZE;
    if (isNew && levelFlag > 0) {
        maxWidth = SCREEN_WIDTH-56-2.8*kOFFSET_SIZE - 75;
    }
    else if (levelFlag > 0) {
        maxWidth = SCREEN_WIDTH-56-2.8*kOFFSET_SIZE - 40;
    }
    else if (isNew) {
        maxWidth = SCREEN_WIDTH-56-2.8*kOFFSET_SIZE - 40;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(1.8*kOFFSET_SIZE+26);
        make.width.lessThanOrEqualTo(@(maxWidth));
    }];
    
    MASViewAttribute *newAttribute = self.nameLabel.mas_right;
    MASViewAttribute *iconAttribute = self.nameLabel.mas_right; // qiang
    if (levelFlag > 0) {
        NSString *imgName = FORMAT(@"icon_vip%ld",(long)levelFlag);
        self.vipIconView.image = IMAGENAMED(imgName);
        
        [self.vipIconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.width.mas_equalTo(@(38));
            make.height.mas_equalTo(@(16));
        }];
        newAttribute = self.vipIconView.mas_right;
        iconAttribute = self.vipIconView.mas_right;
    }
    
    if (isNew) {
        [self.newLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(newAttribute).offset(5);
            make.width.mas_equalTo(@(25));
            make.height.mas_equalTo(@(14));
        }];
        iconAttribute = self.newLabel.mas_right;
    }
    
    if (liveInfo.isTop) {
        [self.qiangIconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-2);
            make.left.equalTo(iconAttribute).offset(5);
            make.width.mas_equalTo(@(26));
            make.height.mas_equalTo(@(24));
        }];
    }
    
    self.nameLabel.text = liveInfo.pinpaiming;
    self.imageUrl = liveInfo.pinpaiurl;
}

- (UILabel *) newLabel
{
    if (!_newLabel) {
        _newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 14)];
        _newLabel.backgroundColor     = COLOR_MAIN;
        _newLabel.layer.cornerRadius  = 2.0;
        _newLabel.layer.masksToBounds = YES;
        _newLabel.textColor = WHITE_COLOR;
        _newLabel.font = BOLDSYSTEMFONT(9);
        _newLabel.textAlignment = NSTextAlignmentCenter;
        _newLabel.text = @"New";
        _newLabel.hidden = YES;
    }
    return _newLabel;
}

- (UIImageView *) vipIconView
{
    if (!_vipIconView) {
        _vipIconView = [[UIImageView alloc] init];
        _vipIconView.frame = CGRectMake(0, 0, 38, 16);
        _vipIconView.contentMode = UIViewContentModeScaleAspectFit;
        _vipIconView.hidden = YES;
    }
    return _vipIconView;
}

- (UIImageView *) qiangIconView
{
    if (!_qiangIconView) {
        _qiangIconView = [[UIImageView alloc] init];
        _qiangIconView.frame = CGRectMake(0, 0, 26, 24);
        _qiangIconView.contentMode = UIViewContentModeScaleAspectFit;
        _qiangIconView.image = IMAGENAMED(@"icon_qiang");
        _qiangIconView.hidden = YES;
    }
    return _qiangIconView;
}

@end
