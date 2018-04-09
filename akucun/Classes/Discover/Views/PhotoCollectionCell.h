//
//  PhotoCollectionCell.h
//  akucun
//
//  Created by deepin do on 2017/11/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSelectModel.h"
#import "VideoSelectModel.h"

typedef void(^DeleteBlock)(id nsobject);
//typedef void(^PlayBlock)(VideoSelectModel *model);

@interface PhotoCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *displayImageView;

@property(nonatomic, strong) UIImageView *playImageView;

@property(nonatomic, strong) UIButton *deletButton;

@property(nonatomic, copy) DeleteBlock deleteBlock;

@property(nonatomic, strong) PhotoSelectModel *photoModel;

@property(nonatomic, strong) VideoSelectModel *videoModel;


@end

