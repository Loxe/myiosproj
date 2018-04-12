//
//  MomentViewController.m
//  Moment
//
//  Created by deepin do on 2017/11/15.
//  Copyright © 2017年 deepin do. All rights reserved.
//

#import "MomentViewController.h"
#import "PhotoTableCell.h"
#import "LocationCell.h"
#import <CoreLocation/CoreLocation.h>
#import "MMAlertView.h"
#import "TZImageManager.h"
#import "RequestDiscoverUpload.h"
#import "VideoServer.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <VODUpload/VODUploadSVideoClient.h>
#import "AliVideoUpload.h"
#import "RequestDiscoverUpAuth.h"
#import "RequestDiscoverUploadNew.h"

#import "AliManger.h"

@interface MomentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,VODUploadSVideoClientDelegate>

@property(nonatomic, strong) UIButton *postBtn;
//@property(nonatomic, assign) BOOL isStatusHidden;

@property(nonatomic, strong) UITextView   *wordTextView;
@property(nonatomic, strong) UITextField  *titleTextField;
@property(nonatomic, strong) UILabel      *placeHolderLabel;
@property(nonatomic, strong) UITableView  *tableView;

@property(nonatomic, strong) NSString  *titleContent;
@property(nonatomic, strong) NSString  *wordContent;
@property(nonatomic, strong) NSString  *locationContent;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) double            currentLongitude;
@property(nonatomic, assign) double            currentLatitude;

@property(nonatomic, strong) VODUploadSVideoClient *client;

@end

@implementation MomentViewController

- (void) setupContent
{
    [super setupContent];
    
    [self prepareNav];
    [self prepareSubView];
    //    [self preparelocation];
    [self prepareUploadInfo];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self prepareNav];
//    [self prepareSubView];
////    [self preparelocation];
//    [self prepareUploadInfo];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.isStatusHidden = NO;
    
    if (self.view.superview) {
        [SVProgressHUD setContainerView:self.tableView];
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -64-44)];
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    self.isStatusHidden = YES;
}

- (void)prepareNav {
    
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton setTitleFont:[FontUtils buttonFont]];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.postBtn];
    [self.rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [self.rightButton setNormalColor:COLOR_MAIN];
    [self.rightButton setTitleFont:[FontUtils buttonFont]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}

- (void)prepareSubView {
    
    [self.view addSubview:self.tableView];
    
    // 初始值
    self.locationContent = @"点击定位图标获取位置";
    
    //文本输入view
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
    
    UITextField *titleTF    = [[UITextField alloc]init];
    self.titleTextField     = titleTF;
    titleTF.backgroundColor = [UIColor whiteColor];
    titleTF.delegate        = self;
    titleTF.placeholder     = @"请输入标题";
    titleTF.font            = [FontUtils normalFont];
    titleTF.frame           = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE, 50);
    titleTF.tintColor       = [UIColor orangeColor];
    [headerView addSubview:titleTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfEditChanged:) name:UITextFieldTextDidChangeNotification object:titleTF];
    
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = RGBCOLOR(247, 247, 248);
    sepView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 10);
    [headerView addSubview:sepView];
    
    UITextView *textView   = [[UITextView alloc]init];
    self.wordTextView      = textView;
    textView.font          = [FontUtils normalFont];
    textView.tintColor     = [UIColor orangeColor];
    textView.textColor     = [UIColor blackColor];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.delegate      = self;
    textView.frame           = CGRectMake(kOFFSET_SIZE-5, 60, SCREEN_WIDTH-kOFFSET_SIZE, 100);
    textView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:textView];
    
    self.tableView.tableHeaderView = headerView;
    
    UILabel *label = [[UILabel alloc]init];
    self.placeHolderLabel = label;
    label.text = @"请输入内容描述...";
    label.font = [FontUtils normalFont];
    label.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [textView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView).offset(7);
        make.left.equalTo(titleTF).offset(0);
    }];
}

