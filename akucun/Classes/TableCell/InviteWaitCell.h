//
//  InviteWaitCell.h
//  akucun
//
//  Created by deepin do on 2018/1/16.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(id nsobject);

@interface InviteWaitCell : UITableViewCell

@property(nonatomic, strong) UIImageView *avatorImgView;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UIButton *approveBtn;

@property(nonatomic, copy) ClickBlock approveBlock;


- (void)showUserGuide;

@end
