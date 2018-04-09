//
//  VideoInfo.h
//  akucun
//
//  Created by Jarry Z on 2018/4/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface VideoInfo : JTModel

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *playURL;
@property (nonatomic, copy) NSString *coverURL;
@property (nonatomic, copy) NSString *bitrate;

@property (nonatomic, assign) double size;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end