- (void)prepareUploadInfo {
    
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate      = self;
    _client.transcode     = YES;
    _client.maxRetryCount = 2;
    _client.timeoutIntervalForRequest = 30;
}

// 监听文本改变
-(void)tfEditChanged:(NSNotification *)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                self.titleContent = textField.text;
            }
        } else {// 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            self.titleContent = textField.text;
        }
    }
}

- (void)leftButtonAction:(id)sender {
    [self exitEditPage];
}

- (void)rightButtonAction:(id)sender {
    [self.wordTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    NSLog(@"点击发表按钮了,标题%@ 内容 %@ 照片或者视频 %@",self.titleContent, self.wordContent, self.selectedArray);
    
    // 必选的要先判断
    if (self.titleContent.length > 0 && self.selectedArray.count > 0) {
        [self setPostBtnState:NO];
        //[self postContentsUpload];     // 1.旧的上传方法
        [self postContentsUploadByAli];  // 2.阿里云上传方法
    } else {
        //        POPUPINFO(@"标题与图片视频为必选项");
        [SVProgressHUD showInfoWithStatus:@"标题与图片视频为必选项"];
    }
}

- (void)postButtonDidClick {
    
    [self.wordTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    NSLog(@"点击发表按钮了,标题%@ 内容 %@ 照片或者视频 %@",self.titleContent, self.wordContent, self.selectedArray);
    
    // 必选的要先判断
    if (self.titleContent.length > 0 && self.selectedArray.count > 0) {
        [self setPostBtnState:NO];
        //[self postContentsUpload];     // 1.旧的上传方法
        [self postContentsUploadByAli];  // 2.阿里云上传方法
    } else {
//        POPUPINFO(@"标题与图片视频为必选项");
        [SVProgressHUD showInfoWithStatus:@"标题与图片视频为必选项"];
    }
}

- (void)postContentsUploadByAli {
    
    if (self.selectType == PhotoSelectTypeImage) {
        
        RequestDiscoverUpload *request = [RequestDiscoverUpload new];
        request.type    = DISCOVER_TYPE_IMAGE;
        request.title   = self.titleContent;
        request.content = self.wordContent;
//        BOOL isLocated  = [self.locationContent isEqualToString:@"点击定位图标获取位置"] ? NO : YES;
        request.address = @""; //isLocated ? self.locationContent : @"";
        
        NSMutableArray *imgArr = [NSMutableArray array];
        for (PhotoSelectModel *model in self.selectedArray) {
            UIImage *image  = model.selectImage;
            NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
            [imgArr addObject:imgData];
        }
        request.imagesData = imgArr;
        
        // 上传
        [SCHttpServiceFace serviceWithUploadRequest:request
                                           progress:^(NSProgress *uploadProgress)
         {
             [SVProgressHUD showWithStatus:@"正在发布..."];
         }
                                          onSuccess:^(id content)
         {
             [SVProgressHUD showSuccessWithStatus:@"发布成功"];
             GCD_DELAY(^{
                 [self dismissViewControllerAnimated:YES completion:nil];
             }, 2.0f);
             
         } onFailed:^(id content) {
             [SVProgressHUD dismiss];
             [self setPostBtnState:YES];
             GCD_DELAY(^{
                 POPUPINFO(@"Failed");
             }, 2.0)
             
         } onError:^(id content){
             [SVProgressHUD dismiss];
             [self setPostBtnState:YES];
             GCD_DELAY(^{
                 POPUPINFO(@"Error");
             }, 2.0)
             
         }];
        
    } else {
        
        [SVProgressHUD showWithStatus:@"视频处理中..."];

        // 获取model
        VideoSelectModel *model = self.selectedArray.lastObject;
        NSString *videoPath = model.videoPath;
        
        // 将封面图片存入本地，以获取路径
        NSArray  *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"cover.png"]];   // 保存文件的名称

        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL success = [UIImageJPEGRepresentation(model.coverImage, 1) writeToFile:imagePath  atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
        } else {
            NSLog(@"封面图写入本地失败");//用占位图
        }
        
        // VodSVideoInfo
        VodSVideoInfo *info = [VodSVideoInfo new];
        info.title = self.titleContent;
        
        // 获取本地缓存的token等信息
        NSString *loaclToken      = [[NSUserDefaults standardUserDefaults] objectForKey:@"secToken"];
        NSString *localKeyId      = [[NSUserDefaults standardUserDefaults] objectForKey:@"akId"];
        NSString *localKeySecret  = [[NSUserDefaults standardUserDefaults] objectForKey:@"akSecret"];
        NSString *localExpireTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiration"];
        
        // 先判断上传数据是否为nil
        if (videoPath != nil && imagePath != nil) {
            // 判断本地是否有token等
            if (loaclToken != nil && localKeyId != nil && localKeySecret != nil && localExpireTime != nil) {
                [_client uploadWithVideoPath:videoPath imagePath:imagePath svideoInfo:info accessKeyId:localKeyId accessKeySecret:localKeySecret accessToken:loaclToken];
            } else {
                
                [[AliManger new] requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
                    if (error) {
                        NSLog(@"%@",error.description);
                        [self setPostBtnState:YES];
                        return ;
                    }
                    [self.client uploadWithVideoPath:videoPath imagePath:imagePath svideoInfo:info accessKeyId:keyId accessKeySecret:keySecret accessToken:token];
                }];
            }
        } else {
            POPUPINFO(@"上传视频为nil");
            [self setPostBtnState:YES];
        }
    }
}

