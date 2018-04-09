//
//  JXGoods.h
//  JXTest
//
//  Created by 刘佳 on 2017/12/19.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXMcsChatConfig.h"

@interface JXGoods : NSObject <JXGoodsInfoModel>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) UIImage *image;

@end
