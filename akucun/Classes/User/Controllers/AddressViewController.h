//
//  AddressViewController.h
//  akucun
//
//  Created by Jarry on 2017/4/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"
#import "Address.h"
#import "AdOrder.h"

@interface AddressCell : UITableViewCell

@property (nonatomic, assign) BOOL showAccessory;

@property (nonatomic, strong) UILabel *accessoryLabel;

@property (nonatomic, strong) UIView *seperatorLine;

- (void) setCellSelection:(BOOL)enable;

@end

@interface AddressViewController : BaseViewController

@property (nonatomic, strong) Address *addr;

@property (nonatomic, strong) AdOrder *adOrder;

@property (nonatomic, copy) voidBlock finishBlock;

@end
