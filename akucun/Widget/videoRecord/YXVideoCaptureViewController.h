//
//  YXVideoCaptureViewController.h
//  MeckeeperMerchant
//
//  Created by guoguo on 2017/5/9.
//  Copyright © 2017年 KunHong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReloadPhotoArrayBlock)(void);
@protocol ChatDelegate <NSObject>

- (void)touchUpDone:(NSString *)savePath;

@end


@interface YXVideoCaptureViewController : UIViewController

@property (nonatomic, copy) NSURL *fileU;

@property (nonatomic, copy) ReloadPhotoArrayBlock reloadBlock;

@property (nonatomic, weak) id<ChatDelegate>delegate;
@property (nonatomic, copy) void (^touchUpDone)(NSString *savePath, UIImage *cover, NSInteger duration);


@property (nonatomic, assign) BOOL isChat;

@end
