//
//  AliVideoUpload.m
//  VODUploadDemo
//
//  Created by deepin do on 2017/11/30.
//

#import "AliVideoUpload.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "RequestDiscoverUpAuth.h"

//MARK: 测试服务器
static NSString *KUploadAuth      = @"";
static NSString *KUploadAddress   = @"";
static NSString *const KAccessKeyId     = @"STS.Dew9b3bSNknQnomDWpw67a1od";
static NSString *const KAccessKeySecret = @"28fCXXegrMGVEokbHx5EPJYUqUDVAxF2W5xV8UpDDfgT";
static NSString *const KSecretToken     = @"CAISzgJ1q6Ft5B2yfSjIpabCctiHj4xv3Ky6bEncoFcle7kbjvTEhjz2IH1KdHNtAu8et/wzn2BZ7PsTlqZtSpNIQkXHcMBt6NEPqVr5piR0XCXxv9I+k5SANTW57XeZtZagg4ybIfrZfvCyEWam8gZ43br9cxi7QlWhKufnoJV7b9MRLCfaECRBCIV9PAZrtMInLX/WPPqTMxLnhQiuEk1k6DBxh3ly8qSC2smb4xbgjVH3zY1ouYP9cLO+YsBwMapnV9C80M1zf6XMqlkyjSJH76BrlqdJ1C7at9WGeTlr7g6BLvDf/68ETmY7RNBjRP8V9qCtzKwm4LOKy96t8XsXY7EJCRa4bZu73c7JFNmuMtsEbrvhMxzPqIvSaMmv7lh7OStDaFgaKoB8e2UDABgtWyzcNK6r9VfReRusRq6Iyqgq1oBvyFHl7QwM2/gXoETyGoABau3DAMohf/d4BCUhP9ZFrZ0b8hvdEM0kvQZRHfT0jQWG3cHqSMsFnwWUpzvazcm1HRp0P66TBKfX3KZkY9EQgDui0lFNxzxQxvl0D3uymP+k7CmiKzJBh4GNoI/KP28huu35FdyLGf9JUUuXPpn0RhMO10yznYCQcd+0t8+X6zE=";
static NSString *const KExpireTime      = @"2017-12-01T12:05:13Z";
static NSString *const endpoint         = @"http://oss-cn-beijing.aliyuncs.com";
static NSString *const bucketName       = @"";//video.akucun.com

static int fileSize = 10240000;
static int pos = 0;


static VODUploadClient *uploader;


@implementation AliVideoUpload


- (void)addFile {
    NSString *name = [NSString stringWithFormat:@"%d.demo.ios.mp4", pos];
    NSString *filePath = [self createTempFile:name fileSize:fileSize];
    NSString *ossObject = [NSString stringWithFormat:@"uploadtest/%d.ios.demo.mp4", pos];
    
    
    VodInfo *vodInfo = [[VodInfo alloc] init];
    vodInfo.title = [NSString stringWithFormat:@"IOS标题%d", pos];
    vodInfo.desc = [NSString stringWithFormat:@"IOS描述%d", pos];
    vodInfo.cateId = @(19);
    vodInfo.coverUrl = [NSString stringWithFormat:@"http://www.taobao.com/IOS封面URL%d", pos];
    vodInfo.tags = [NSString stringWithFormat:@"IOS标签1%d, IOS标签2%d", pos, pos];
    if ([self isVodMode]) {
        vodInfo.isShowWaterMark = NO;
        vodInfo.priority = [NSNumber numberWithInt:7];
    } else {
        vodInfo.userData = [NSString stringWithFormat:@"IOS用户数据%d。", pos];
    }
    
    if ([self isVodMode]) {
        // 点播上传。每次上传都是独立的OSS object，所以添加文件时，不需要设置OSS的属性
        [uploader addFile:filePath vodInfo:vodInfo];
    } else {
        [uploader addFile:filePath endpoint:endpoint bucket:bucketName object:ossObject vodInfo:vodInfo];
    }
    
    NSLog(@"Add file: %@", filePath);
    pos++;
}

- (void)deleteFile {
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = (int)[uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader deleteFile:index];
    NSLog(@"Delete file: %@", fileName);
}

- (void)cancelFile {
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = (int)[uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader cancelFile:index];
    NSLog(@"cancelFile file: %@", fileName);
    
}

- (void)resumeFile {
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = (int)[uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader resumeFile:index];
    NSLog(@"resumeFile file: %@", fileName);
    
}

- (NSMutableArray<UploadFileInfo *> *)listFiles {
    return [uploader listFiles];
}

- (void)clearList {
    [uploader clearFiles];
}

- (void)start {
    [uploader start];
}

- (void)stop {
    [uploader stop];
}

- (void)pause {
    [uploader pause];
}

- (void)resume {
    [uploader resume];
}

- (void)resumeWithAuth:(NSString *)auth {
    KUploadAuth = auth;
    [uploader resumeWithAuth:auth];
}

