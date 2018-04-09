//
//  UpDownButton.h
//  akucun
//
//  Created by deepin do on 2018/2/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(id nsobject);

@interface UpDownButton : UIButton

@property (nonatomic, strong) UIImageView *topIcon;
@property (nonatomic, strong) UILabel     *bottomLabel;

@property (nonatomic, copy)   ClickBlock clickBlock;

- (void)initWithTitle:(NSString *)title Image:(NSString *)img;

@end
