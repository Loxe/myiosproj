//
//  PopAnimUtils.h
//  SCUtility
//
//  Created by Jarry on 16/11/23.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/POP.h>

@interface PopAnimUtils : NSObject

/**
 *  View 渐隐渐现 显示动画
 **/
+ (POPAnimation *) alphaShowAnimation:(CFTimeInterval)duration;

/**
 *  Layer 渐隐渐现 显示动画
 **/
+ (POPAnimation *) opacityShowAnimation:(CFTimeInterval)duration;

+ (POPAnimation *) alphaHideAnimation:(CFTimeInterval)duration;

+ (POPAnimation *) scaleHideAnimation:(CFTimeInterval)duration;

+ (POPAnimation *) scaleSpringAnimation;

@end
