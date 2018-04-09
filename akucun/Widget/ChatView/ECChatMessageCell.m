//
//  ECChatMessageCell.m
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECChatMessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserManager.h"

@implementation ECChatMessageCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
        
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longRecognizer];
    }
    return self;
}

- (void) setupUI
{
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
}

- (void) setModelFrame:(ECChatMsgFrame *)modelFrame
{
    _modelFrame = modelFrame;
    
    [self.activityView setHidden:YES];
    [self.retryButton setHidden:YES];
    
    ChatMsg *message = modelFrame.model;
    self.headImageView.frame = modelFrame.headImageViewF;
    self.bubbleView.frame = modelFrame.bubbleViewF;
    if (message.isSender) {    // 发送者
        self.activityView.frame  = modelFrame.activityF;
        self.retryButton.frame   = modelFrame.retryButtonF;
        /*
        switch (message.deliveryState) { // 发送状态
            case ICMessageDeliveryState_Delivering:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
            case ICMessageDeliveryState_Delivered:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
                
            }
                break;
            case ICMessageDeliveryState_Failure:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }*/
        
//        self.bubbleView.tintColor = COLOR_SELECTED;
        
        UserInfo *userInfo = [UserManager instance].userInfo;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]
                              placeholderImage:IMAGENAMED(@"icon_user_default")
                                       options:SDWebImageDelayPlaceholder];
        
        UIImage *image = [[IMAGENAMED(@"bg_chat_msg2") stretchableImageWithLeftCapWidth:15 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.bubbleView.image = image;
        self.bubbleView.tintColor = COLOR_SELECTED;
    }
    else {    // 接收者
        [self.headImageView setImage:[UIImage imageNamed:@"logo"]];
        
        self.bubbleView.image = [IMAGENAMED(@"bg_chat_msg") stretchableImageWithLeftCapWidth:15 topCapHeight:30];

    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.headImageView.layer.cornerRadius = self.headImageView.width/2.0f;
}

#pragma mark - longPress delegate

- (void) longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{

}

#pragma mark - Getter and Setter

- (UIImageView *) headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = IMAGENAMED(@"icon_user_default");
        
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UIImageView *) bubbleView
{
    if (_bubbleView == nil) {
        _bubbleView = [[UIImageView alloc] init];
//        UIImage *image = [IMAGENAMED(@"bg_chat_msg") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        _bubbleView.image = IMAGENAMED(@"bg_chat_msg");
//        _bubbleView.tintColor = WHITE_COLOR;
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *) activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *) retryButton
{
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
//        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

@end
