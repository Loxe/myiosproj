//
//  YXPhotoCaptureViewController.h
//  MeckeeperMerchant
//
//  Created by guoguo on 2017/5/9.
//  Copyright © 2017年 KunHong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReloadPhotoArrayBlock)(void);

@interface YXPhotoCaptureViewController : UIViewController

@property (nonatomic, copy) NSURL *fileU;

@property (nonatomic, copy) ReloadPhotoArrayBlock reloadBlock;

@end
