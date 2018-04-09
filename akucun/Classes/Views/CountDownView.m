//
//  CountDownView.m
//  akucun
//
//  Created by Jarry on 2017/7/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CountDownView.h"

@interface CountDownView ()
{
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *hourLabel, *minuteLabel, *secondLabel;
@property (nonatomic, strong) UILabel *colonLabel1, *colonLabel2;

@property (nonatomic, assign) NSTimeInterval timeout;

@end

@implementation CountDownView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.colonLabel1];
    [self addSubview:self.colonLabel2];

    return self;
}

- (void) dealloc
{
    [self cancelTimer];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void) setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void) setLiveTime:(NSTimeInterval)liveTime
{
    _liveTime = liveTime;
    
    NSTimeInterval delta = liveTime - [NSDate timeIntervalValue];
    if (delta > 24*3600) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:liveTime];
//        self.timeLabel.text = [date formattedDateWithFormatString:@"MM/dd HH:mm"];
//        [self.timeLabel sizeToFit];
        self.timeLabel.hidden = NO;
        self.timeout = 0;
        [self cancelTimer];
        int days = (int)(delta/(24*3600));
        int f = (int)delta%(24*3600);
        if (f > 6*3600) {
            days ++;
        }
        self.hourLabel.text = kIntToString(days);
        
        self.hourLabel.hidden = NO;
        self.minuteLabel.hidden = YES;
        self.secondLabel.hidden = YES;
        self.colonLabel1.hidden = YES;
        self.colonLabel2.hidden = YES;
    }
    else if (delta > 0) {
        self.timeLabel.hidden = YES;
        self.timeout = delta;
        [self startTimer];
        
        self.hourLabel.hidden = NO;
        self.minuteLabel.hidden = NO;
        self.secondLabel.hidden = NO;
        self.colonLabel1.hidden = NO;
        self.colonLabel2.hidden = NO;
    }
    else if (delta <= 0) {
        self.timeLabel.hidden = YES;
        self.timeout = 0;
        [self cancelTimer];
        
        self.hourLabel.hidden = YES;
        self.minuteLabel.hidden = YES;
        self.secondLabel.hidden = YES;
        self.colonLabel1.hidden = YES;
        self.colonLabel2.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (void) startTimer
{
    if (_timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0);
        dispatch_resume(_timer);
    }
    
    @weakify(self)
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)
        if (self.timeout <= 0) { //倒计时结束，关闭
            [self cancelTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hourLabel.text = @"00";
                self.minuteLabel.text = @"00";
                self.secondLabel.text = @"00";
                if (self.timeoutBlock) {
                    self.timeoutBlock();
                }
            });
        }
        else {
            int hours = (int)((self.timeout)/3600);
            int minute = (int)(self.timeout - hours*3600)/60;
            int second = self.timeout - hours*3600 - minute*60;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (hours < 10) {
                    self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                } else {
                    self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                }
                if (minute < 10) {
                    self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                } else {
                    self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                }
                if (second < 10) {
                    self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                } else {
                    self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                }
                
            });
            self.timeout --;
        }
    });
    
}

