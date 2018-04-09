//
//  UIView+DDExtension.h
//  akucun
//
//  Created by deepin do on 2017/12/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDExtension)

- (UIViewController *)getCurrentViewController:(UIView *)currentView;

#pragma mark - 获取当前cell的tableView
- (UITableView *)getCurrentTableView:(UIView *)currentView;

// 根据path获取视频的缩略图方法
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;

// 根据url获取视频的缩略图方法
- (UIImage *)getScreenShotImageFromVideoURL:(NSURL *)fileURL;


- (UIViewController *)topViewController;

/** 根据传入的数值，显示成金额 */
- (NSString *)getPriceString:(NSNumber*)price;

- (NSString *)getPriceStringNoComma:(NSNumber*)price;

@end
