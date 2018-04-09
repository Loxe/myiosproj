//
//  FontUtils.m
//  akucun
//
//  Created by Jarry on 16/1/12.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "FontUtils.h"

@interface FontUtils ()
/**
 *  全局字体 大/中/小
 */
@property (nonatomic, strong) UIFont *normalFont, *smallFont, *bigFont, *FA_iconFont;

@property (nonatomic, strong) UIFont *buttonFont;

+ (FontUtils *) instance;

@end

@implementation FontUtils

+ (UIFont *) normalFont
{
    return [[FontUtils instance] normalFont];
}

+ (UIFont *) smallFont
{
    return [[FontUtils instance] smallFont];
}

+ (UIFont *) bigFont
{
    return [[FontUtils instance] bigFont];
}

+ (UIFont *) buttonFont
{
    return [[FontUtils instance] buttonFont];
}

+ (UIFont *) FA_iconFont
{
    return [[FontUtils instance] FA_iconFont];
}

+ (FontUtils *) instance
{
    static dispatch_once_t  onceToken;
    static FontUtils * instance;
    dispatch_once(&onceToken, ^{
        instance = [[FontUtils alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        // 字体初始化
        [self initFont];
    }
    return self;
}

- (void) initFont
{
    if (isRetina) {
        self.normalFont = SYSTEMFONT(13);
        self.bigFont = SYSTEMFONT(18);
        self.smallFont = SYSTEMFONT(12);
        self.buttonFont = BOLDSYSTEMFONT(14);
        self.FA_iconFont = FA_ICONFONTSIZE(18);
    }
    else if (isIPhone5) {
        self.normalFont = SYSTEMFONT(14);
        self.bigFont = SYSTEMFONT(18);
        self.smallFont = SYSTEMFONT(12);
        self.buttonFont = BOLDSYSTEMFONT(14);
        self.FA_iconFont = FA_ICONFONTSIZE(18);
    }
    else if (isIPhone6Plus) {
        self.normalFont = SYSTEMFONT(15);
        self.bigFont = SYSTEMFONT(20);
        self.smallFont = SYSTEMFONT(13);
        self.buttonFont = BOLDSYSTEMFONT(15);
        self.FA_iconFont = FA_ICONFONTSIZE(22);
    }
    else {
        self.normalFont = SYSTEMFONT(15);
        self.bigFont = SYSTEMFONT(19);
        self.smallFont = SYSTEMFONT(13);
        self.buttonFont = BOLDSYSTEMFONT(15);
        self.FA_iconFont = FA_ICONFONTSIZE(20);
    }
}

@end
