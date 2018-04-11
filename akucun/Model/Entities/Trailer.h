//
//  Trailer.h
//  akucun
//
//  Created by Jarry on 2017/3/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface Trailer : JTModel

@property (nonatomic, copy) NSString *today;
@property (nonatomic, copy) NSString *begin;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *pinpaiid;
@property (nonatomic, copy) NSString *pinpaiming;
@property (nonatomic, copy) NSString *pinpaiurl;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSTimeInterval begintimestamp;
@property (nonatomic, assign) NSTimeInterval endtimestamp;

@property (nonatomic, assign) NSInteger productcount;
@property (nonatomic, assign) NSInteger skucount;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *yugaoneirong;
@property (nonatomic, copy) NSString *yugaotupian;

@property (nonatomic, assign) NSInteger memberLevels; // 会员专享标识
@property (nonatomic, assign) BOOL isTop;   // 活动置顶标识


- (NSArray *) imagesUrl;

- (NSInteger) levelFlag;

@end
