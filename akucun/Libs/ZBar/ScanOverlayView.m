//
//  ScanOverlayView.m
//  EachingMobile
//
//  Created by Jarry on 15/7/2.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import "ScanOverlayView.h"
#import <POP/POP.h>

@implementation ScanOverlayView
{
    CGFloat _offsetX, _offsetY;
    CGFloat _frameWidth;
}

- (id) initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame title:@"扫一扫"];
}

- (id) initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEAR_COLOR;
        
        _offsetX = 30;
        _frameWidth = self.width - _offsetX * 2;
        _offsetY = (self.height - _frameWidth)/2 - 30;

        [self setupContent];
        self.title = title;

    }
    return self;
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void) dealloc
{
}

- (void) cancelAnimation
{
    [self.lineView pop_removeAllAnimations];
}

- (void) setupContent
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeAreaTopHeight)];
    titleView.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.8f];
    [self addSubview:titleView];
    
    UILabel *titleLabel  = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, kSafeAreaTopHeight-NAVIGATION_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT);
//    titleLabel.font = DINPRO_REGULAR_FONTSIZE(17);
    titleLabel.backgroundColor = CLEAR_COLOR;
    titleLabel.textColor = WHITE_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
//    titleLabel.text = self.title;
    titleLabel.shadowOffset = CGSizeMake(0.4f, 0.6f);
    titleLabel.shadowColor = BLACK_COLOR;
    [titleView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-42, 24, 22, 36)];
    closeButton.centerY = titleLabel.centerY;
    [closeButton.titleLabel setFont:ICON_FONT(25)];
    [closeButton setNormalTitle:kIconClose];
    [closeButton setNormalColor:WHITE_COLOR highlighted:GREEN_COLOR selected:nil];
    [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeButton];

    UIButton *lampButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width-80)/2, self.height-80-kSafeAreaBottomHeight, 80, 80)];
    [lampButton setNormalImage:@"icon_lamp_off" selectedImage:@"icon_lamp_on"];
    [lampButton addTarget:self action:@selector(lampButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lampButton];
    
    UIImageView *frameView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"scan_frame")];
    frameView.frame = CGRectMake(_offsetX+30, _offsetY+30, _frameWidth-60, _frameWidth-60);
    [self addSubview:frameView];
    
//    _redLine = [[UIView alloc] initWithFrame:CGRectMake(2, 0, frameView.width-4, 2)];
//    _redLine.backgroundColor = [RED_COLOR colorWithAlphaComponent:0.8f];
//    [frameView addSubview:_redLine];
    _lineView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"scan_line")];
    _lineView.frame = CGRectMake(2, 0, frameView.width-4, 6);
    [frameView addSubview:_lineView];
    
    UILabel *descriptLabel  = [[UILabel alloc] init];
    descriptLabel.frame = CGRectMake(0, _offsetY+_frameWidth, self.width, 40);
    descriptLabel.font = SYSTEMFONT(15);
    descriptLabel.backgroundColor = CLEAR_COLOR;
    descriptLabel.textColor = WHITE_COLOR;
    descriptLabel.textAlignment = NSTextAlignmentCenter;
    descriptLabel.text = @"对准二维码/条形码到框内即可自动扫描";
    [self addSubview:descriptLabel];
    self.descriptLabel = descriptLabel;

//    [self animation];
}

- (IBAction) closeButtonAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanViewDidCanceled)]) {
        [self.delegate scanViewDidCanceled];
    }
}

- (IBAction) lampButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanViewFlashlamp:)]) {
        [self.delegate scanViewFlashlamp:button.selected];
    }
}

- (void) startAnimation
{
    CGPoint center = self.lineView.center;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(center.x, (_frameWidth-62))];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, 0)];
    anim.duration = 3.0f;
    anim.autoreverses = NO;
    anim.repeatCount = 9999;
    
    [self.lineView pop_addAnimation:anim forKey:@"lasorAnim"];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, COLOR_DOT_DEFAULT.CGColor);
    [[BLACK_COLOR colorWithAlphaComponent:0.6f] set];

    CGRect upFrame = CGRectMake(0, 0, self.width, _offsetY);
    CGContextFillRect(context, upFrame);
    CGRect downFrame = CGRectMake(0, _offsetY+_frameWidth, self.width, self.height-_offsetY-_frameWidth);
    CGContextFillRect(context, downFrame);
    CGRect leftFrame = CGRectMake(0, upFrame.size.height, _offsetX, _frameWidth);
    CGContextFillRect(context, leftFrame);
    CGRect rightFrame = CGRectMake(self.width-_offsetX, upFrame.size.height, _offsetX, _frameWidth);
    CGContextFillRect(context, rightFrame);

    CGRect bottomFrame = CGRectMake(0, self.height-80-kSafeAreaBottomHeight, self.width, 80+kSafeAreaBottomHeight);
    [[BLACK_COLOR colorWithAlphaComponent:0.8f] set];
    CGContextFillRect(context, bottomFrame);
    
    CGFloat startX = _offsetX+30-2, startY = _offsetY+30-2;
    CGFloat lineW = 20;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startX+lineW, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY+lineW);
    
    startY = _offsetY+_frameWidth-30+2;
    CGPathMoveToPoint(path, NULL, startX+lineW, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY-lineW);
    
    startX = _offsetX+_frameWidth-30+2;
    CGPathMoveToPoint(path, NULL, startX-lineW, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY-lineW);
    
    startY = _offsetY+30-2;
    CGPathMoveToPoint(path, NULL, startX-lineW, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, startX, startY+lineW);

    CGContextSetLineWidth(context, 4.0f);
    CGContextSetStrokeColorWithColor(context, [GREEN_COLOR CGColor]);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);

}

- (CGRect) scanRect
{
    return CGRectMake(_offsetX+30, _offsetY+30, _frameWidth-60, _frameWidth-60);
}

@end

#pragma mark - FlashlampButton

@implementation FlashlampButton

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEAR_COLOR;
        
        [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [self setTitleColor:GRAY_COLOR forState:UIControlStateHighlighted];
        
        self.titleLabel.font = SYSTEMFONT(15);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitle:@"开灯" forState:UIControlStateNormal];
        [self setTitle:@"关灯" forState:UIControlStateSelected];
        [self setImage:IMAGENAMED(@"icon_lamp_off") forState:UIControlStateNormal];
        [self setImage:IMAGENAMED(@"icon_lamp_on") forState:UIControlStateSelected];

    }
    return self;
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, contentRect.size.height-20, contentRect.size.width, 20);
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    CGFloat width = 50; //self.imageView.image.size.width;
    return CGRectMake((contentRect.size.width-width)/2, (contentRect.size.height-20-width)/2, width, width);
}

@end

