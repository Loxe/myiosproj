//
//  VIPItemView.h
//  akucun
//
//  Created by Jarry on 2017/8/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel, *despLabel, *priceLabel;
@property (nonatomic, strong) UILabel *checkedLabel;

- (void) setTitle:(NSString *)title desp:(NSString *)desp price:(NSString *)price;

@end
