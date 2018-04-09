//
//  DiscoverData.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

// 发现内容分类
typedef NS_ENUM(NSInteger, eDiscoverType)
{
    DISCOVER_TYPE_IMAGE = 0 ,   // 图文
    DISCOVER_TYPE_VIDEO ,       // 视频
    DISCOVER_TYPE_LINKURL ,     // 图文链接
    DISCOVER_TYPE_FUNCTION ,
    DISCOVER_TYPE_GOODS         // 小切货
};

@interface DiscoverData : JTModel

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isTop;

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imagesUrl;

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoId;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

@property (nonatomic, assign) NSTimeInterval createtime;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) NSArray *comments;

- (void) addComment:(id)comment;

@end

@interface DiscoverComment : JTModel

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *replyid;
@property (nonatomic, copy) NSString *replyUsername;
@property (nonatomic, copy) NSString *replyuser;

@end
