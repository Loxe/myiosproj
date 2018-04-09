//
//  MessageCell.m
//  akucun
//
//  Created by Jarry on 2017/7/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (nonatomic, strong) UILabel *iconLabel;

@end

@implementation MessageCell

- (void) updateData
{
    MessageCellLayout *cellLayout = (MessageCellLayout *)self.cellLayout;
    if (cellLayout.model.readflag == 0) {
        self.iconLabel.textColor = COLOR_SELECTED;
    }
    else {
        self.iconLabel.textColor = COLOR_TEXT_NORMAL;
    }
}

- (void) initContent
{
    _iconLabel = [[UILabel alloc] init];
    _iconLabel.font = FA_ICONFONTSIZE(26);
    _iconLabel.text = FA_ICONFONT_MSG2;
    _iconLabel.textColor = COLOR_TEXT_NORMAL;
    [_iconLabel sizeToFit];
    [self.contentView addSubview:_iconLabel];
}

- (void) customLayoutViews
{
    self.iconLabel.left = kOFFSET_SIZE;
    self.iconLabel.top = isPad ? 20 : kOFFSET_SIZE;
}

@end
