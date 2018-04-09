//
//  OrderCollectionCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imgView;   // 图标
@property(nonatomic, strong) UILabel     *nameLabel; // 显示文字

- (void)updateUIWith:(UIImage *)img title:(NSString *)title;

@end
