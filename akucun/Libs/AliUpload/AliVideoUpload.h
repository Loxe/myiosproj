//
//  AliVideoUpload.h
//  VODUploadDemo
//
//  Created by deepin do on 2017/11/30.
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadClient.h>

@interface UploadInfo : UploadFileInfo

@property NSInteger percent;

@end

@interface AliVideoUpload : NSObject

- (id)initWithListener:listener;

- (void)addFile;
- (void)deleteFile;
- (void)cancelFile;
- (void)resumeFile;

- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;

- (NSMutableArray<UploadFileInfo *> *)listFiles;
- (void)clearList;
- (void)setUploadAuth:(UploadFileInfo *) fileInfo;
- (void)resumeWithAuth:(NSString *)auth;

- (void)requestTempSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler;
- (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler;
- (NSString *)getDeviceId;
- (NSString *)getDeviceModel;

@end
