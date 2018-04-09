//
//  FeedSaleCollectionCell.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedSaleCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UILabel  *countLabel; // 数量文字
@property(nonatomic, strong) UILabel  *nameLabel;  // 显示文字

- (void)updateUIWithTitle:(NSString *)count titleColor:(UIColor *)color;


@end