#pragma mark 旧的上传
- (void)postContentsUpload {
    
    RequestDiscoverUpload *request = [RequestDiscoverUpload new];
    
    request.title   = self.titleContent;
    request.content = self.wordContent;
    BOOL isLocated  = [self.locationContent isEqualToString:@"点击定位图标获取位置"] ? NO : YES;
    request.address = isLocated ? self.locationContent : @"";
    
    dispatch_group_t uploadGroup =dispatch_group_create();
    //dispatch_queue_t uploadGlobalQueue=dispatch_get_global_queue(0, 0);
    dispatch_group_enter(uploadGroup);
    
    if (self.selectType == PhotoSelectTypeImage) {
        request.type    = DISCOVER_TYPE_IMAGE;
        
        NSMutableArray *imgArr = [NSMutableArray array];
        for (PhotoSelectModel *model in self.selectedArray) {
            UIImage *image  = model.selectImage;
            NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
            [imgArr addObject:imgData];
        }
        request.imagesData = imgArr;
        
        dispatch_group_leave(uploadGroup);
        
    } else {
        
        request.type    = DISCOVER_TYPE_VIDEO;
        VideoSelectModel *model = self.selectedArray.lastObject;
        NSMutableArray *imgArr  = [NSMutableArray array];
        UIImage *image          = model.coverImage;
        NSData *imgData         = UIImageJPEGRepresentation(image, 0.5);
        [imgArr addObject:imgData];
        request.imagesData      = imgArr;
        
        // 展示视频处理动画
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"视频压缩中..."];
        });
        
        // 获取视频的path,并转成Data
        [[TZImageManager manager] getVideoOutputPathWithAsset:model.asset completion:^(NSString *outputPath) {
            // 判断是否能够获取到路径
            if (outputPath != nil) {
                // url
                NSURL *url = [NSURL fileURLWithPath:outputPath];
                
                // 视频文件大小
                CGFloat fileSize = [self fileSize:url];
                NSLog(@"当前视频文件大小 %f M",fileSize);
                
                // 压缩
                [[VideoServer new] compressVideoWithSourcePath:url andVideoSavePrefixName:@"compressed" ifNeedSaveLocal:YES CompressHandle:^(NSData *compData, BOOL compSuccess, CGFloat compSize) {
                    if (compSuccess) {
                        if (compSize <= 50) {
                            NSLog(@"视频压缩成功");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                            request.videoData = compData;
                            dispatch_group_leave(uploadGroup);
                        } else {
                            NSLog(@"视频文件过大，请重选一个");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                            POPUPINFO(@"视频文件过大，请重选一个");
                            dispatch_group_leave(uploadGroup);
                        }
                    } else {
                        NSLog(@"视频压缩失败,请重试");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                        POPUPINFO(@"视频压缩失败,请重试");
                        dispatch_group_leave(uploadGroup);
                    }
                }];
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                POPUPINFO(@"视频获取失败");
                dispatch_group_leave(uploadGroup);
            }
            
        }];
    }
    
    dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
        [SCHttpServiceFace serviceWithUploadRequest:request
                                           progress:^(NSProgress *uploadProgress)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showWithStatus:@"正在上传..."];
             });
         }
                                          onSuccess:^(id content)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 [self dismissViewControllerAnimated:YES completion:nil];
             });
             
         } onFailed:^(id content) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
             POPUPINFO(@"Failed");
         } onError:^(id content){
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
             POPUPINFO(@"Error");
         }];
    });
}

