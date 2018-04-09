//
//  VideoSelectModel.h
//  Discovery
//
//  Created by deepin do on 2017/11/21.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoSelectModel : NSObject

@property(nonatomic, copy) UIImage *coverImage;

@property (nonatomic, strong) id asset;

@property(nonatomic, strong) NSString *videoPath;

@end
