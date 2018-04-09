//
//  VideoServer.h
//  MeckeeperMerchant
//
//  Created by guoguo on 2017/5/15.
//  Copyright © 2017年 KunHong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VideoChangeDataBlock)(NSData *data);
typedef void (^VideoChangeDataFailureBlock)(NSInteger);

typedef void (^VonvertSucc)(NSString *path);


@interface VideoServer : NSObject

@property (nonatomic,strong) NSString *videoName;

/// 压缩视频
- (void)compressVideo:(NSURL *)path andVideoName:(NSString *)name andSave:(BOOL)saveState successCompress:(void(^)(NSData *))successCompress;
//- (void)compressVideo:(NSURL *)path andVideoName:(NSString *)name andSave:(BOOL)saveState CompressHandle:(void (^)(NSData *, BOOL, CGFloat))compressHandle;
- (void)compressVideoWithSourcePath:(NSURL *)path andVideoSavePrefixName:(NSString *)name ifNeedSaveLocal:(BOOL)needSave CompressHandle:(void (^)(NSData *, BOOL, CGFloat))compressHandle;

/// 获取视频的首帧缩略图
- (UIImage *)imageWithVideoURL:(NSURL *)url;

+ (void)videoData:(id)asset curr:(NSInteger)current videoData:(VideoChangeDataBlock)videoBlock failure:(VideoChangeDataFailureBlock)failure;



// 视频转换（聊天使用）
- (void)convertToMP4:(id)video succ:(VonvertSucc)succ fail:(void (^)(void))fail;


@end