#pragma mark - temp_file
// create a file with size of fileSize in the fixed path, and return the file path.
- (NSString *)createTempFile: (NSString * )fileName fileSize: (int)size {
    NSString * tempFileDirectory;
    NSString * path = NSHomeDirectory();
    tempFileDirectory = [NSString stringWithFormat:@"%@/%@/%@", path, @"tmp", fileName];
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:tempFileDirectory]){
        return tempFileDirectory;
    }
    
    [fm createFileAtPath:tempFileDirectory contents:nil attributes:nil];
    NSFileHandle * fh = [NSFileHandle fileHandleForWritingAtPath:tempFileDirectory];
    NSMutableData * basePart = [NSMutableData dataWithCapacity:size];
    for (int i = 0; i < size/4; i++) {
        u_int32_t randomBit = arc4random();
        [basePart appendBytes:(void*)&randomBit length:4];
    }
    [fh writeData:basePart];
    [fh closeFile];
    return tempFileDirectory;
}

- (id)initWithListener:listener {
    self = [super init];
    if (self) {
        uploader = [[VODUploadClient alloc] init];
        if ([self isVodMode]) {
            // 点播上传。每次上传都是独立的鉴权，所以初始化时，不需要设置鉴权
            [uploader init:listener];
        } else if ([self isSTSMode]) {
            // OSS直接上传:STS方式，安全但是较为复杂，建议生产环境下使用。
            // 临时账号过期时，在onUploadTokenExpired事件中，用resumeWithToken更新临时账号，上传会续传。
            [uploader init:KAccessKeyId accessKeySecret:KAccessKeySecret secretToken:KSecretToken expireTime:KExpireTime listener:listener];
        } else {
            // OSS直接上传:AK方式，简单但是不够安全，建议测试环境下使用。
            [uploader init:KAccessKeyId accessKeySecret:KAccessKeySecret listener:listener];
        }
    }
    
    return self;
}

- (BOOL)isVodMode {
    return (nil != KUploadAuth && [KUploadAuth length] > 0 &&
            nil != KUploadAddress && [KUploadAddress length] > 0);
}

- (BOOL)isSTSMode {
    if (![self isVodMode]) {
        return (nil != KSecretToken && nil != KExpireTime &&
                [KSecretToken length] > 0 && [KExpireTime length] > 0);
    }
    return false;
}

- (void)setUploadAuth:(UploadFileInfo *)fileInfo {
    if ([self isVodMode]) {
        [uploader setUploadAuthAndAddress:fileInfo
                               uploadAuth:KUploadAuth
                            uploadAddress:KUploadAddress];
    }
    NSLog(@"upload started: %@ %@ %@ %@",
          fileInfo.filePath, fileInfo.endpoint, fileInfo.bucket,
          fileInfo.object);
}

- (void)requestTempSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler {

    //测试用请求地址
    NSString *params = [NSString stringWithFormat:@"BusinessType=vodai&TerminalType=iphone&DeviceModel=%@&UUID=%@&AppVersion=1.0.0", [self getDeviceId], [self getDeviceModel]];
    NSString *RequestUrl = [NSString stringWithFormat:@"http://106.15.81.230/voddemo/CreateSecurityToken?%@",params];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:RequestUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            handler(nil,nil,nil,nil, error);
            return ;
        }
        if (data == nil) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            handler(nil,nil,nil,nil, error);
            return;
        }

        NSDictionary *dict       = [jsonObj objectForKey:@"SecurityTokenInfo"];
        NSString     *keyId      = [dict valueForKey:@"AccessKeyId"];
        NSString     *keySecret  = [dict valueForKey:@"AccessKeySecret"];
        NSString     *token      = [dict valueForKey:@"SecurityToken"];
        NSString     *expireTime = [dict valueForKey:@"Expiration"];

        if (!keyId || !keySecret || !token || !expireTime) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        handler(keyId, keySecret, token, expireTime, error);
    }];
    [task resume];
}

- (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler {
    
        RequestDiscoverUpAuth *request = [RequestDiscoverUpAuth new];
        [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content) {
            
            SCHttpResponse *response = content;
            NSDictionary *dict = (NSDictionary *)response.responseData;
            NSLog(@"token info -- %@",dict);
            
            NSString *token      = dict[@"secToken"];
            NSString *keyId      = dict[@"akId"];
            NSString *keySecret  = dict[@"akSecret"];
            NSString *expireTime = dict[@"expiration"];
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"secToken"];
            [[NSUserDefaults standardUserDefaults] setObject:keyId forKey:@"akId"];
            [[NSUserDefaults standardUserDefaults] setObject:keySecret forKey:@"akSecret"];
            [[NSUserDefaults standardUserDefaults] setObject:expireTime forKey:@"expiration"];
            
            handler(keyId, keySecret, token, expireTime, nil);

        } onFailed:^(id content) {
            NSLog(@"requestSTSWithHandler - Failed %@",content);
        }];
}

- (NSString *)getDeviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

@end
