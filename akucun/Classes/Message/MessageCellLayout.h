//
//  MessageCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "Message.h"

@interface MessageCellLayout : AKCellLayout

@property (nonatomic,strong) Message* model;

- (id) initWithModel:(Message *)model;

@end
