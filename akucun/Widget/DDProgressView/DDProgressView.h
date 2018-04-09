//
//  DDProgressView.h
//  akucun
//
//  Created by deepin do on 2018/2/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//
/*
 说明：1、frame 高度被限制 5~100
 2、进度条progressValue 最大为 DDProgressView的宽度
 */


#import <UIKit/UIKit.h>

@interface DDProgressView : UIView

/**
 *  进度条高度  height: 5~100
 */
@property (nonatomic) CGFloat progressHeight;

/**
 *  进度值  maxValue:  <= DDProgressView.width
 */
@property (nonatomic) CGFloat progressValue;

/**
 *  进度值  percent
 */
@property (nonatomic) CGFloat percent;

/**
 *   动态进度条颜色  Dynamic progress
 */
@property (nonatomic, strong) UIColor *trackTintColor;
/**
 *  静态背景颜色    static progress
 */
@property (nonatomic, strong) UIColor *progressTintColor;


@end