- (void) cancelTimer
{
    if (_timer == nil) {
        return;
    }
    dispatch_source_cancel(_timer);
    _timer = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.hourLabel.text = @"00";
//        self.minuteLabel.text = @"00";
//        self.secondLabel.text = @"00";
//    });
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.timeLabel.hidden) {
//        if (isIPhone5) {
            self.titleLabel.top = 0.0f;
            self.hourLabel.top = self.titleLabel.bottom + 3.0f;
            self.hourLabel.centerX = self.titleLabel.centerX - self.timeLabel.width*0.5 - 3.0f;
            self.timeLabel.left = self.hourLabel.right + 5.0f;
//        }
//        else {
//            self.hourLabel.top = 0.0f;
//            self.titleLabel.bottom = self.hourLabel.bottom;
//            self.hourLabel.left = self.titleLabel.right + 2.0f;
//            self.timeLabel.left = self.hourLabel.right + 2.0f;
//        }
        self.timeLabel.bottom = self.hourLabel.bottom;
        self.height = self.hourLabel.bottom;
    }
    else {
        self.titleLabel.top = 0.0f;
        self.hourLabel.top = 0.0f;
        self.hourLabel.left = 0.0f;
        if (self.title && self.title.length > 0) {
            self.hourLabel.top = self.titleLabel.bottom + 3.0f;
        }

        self.colonLabel1.left = self.hourLabel.right + 2.0f;
        self.colonLabel1.centerY = self.hourLabel.centerY;

        self.minuteLabel.top = self.hourLabel.top;
        self.minuteLabel.left = self.colonLabel1.right + 2.0f;
        
        self.colonLabel2.left = self.minuteLabel.right + 2.0f;
        self.colonLabel2.centerY = self.minuteLabel.centerY;

        self.secondLabel.top = self.hourLabel.top;
        self.secondLabel.left = self.colonLabel2.right + 2.0f;
        
        if (self.hourLabel.hidden) {
            self.height = self.titleLabel.bottom;
        }
        else {
            self.height = self.hourLabel.bottom;
        }
        
        if (!self.title || self.title.length == 0) {
            self.height = 20;
            self.width = self.secondLabel.right;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RED_COLOR;
        _titleLabel.font = SYSTEMFONT(12);
    }
    return _titleLabel;
}

- (UILabel *) timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RED_COLOR;
        _timeLabel.font = SYSTEMFONT(12);
        _timeLabel.text = @"天";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *) hourLabel
{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
        _hourLabel.layer.backgroundColor = COLOR_SELECTED.CGColor;
        _hourLabel.textColor = WHITE_COLOR;
        _hourLabel.font = [FontUtils buttonFont];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.adjustsFontSizeToFitWidth = YES;
        
        _hourLabel.layer.masksToBounds = NO;
        _hourLabel.layer.cornerRadius = 2.0f;
    }
    return _hourLabel;
}

- (UILabel *) minuteLabel
{
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
        _minuteLabel.layer.backgroundColor = COLOR_SELECTED.CGColor;
        _minuteLabel.textColor = WHITE_COLOR;
        _minuteLabel.font = [FontUtils buttonFont];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        
        _minuteLabel.layer.masksToBounds = NO;
        _minuteLabel.layer.cornerRadius = 2.0f;
    }
    return _minuteLabel;
}

- (UILabel *) secondLabel
{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
        _secondLabel.layer.backgroundColor = COLOR_SELECTED.CGColor;
        _secondLabel.textColor = WHITE_COLOR;
        _secondLabel.font = [FontUtils buttonFont];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        
        _secondLabel.layer.masksToBounds = NO;
        _secondLabel.layer.cornerRadius = 2.0f;
    }
    return _secondLabel;
}

- (UILabel *) colonLabel1
{
    if (!_colonLabel1) {
        _colonLabel1 = [[UILabel alloc] init];
        _colonLabel1.textColor = COLOR_SELECTED;
        _colonLabel1.font = [FontUtils buttonFont];
        _colonLabel1.textAlignment = NSTextAlignmentCenter;
        _colonLabel1.text = @":";
        [_colonLabel1 sizeToFit];
        _colonLabel1.height = 20;
    }
    return _colonLabel1;
}
- (UILabel *) colonLabel2
{
    if (!_colonLabel2) {
        _colonLabel2 = [[UILabel alloc] init];
        _colonLabel2.textColor = COLOR_SELECTED;
        _colonLabel2.font = [FontUtils buttonFont];
        _colonLabel2.textAlignment = NSTextAlignmentCenter;
        _colonLabel2.text = @":";
        [_colonLabel2 sizeToFit];
        _colonLabel2.height = 20;
    }
    return _colonLabel2;
}

@end
