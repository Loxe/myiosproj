//
//  PopAnimUtils.m
//  SCUtility
//
//  Created by Jarry on 16/11/23.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "PopAnimUtils.h"

@implementation PopAnimUtils

+ (POPAnimation *) alphaShowAnimation:(CFTimeInterval)duration
{
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.fromValue  = @(0.0f);
    alphaAnimation.toValue  = @(1.0f);
    alphaAnimation.duration = duration;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return alphaAnimation;
}

+ (POPAnimation *) alphaHideAnimation:(CFTimeInterval)duration
{
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.fromValue  = @(1.0f);
    alphaAnimation.toValue  = @(0.0f);
    alphaAnimation.duration = duration;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return alphaAnimation;
}

+ (POPAnimation *) opacityShowAnimation:(CFTimeInterval)duration
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animation.fromValue  = @(0.0f);
    animation.toValue  = @(1.0f);
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return animation;
}

+ (POPAnimation *) scaleHideAnimation:(CFTimeInterval)duration
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    animation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    animation.toValue  = [NSValue valueWithCGSize:CGSizeZero];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return animation;
}

+ (POPAnimation *) scaleSpringAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeZero];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 16;
    scaleAnimation.springSpeed = 6;
    return scaleAnimation;
}

@end
