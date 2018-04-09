//
//  LocationCell.h
//  Discovery
//
//  Created by deepin do on 2017/11/24.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LocationBlock)(UIButton *);

@interface LocationCell : UITableViewCell

@property(nonatomic, strong) UIButton      *locationBtn;

@property(nonatomic, copy  ) LocationBlock locationBlock;

@property(nonatomic, strong) UILabel       *locationLabel;

@end
