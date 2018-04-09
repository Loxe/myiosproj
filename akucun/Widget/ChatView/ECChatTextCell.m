//
//  ECChatTextCell.m
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECChatTextCell.h"

@implementation ECChatTextCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chatLabel];
    }
    return self;
}

- (void) setModelFrame:(ECChatMsgFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    
    self.chatLabel.frame = modelFrame.chatLabelF;
    self.chatLabel.text = modelFrame.model.content;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *) chatLabel
{
    if (nil == _chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.numberOfLines = 0;
        _chatLabel.font = [FontUtils normalFont];
        _chatLabel.textColor = COLOR_TEXT_DARK;
    }
    return _chatLabel;
}

@end
