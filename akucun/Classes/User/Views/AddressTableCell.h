//
//  AddressTableCell.h
//  akucun
//
//  Created by Jarry on 2017/7/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "Address.h"

typedef NS_ENUM(NSInteger, eAddressAction)
{
    AddrActionEdit = 1 ,
    AddrActionDefault ,
    AddrActionDelete
};

@interface AddressTableCell : UITableViewCell

@property (nonatomic, assign) BOOL selectionDisabled;

@property (nonatomic, assign) BOOL cellChecked;

@property (nonatomic, strong) Address *address;

@property (nonatomic, copy) intIdBlock actionBlock;

@end