#pragma mark 定位
- (void)preparelocation {
    
    CLLocationManager *manger = [[CLLocationManager alloc]init];
    self.locationManager = manger;
    manger.delegate = self;
    manger.distanceFilter = 100;
    [manger requestAlwaysAuthorization];
    manger.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [manger startUpdatingLocation];
    }
}

//MARK: 地理信息反编码
- (void)reverseGeocodeWithLatitude:(double)latitude andLongitude:(double)longitude {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:self.currentLatitude longitude:self.currentLongitude];
    
    // 国外的没法反转
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //强制转成简体中文
        NSArray *array = @[@"zh-hans"];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"AppleLanguages"];
        
        if (error) {
            self.locationContent = @"无法获取当前位置";
            return ;
            
        } else {
            
            if (placemarks.count != 0) {
                CLPlacemark *place = placemarks[0];
                
                NSString *city = place.locality;
                
                if (city.length > 0) {
                    self.locationContent = city;
                }
                NSLog(@"位置, %@  %@",city,self.locationContent);
            } else {
                self.locationContent = @"无法获取当前位置";
            }
        }
        
        [self.tableView reloadData];
    }];
}

- (void)exitEditPage {
    
    UIAlertController *alerVC       = [UIAlertController alertControllerWithTitle:nil message:@"退出此次编辑" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction     *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction     *exitAction   = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 防止在出现上传前，点击取消
        [SVProgressHUD dismiss];
        [self.client cancel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alerVC addAction:cancelAction];
    [alerVC addAction:exitAction];
    
    [self presentViewController:alerVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        PhotoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = WHITE_COLOR;
        cell.selectedArray = self.selectedArray;
        cell.selectType = self.selectType;
        
        return cell;
        
    } else {
        LocationCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.locationLabel.text = self.locationContent;
        
        @weakify(self)
        cell.locationBlock = ^(UIButton *btn) {
            
            @strongify(self)
            [self preparelocation]; // 定位
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        MMAlertView *alert = [[MMAlertView alloc]initWithInputTitle:@"修改定位地址" detail:nil placeholder:self.locationContent handler:^(NSString *text) {
            self.locationContent = text;
            [tableView reloadData];
        }];
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        
        NSInteger count = self.selectedArray.count;
        if (count >= 0 && count <= 3) {
            return kPictureSelectItemWH + 2*10 + 10;
        } else if (count > 3 && count <= 7) {
            return kPictureSelectItemWH*2 + 3*10 + 10;
        } else {
            return kPictureSelectItemWH*3 + 4*10 + 10;
        }
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.wordTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.titleContent = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 超过20个字符不给输入
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString length] > 20) {
        textField.text = [toBeString substringToIndex:20];
        self.titleContent = textField.text;
        POPUPINFO(@"超过最大字数限制");
        return NO;
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.wordContent = textView.text;
    NSString *currentString = textView.text;
    
    if (currentString.length == 0) {
        self.placeHolderLabel.alpha = 1.0;
    } else {
        self.placeHolderLabel.alpha = 0.0;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currLocation = locations.lastObject;
    self.currentLongitude = currLocation.coordinate.longitude;
    self.currentLatitude  = currLocation.coordinate.latitude;
    
    //判断多大范围更新一次--不用一直更新
    [self reverseGeocodeWithLatitude:self.currentLatitude andLongitude:self.currentLongitude];
}

#pragma mark - VODUploadSVideoClientDelegate
-(void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *uploadPercent = [NSString stringWithFormat:@"%d %%",(int)(uploadedSize * 100/totalSize)];
        NSString *showTitle = [NSString stringWithFormat:@"视频上传中 %@",uploadPercent];
        [SVProgressHUD showWithStatus:showTitle];
    });
}

-(void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl {
    
    NSLog(@"uploadSuccess vid:%@, imageurl:%@",vid, imageUrl);
    [SVProgressHUD showWithStatus:@"正在提交..."];
    
    //再上传视频以外的其他信息
    RequestDiscoverUploadNew *request = [RequestDiscoverUploadNew new];
    request.type      = DISCOVER_TYPE_VIDEO;
    request.title     = self.titleContent;
    request.content   = self.wordContent == nil ? @"" : self.wordContent;
    request.longitude = [NSString stringWithFormat:@"%f",self.currentLongitude];
    request.latitude  = [NSString stringWithFormat:@"%f",self.currentLatitude];
    request.videoId   = vid;
    request.imagesUrl = imageUrl;
    BOOL isLocated    = [self.locationContent isEqualToString:@"点击定位图标获取位置"] ? NO : YES;
    request.address   = isLocated ? self.locationContent : @"";
    
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {
        [self setPostBtnState:YES];
        [SVProgressHUD showSuccessWithStatus:@"视频发布成功"];
        GCD_DELAY(^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }, 2.0f);
//        POPUPINFO(@"发布成功");
    } onFailed:^(id content) {
        [self setPostBtnState:YES];
//        [SVProgressHUD dismiss];
//        POPUPINFO(@"Failed");
    }];
}

