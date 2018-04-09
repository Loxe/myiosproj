//
//  RequestDiscoverComment.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestDiscoverComment : HttpRequestPOST

@property (nonatomic, copy)   NSString  *comment;
@property (nonatomic, copy)   NSString  *contentid;
@property (nonatomic, copy)   NSString  *userid;

@end
