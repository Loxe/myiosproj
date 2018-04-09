//
//  UIView+DDExtension.m
//  akucun
//
//  Created by deepin do on 2017/12/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UIView+DDExtension.h"
#import "NSString+akucun.h"

@implementation UIView (DDExtension)

#pragma mark - 获取当前view的viewcontroller
- (UIViewController *)getCurrentViewController:(UIView *)currentView {
    for (UIView* next = [currentView superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)getTopNav:(UIView *)currentView {
    for (UIView* next = [currentView superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

#pragma mark - 获取当前cell的tableView
- (UITableView *)getCurrentTableView:(UIView *)currentView {
    for (UIView* next = [currentView superview]; next; next = next.superview)
    {
        //UIResponder *nextResponder = [next nextResponder];
        if ([next isKindOfClass:[UITableView class]])
        {
            //return (UITableView *)nextResponder;
            return (UITableView *)next;
        }
    }
    return nil;
}

// 根据path获取视频的缩略图方法
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath {
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}

// 根据url获取视频的缩略图方法
- (UIImage *)getScreenShotImageFromVideoURL:(NSURL *)fileURL {
    UIImage *shotImage;
    //视频路径URL
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}

/** 根据传入的数值，显示成金额 */
- (NSString *)getPriceString:(NSNumber*)price {
    NSString *priceStr = @"";
    CGFloat value = price.integerValue / 100.0f;
    if (value > 9) {
        priceStr = FORMAT(@"%.0f",value);               // 去掉小数点
        priceStr = [priceStr strmethodComma:priceStr];  // 添加逗号
        priceStr = FORMAT(@"¥ %@ ", priceStr);          // 添加RMB标识
    }
    else {
        priceStr = FORMAT(@"¥ %.1f ", value);
    }
    return priceStr;
}

/** 根据传入的数值，显示成金额,不加逗号的 */
- (NSString *)getPriceStringNoComma:(NSNumber*)price {
    NSString *priceStr = @"";
    CGFloat value = price.integerValue / 100.0f;
    if (value > 9) {
        priceStr = FORMAT(@"¥ %.0f ", value);
    }
    else {
        priceStr = FORMAT(@"¥ %.1f ", value);
    }
    return priceStr;
}

@end
