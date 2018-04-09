//
//  UserConfig.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

/**
 转发图片选项
 */
typedef NS_ENUM(NSInteger, eShareImageOption)
{
    ShareOptionOnlyPictures = 1 ,   // 多图普通模式 仅转发商品图片
    ShareOptionPicturesAndText ,    // 多图图文模式 商品图片和描述转图片
    ShareOptionMergedPicture        // 单图图文模式 商品图片和描述合成一张图片
};


@interface UserConfig : JTModel

/**
 下单备注开关 (默认 YES)
 */
@property (nonatomic, assign)   BOOL remarkSwitch;

/**
 转发图片选项 (默认 1 多图普通模式)
 */
@property (nonatomic, assign)   NSInteger imageOption;

/**
 是否允许转发缺货尺码 :
 -1 -- 不允许
  0 -- 始终允许
  1 -- 活动开始1小时内允许
  2 -- 活动开始2小时内允许 (默认)
 */
@property (nonatomic, assign)   NSInteger skuOption;

/**
 转发商品是否加价 :
 0  -- 不加价 (默认)
 5  -- 加价 +5元
 10 -- 加价 +10元
 */
@property (nonatomic, assign)   NSInteger priceOption;


+ (NSArray *) imageOptions;

+ (NSInteger) imageOptionIndex:(NSInteger)option;

+ (NSString *) imageOptionText:(NSInteger)option;

+ (NSString *) imageOptionDesp:(NSInteger)option;

+ (NSArray *) skuOptions;

+ (NSString *) skuOptionText:(NSInteger)option;

+ (NSString *) skuOptionDesp:(NSInteger)option;

+ (NSArray *) priceOptions;

+ (NSString *) priceOptionText:(NSInteger)option;

+ (NSString *) priceOptionDesp:(NSInteger)option;

@end