-(void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    [SVProgressHUD dismiss];
    //NSLog(@"uploadFailedWithCode--%@ message--%@",code,message);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setPostBtnState:YES];
        [SVProgressHUD showErrorWithStatus:@"视频上传失败"];
    });
}

-(void)uploadTokenExpired {
    NSLog(@"uploadTokenExpired----");
    
    [[AliManger new] requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
        [self.client refreshWithAccessKeyId:keyId accessKeySecret:keySecret accessToken:token expireTime:expireTime];
        //[self postContentsUploadByAli];//上传视频的方法
    }];
}

-(void)uploadRetry {
    NSLog(@"uploadRetry");
    [self postContentsUploadByAli];//上传视频的方法
}

-(void)uploadRetryResume {
    NSLog(@"uploadRetryResume");
}

// 视频文件大小
- (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

- (void)setPostBtnState:(BOOL)isClick {
    if (isClick) {
        [self.postBtn setEnabled:YES];
        [self.postBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    } else {
        [self.postBtn setEnabled:NO];
        [self.postBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

//- (BOOL)prefersStatusBarHidden {
////    return self.isStatusHidden;
//}

- (void)dealloc {
    NSLog(@"have relased the MomentViewController");
}

#pragma mark lazy
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[LocationCell class]   forCellReuseIdentifier:@"LocationCell"];
        [_tableView registerClass:[PhotoTableCell class] forCellReuseIdentifier:@"PhotoTableCell"];
    }
    return _tableView;
}

- (NSMutableArray<PhotoSelectModel *> *)selectedArray {
    
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (UIButton *)postBtn {
    
    if (_postBtn == nil) {
        _postBtn = [[UIButton alloc]init];
        _postBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_postBtn setNormalColor:COLOR_MAIN];
        [_postBtn setTitle:@"发表" forState:UIControlStateNormal];
        [_postBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [_postBtn addTarget:self action:@selector(postButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

@end



