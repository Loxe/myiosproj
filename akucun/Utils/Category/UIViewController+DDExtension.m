//
//  UIViewController+DDExtension.m
//  akucun
//
//  Created by deepin do on 2017/12/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UIViewController+DDExtension.h"

@implementation UIViewController (DDExtension)

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

@end
