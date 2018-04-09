//
//  UserConfig.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UserConfig.h"

@implementation UserConfig

- (instancetype) init
{
    self = [super init];
    if (self) {
        //
        self.remarkSwitch = YES;
        self.imageOption = ShareOptionOnlyPictures;
        self.skuOption = 2;
        self.priceOption = 0;
    }
    return self;
}

+ (NSArray *) imageOptions
{
    return @[@"朋友圈（四张图）",
             @"微信群（合并一张图）",
             @"微信群（五张图）"];
}

+ (NSInteger) imageOptionIndex:(NSInteger)option
{
    switch (option) {
        case ShareOptionOnlyPictures:
            return 0;
        case ShareOptionPicturesAndText:
            return 2;
        case ShareOptionMergedPicture:
            return 1;
    }
    return 0;
}

+ (NSString *) imageOptionText:(NSInteger)option;
{
    NSString *text = @"";
    switch (option) {
        case ShareOptionOnlyPictures:
            text = @"朋友圈 (四张图)";
            break;
        case ShareOptionPicturesAndText:
            text = @"微信群 (五张图)";
            break;
        case ShareOptionMergedPicture:
            text = @"微信群 (合并一张图)";
            break;
    }
    return text;
}

+ (NSString *) imageOptionDesp:(NSInteger)option
{
    NSString *desp = @"";
    switch (option) {
        case ShareOptionOnlyPictures:
            desp = @"仅转发商品图片，描述文字需手动复制粘贴";
            break;
        case ShareOptionPicturesAndText:
            desp = @"同时转发商品图片和描述文字转成图片";
            break;
        case ShareOptionMergedPicture:
            desp = @"商品图片和描述文字合成一张图片再转发";
            break;
    }
    return desp;
}

+ (NSArray *) skuOptions
{
    return @[@"不转发",
             @"始终转发",
             @"活动1小时内转发",
             @"活动2小时内转发"];
}

+ (NSString *) skuOptionText:(NSInteger)option
{
    NSString *text = @"";
    switch (option) {
        case -1:
            text = @"不转发";
            break;
        case 0:
            text = @"始终转发";
            break;
        default:
            text = FORMAT(@"活动%ld小时内", (long)option);
            break;
    }
    return text;
}

+ (NSString *) skuOptionDesp:(NSInteger)option
{
    NSString *text = @"";
    switch (option) {
        case -1:
            text = @"不转发缺货尺码";
            break;
        case 0:
            text = @"始终转发缺货尺码";
            break;
        default:
            text = FORMAT(@"活动开始%ld小时内 转发缺货尺码", (long)option);
            break;
    }
    return text;
}

+ (NSArray *) priceOptions
{
    return @[@"不加价",
             @"加价+5元",
             @"加价+10元",
             @"自定义金额"];
}

+ (NSString *) priceOptionText:(NSInteger)option
{
    if (option == 0) {
        return @"不加价";
    }
    else {
        return FORMAT(@"+%ld元", (long)option);
    }
    return @"";
}

+ (NSString *) priceOptionDesp:(NSInteger)option
{
    if (option == 0) {
        return @"所有商品以平台播货价格转发";
    }
    else {
        return FORMAT(@"所有商品在平台播货价基础上+%ld元转发", (long)option);
    }
    return @"";
}

@end
