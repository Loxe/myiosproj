//
//  DiscoverData.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "DiscoverData.h"

@implementation DiscoverData

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"Id": @"id" };
}

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"comments" : [DiscoverComment class]
              };
}

- (NSArray *) imagesArray
{
    if (!self.imagesUrl || self.imagesUrl.length == 0) {
        return nil;
    }
    NSString *urls = [self.imagesUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [urls componentsSeparatedByString:@","];
}

- (void) addComment:(id)comment
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.comments];
    [array addObject:comment];
    self.comments = array;
}

@end

@implementation DiscoverComment

@end
