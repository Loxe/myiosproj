//
//  UserGuideManager.m
//  akucun
//
//  Created by Jarry Z on 2018/1/21.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "UserGuideManager.h"

@implementation UserGuideManager

+ (void) createUserGuide:(NSString *)function title:(NSString *)title focusedView:(UIView *)view offset:(CGFloat)offset
{
    CGRect rect = [view convertRect:view.bounds toView:nil];
    if (offset > 0) {
        CGRect newRect = CGRectMake(rect.origin.x-offset, rect.origin.y-offset, rect.size.width+offset*2, rect.size.height+offset*2);
        rect = newRect;
    }
    [UserGuideManager createCircleUserGuide:function title:title focusedFrame:rect];
}

+ (void) createCircleUserGuide:(NSString *)function title:(NSString *)title focusedFrame:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *cView = [window viewWithTag:1000];
    if (cView) {   // 当前已有引导View显示
        return;
    }
    
    if (![UserGuideManager shouldShowGuide:function]) {
        return;
    }
    
    // 这里创建指引在这个视图在window上
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView * bgView = [[UIView alloc]initWithFrame:frame];
    bgView.tag = 1000;
    bgView.backgroundColor = RGBACOLOR(0x32, 0x32, 0x32, 0.8);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    [bgView addGestureRecognizer:tap];
    bgView.alpha = 0.0f;
    
    [window addSubview:bgView];
    
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width*0.5, rect.origin.y + rect.size.height*0.5);
    CGFloat radius = rect.size.width*0.5;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textAlignment = NSTextAlignmentCenter;
    CGRect textFrame;
    CGFloat height = 100;
    if (center.x < SCREEN_WIDTH * 0.5) {
        textFrame = CGRectMake(rect.origin.x+kOFFSET_SIZE, rect.origin.y - height, SCREEN_WIDTH-center.x-kOFFSET_SIZE, height);
    }
    else {
        textFrame = CGRectMake(kOFFSET_SIZE, rect.origin.y - height, center.x, height);
    }
    textLabel.frame = textFrame;
    textLabel.font = SYSTEMFONT(16);
    textLabel.textColor = WHITE_COLOR;
    textLabel.text = title;
    textLabel.numberOfLines = 0;
    [bgView addSubview:textLabel];
    
    // create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    // 这里添加第二个路径 （这个是圆）
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    [bgView.layer setMask:shapeLayer];
    
    [UIView animateWithDuration:.2f animations:^{
        bgView.alpha = 1.0f;
    }];
    
    if (function) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:function];
    }
}

+ (void) createFrameUserGuide:(NSString *)function title:(NSString *)title focusedFrame:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *cView = [window viewWithTag:1000];
    if (cView) {   // 当前已有引导View显示
        return;
    }
    
    if (![UserGuideManager shouldShowGuide:function]) {
        return;
    }
    
    // 这里创建指引在这个视图在window上
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView * bgView = [[UIView alloc]initWithFrame:frame];
    bgView.tag = 1000;
    bgView.backgroundColor = RGBACOLOR(0x32, 0x32, 0x32, 0.8);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    [bgView addGestureRecognizer:tap];
    bgView.alpha = 0.0f;
    
    [window addSubview:bgView];
    
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width*0.5, rect.origin.y + rect.size.height*0.5);
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textAlignment = NSTextAlignmentCenter;
    CGRect textFrame;
    
    CGFloat height = 200;
    if (center.y < SCREEN_HEIGHT * 0.5) {
        textFrame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, height);
    }
    else {
        textFrame = CGRectMake(rect.origin.x, rect.origin.y - height, rect.size.width, height);
    }
    
    textLabel.frame = textFrame;
    textLabel.font = SYSTEMFONT(16);
    textLabel.textColor = WHITE_COLOR;
    textLabel.text = title;
    textLabel.numberOfLines = 0;
    [bgView addSubview:textLabel];
    
    // create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    // 这个是矩形
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5] bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    [bgView.layer setMask:shapeLayer];
    
    [UIView animateWithDuration:.2f animations:^{
        bgView.alpha = 1.0f;
    }];
    
    if (function) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:function];
    }
}

+ (BOOL) shouldShowGuide:(NSString *)function
{
    if (function == nil) {
        return YES;
    }
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:function];
    return !value;
}

/**
 *  新手指引确定
 */
+ (void) sureTapClick:(UITapGestureRecognizer *)tap
{
    UIView * view = tap.view;
    [view removeAllSubviews];
    [view removeGestureRecognizer:tap];
    [view removeFromSuperview];
}

@end
