//
//  AddressView.h
//  akucun
//
//  Created by Jarry on 2017/4/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "Address.h"
#import "IconButton.h"
#import "Logistics.h"

@interface AddressView : UIView

@property (nonatomic, strong) UILabel *nameLabel, *mobileLabel, *addressLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) IconButton *editButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *defaultLabel;

//@property (nonatomic, strong) IconButton *defaultButton;
//@property (nonatomic, strong) IconButton *deleteButton;

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) Logistics *logistics;

@property (nonatomic, copy) voidBlock actionBlock;

- (void) updateLayout;

@end
