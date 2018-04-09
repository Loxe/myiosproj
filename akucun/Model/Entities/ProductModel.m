//
//  ProductModel.m
//  akucun
//
//  Created by Jarry on 2017/3/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductModel.h"
#import "ProductsManager.h"
#import "SDWebImageManager.h"
#import "UserManager.h"

@implementation ProductModel

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"Id": @"id", @"updateTime": @"shangjiashuzishijian" };
}

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"skus" : [ProductSKU class],
              @"comments" : [Comment class]
              };
}

- (BOOL) modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    /*
    NSString *desc = self.desc;
    NSRange range = [desc rangeOfString:@"\n"];
    if (range.length > 0) {
        NSString *temp = [desc substringToIndex:range.location];
        range = [temp rangeOfString:@"¥"];
        if (range.length > 0) {
            NSString *price = [temp substringFromIndex:range.location+1];
            self.bohuojia = price.floatValue * 100;
        }
    }*/
    self.bohuojia = self.xiaoshoujia;
    return YES;
}

- (NSString *) desc
{
    _desc = [_desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return [_desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *) imagesUrl
{
    if (!self.tupianURL || self.tupianURL.length == 0) {
        return nil;
    }
    NSString *urls = [self.tupianURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [urls componentsSeparatedByString:@","];
}

- (NSString *) imageUrl1
{
    if (!self.tupianURL || self.tupianURL.length == 0) {
        return nil;
    }
    NSArray *array = [self.tupianURL componentsSeparatedByString:@","];
    NSString *url = array[0];
    return [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *) jiesuanPrice
{
    return FORMAT(@"结算价：¥ %.2f", self.jiesuanjia/100.0f);
}

- (void) addComment:(Comment *)comment
{
    if ([self isCommentExist:comment]) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    if (self.comments) {
        [array addObjectsFromArray:self.comments];
    }
    [array addObject:comment];
    self.comments = array;
    //
    [[ProductsManager instance] updateProduct:self];
}

- (void) removeComment:(Comment *)comment
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.comments];
    [array removeObject:comment];
    self.comments = array;
    //
    [[ProductsManager instance] updateProduct:self];
}

- (BOOL) isCommentExist:(Comment *)comment
{
    for (Comment *item in self.comments) {
        if ([item.Id isEqualToString:comment.Id]) {
            return YES;
        }
    }
    return NO;
}

- (void) updateSKU:(ProductSKU *)sku
{
    for (ProductSKU *item in self.skus) {
        if ([item.Id isEqualToString:sku.Id]) {
            item.shuliang = sku.shuliang;
            return;
        }
    }
}

- (NSString *) weixinDesc
{
    BOOL canbeForward = [self canbeForward]; // 是否转发缺货尺码
    NSMutableString *skuDesc = [NSMutableString stringWithString:@"尺码 "];
    NSInteger i = 0;
    for (ProductSKU *sku in self.skus) {
        if (sku.shuliang > 0 || canbeForward) {
            if (i > 0) {
                [skuDesc appendString:@"  "];
            }
            [skuDesc appendString:sku.chima];
            i ++;
        }
    }
    
    //
    NSInteger price = self.bohuojia/100;
    NSInteger priceOption = [UserManager instance].userConfig.priceOption;
    if (price > 0 && priceOption > 0) {
        price += priceOption;
    }

    NSMutableString *newDesc = [NSMutableString string];
    NSString *desc = self.desc;
    NSRange range = [desc rangeOfString:@"\n"];
    NSInteger index = 0;
    while (range.length > 0) {
        NSString *temp = [desc substringToIndex:range.location];
        if (index == 0) {
            NSRange rng = [temp rangeOfString:@"¥"];
            if (rng.length > 0 && price > 0) {
                [newDesc appendString:[temp substringToIndex:rng.location]];
                [newDesc appendFormat:@"¥%ld", (long)price];
            }
            else {
                [newDesc appendString:temp];
            }
        }
        else if ([temp hasPrefix:@"尺码"]) {
            [newDesc appendString:skuDesc];
        }
        else {
            [newDesc appendString:temp];
        }
        [newDesc appendString:@"\n"];
        
        desc = [desc substringFromIndex:range.location+1];
        range = [desc rangeOfString:@"\n"];
        index ++;
    }

    [newDesc appendString:desc];
    [newDesc appendString:@"\n"];
    
    return newDesc;
}

- (NSString *) productDesc
{
    NSMutableString *desc = [NSMutableString string];
    NSArray *array = [self.desc componentsSeparatedByString:@"\n"];
    for (NSString *text in array) {
        if (![text hasPrefix:@"尺码 "]) {
            [desc appendString:text];
            [desc appendString:@"\n"];
        }
    }
    return desc;
}

- (BOOL) isQuehuo
{
    NSInteger count = 0;
    for (ProductSKU *sku in self.skus) {
        count += sku.shuliang;
    }
    return (count <= 0);
}

- (BOOL) isQuehuo:(ProductSKU *)sku
{
    for (ProductSKU *item in self.skus) {
        if ([item.Id isEqualToString:sku.Id]) {
            return (item.shuliang <= 0);
        }
    }
    return NO;
}

- (BOOL) shouldUpdateSKU
{
    for (ProductSKU *sku in self.skus) {
        if (sku.shuliang < 3) {
            return YES;
        }
    }
    return NO;
}


/**
 是否支持转发缺货尺码
 读取配置项
 */
- (BOOL) canbeForward
{
    NSInteger skuOption = [UserManager instance].userConfig.skuOption;
    if (skuOption < 0) { //不转发
        return NO;
    }
    else if (skuOption == 0) {
        return YES;
    }
    
    LiveInfo *liveInfo = [LiveManager getLiveInfo:self.liveid];
    if (liveInfo) {
        NSTimeInterval delta = [NSDate timeIntervalValue] - liveInfo.begintimestamp;
        if (delta < 3600 * skuOption) {
            return YES;
        }
    }
    return NO;
}

// 判断是否禁用转发该商品
- (BOOL) forwardDisabled
{
    if ([self canbeForward]) { // 如果支持转发缺货尺码
        return NO;
    }
    // 不支持转发缺货尺码，判断是否缺货
    return [self isQuehuo];
}

- (void) loadImageUrls
{
    SDWebImageManager* manager = [SDWebImageManager sharedManager];
    NSArray *images = [self imagesUrl];
//    NSInteger count = images.count;
    for (NSString *url in images) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
        if (image) {
            continue;
        }
        
        [manager loadImageWithURL:[NSURL URLWithString:url]
                          options:0
                         progress:nil
                        completed:^(UIImage * _Nullable image,
                                    NSData * _Nullable data,
                                    NSError * _Nullable error,
                                    SDImageCacheType cacheType,
                                    BOOL finished,
                                    NSURL * _Nullable imageURL)
        {
            
        }];
    }
}

@end
