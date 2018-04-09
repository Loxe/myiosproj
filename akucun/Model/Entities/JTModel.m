//
//  JTModel.m
//  akucun
//
//  Created by Jarry on 16/3/18.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "JTModel.h"

@implementation JTModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}
- (NSUInteger)hash
{
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object
{
    return [self yy_modelIsEqual:object];
}
- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
