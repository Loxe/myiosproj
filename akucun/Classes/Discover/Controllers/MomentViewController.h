//
//  MomentViewController.h
//  Moment
//
//  Created by deepin do on 2017/11/15.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSelectModel.h"
#import "VideoSelectModel.h"
#import "BaseViewController.h"

// 选择类型
typedef NS_ENUM(NSInteger, PhotoSelectType) {
    PhotoSelectTypeImage = 0, // 选择的图片
    PhotoSelectTypeVideo,     // 选择的视频
};

@interface MomentViewController : BaseViewController

@property(nonatomic, strong) NSMutableArray *selectedArray;

@property(nonatomic, assign) PhotoSelectType selectType;

@end
