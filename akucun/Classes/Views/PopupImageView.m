//
//  PopupImageView.m
//  akucun
//
//  Created by Jarry Z on 2018/2/27.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "PopupImageView.h"

@implementation PopupImageView

- (instancetype) initWithImage:(UIImage *)image
{
    self = [super init];
    
    if ( self )
    {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.type = MMPopupTypeAlert;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width - kOFFSET_SIZE * 3;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
     
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat height = width * 5/4;
        if (image.size.width > 0) {
            height = width*image.size.height/image.size.width;
        }
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(height);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView.mas_bottom);
        }];
    }
    return self;
}

@end
