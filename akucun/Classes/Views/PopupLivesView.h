//
//  PopupLivesView.h
//  akucun
//
//  Created by Jarry Z on 2018/3/20.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "OptionsPopupView.h"
#import "LiveInfo.h"

@interface PopupLivesView : OptionsPopupView


- (instancetype) initWithTitle:(NSString *)title
                         lives:(NSArray *)lives
                      selected:(NSInteger)index;

@end

@interface LivesPopupCell : OptionPopupCell

@property (nonatomic, strong) UILabel *newLabel;
@property (nonatomic, strong) UIImageView *vipIconView;
@property (nonatomic, strong) UIImageView *qiangIconView;

@property (nonatomic, strong) LiveInfo *liveInfo;

@end
