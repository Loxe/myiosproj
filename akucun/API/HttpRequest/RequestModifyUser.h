//
//  RequestModifyUser.h
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestBase.h"

@interface RequestModifyUser : HttpRequestPOST

@property (nonatomic, copy)  NSString  *nicheng;     // 昵称

@property (nonatomic, copy)  NSString  *base64Img;   // 头像

@end
