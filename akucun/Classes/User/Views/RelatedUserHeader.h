//
//  RelatedUserHeader.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconButton.h"

@interface RelatedUserHeader : UIView

@property(nonatomic, strong) IconButton  *monthButton;

@property(nonatomic, strong) UILabel  *majorLabel;
@property(nonatomic, strong) UILabel  *relatedLabel;
@property(nonatomic, strong) UILabel  *totalLabel;

@property(nonatomic, strong) UILabel  *friendLabel;
@property(nonatomic, strong) UILabel  *levelLabel;
@property(nonatomic, strong) UILabel  *livenessLabel;

@property(nonatomic, strong) UIView  *separateLine;
@property(nonatomic, strong) UIView  *bottomLine;

@property(nonatomic, copy) voidBlock actionBlock;

@end
