//
//  MoreCollectionCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UIView      *BGView;    // 背景色view
@property(nonatomic, strong) UIImageView *imgView;   // 图标
@property(nonatomic, strong) UILabel     *nameLabel; // 显示文字
@property(nonatomic, strong) UILabel     *noticeLabel; // 敬请期待

- (void)updateUIWith:(UIImage *)img imgBGColor:(UIColor *)bgColor title:(NSString *)title;


@end
