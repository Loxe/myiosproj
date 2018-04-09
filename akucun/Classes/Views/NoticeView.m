//
//  NoticeView.m
//  akucun
//
//  Created by Jarry on 2017/4/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "NoticeView.h"

@interface NoticeView ()

@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation NoticeView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    
    self.width = SCREEN_WIDTH;
    
    [self addSubview:self.noticeLabel];
    [self addSubview:self.contentLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, kPIXEL_WIDTH)];
    _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [self addSubview:_lineView];

    [self updateLayout];

    return self;
}

- (void) updateNotice:(NSString *)notice
              content:(NSString *)content
{
    _notice = notice;
    
    if (notice && notice.length > 0) {
        self.noticeLabel.text = FORMAT(@"公告：%@", notice);
        [self.noticeLabel sizeToFit];
    }
    
    if (content && content.length > 0) {
        self.contentLabel.text = content;
        [self.contentLabel sizeToFit];
    }
    
    self.contentLabel.hidden = (content.length == 0);
    
    [self updateLayout];
}

- (void) updateMessage:(NSString *)message
{
    if (message && message.length > 0) {
        self.noticeLabel.text = message;
        [self.noticeLabel sizeToFit];
    }
    self.contentLabel.hidden = YES;
    [self updateLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayout];
}

- (void) updateLayout
{
    self.noticeLabel.top = kOFFSET_SIZE*0.5;
    self.noticeLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    self.contentLabel.top = self.noticeLabel.bottom + 5;
    self.contentLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
    
    if (self.contentLabel.hidden) {
        self.lineView.top = self.noticeLabel.bottom + kOFFSET_SIZE*0.5;
    }
    else {
        self.lineView.top = self.contentLabel.bottom + kOFFSET_SIZE*0.5;
    }
    self.height = self.lineView.bottom;
}

- (UILabel *) noticeLabel
{
    if (!_noticeLabel) {
        _noticeLabel  = [[UILabel alloc] init];
        _noticeLabel.backgroundColor = CLEAR_COLOR;
        _noticeLabel.left = kOFFSET_SIZE;
        _noticeLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
        _noticeLabel.textColor = COLOR_SELECTED;
        _noticeLabel.font = [FontUtils normalFont];
        _noticeLabel.text = @"公告：";
        _noticeLabel.numberOfLines = 0;
        [_noticeLabel sizeToFit];
    }
    return _noticeLabel;
}

- (UILabel *) contentLabel
{
    if (!_contentLabel) {
        _contentLabel  = [[UILabel alloc] init];
        _contentLabel.backgroundColor = CLEAR_COLOR;
        _contentLabel.left = kOFFSET_SIZE;
        _contentLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
        _contentLabel.textColor = COLOR_TEXT_DARK;
        _contentLabel.font = [FontUtils normalFont];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
