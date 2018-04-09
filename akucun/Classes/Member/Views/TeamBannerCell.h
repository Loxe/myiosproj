//
//  TeamBannerCell.h
//  akucun
//
//  Created by deepin do on 2018/1/25.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextButton.h"

typedef void(^ClickBlock)(id nsobject);

@interface TeamBannerCell : UITableViewCell

@property(nonatomic, strong) UIImageView *BGImgView;

@property(nonatomic, strong) UIButton   *playBtn;
@property(nonatomic, copy)   ClickBlock playBlock;

@property(nonatomic, strong) TextButton *detailBtn;
@property(nonatomic, copy)   ClickBlock detailBlock;

@end
