//
//  PhotoTableCell.m
//  akucun
//
//  Created by deepin do on 2017/11/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PhotoTableCell.h"
#import "PhotoCollectionCell.h"
#import "TZImagePickerController.h"
#import "LZActionSheet.h"
#import "PhotoSelectModel.h"
#import "VideoSelectModel.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"

#import <AliyunVideoSDK/AliyunVideoSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImageManager.h"
#import "UIView+DDExtension.h"

@interface PhotoTableCell() <UICollectionViewDataSource, UICollectionViewDelegate,TZImagePickerControllerDelegate,AliyunVideoBaseDelegate>

@end

@implementation PhotoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.pictureCollectionView];
    [self.pictureCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
}

#pragma mark collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.selectType == 1) { //显示视频
        // 视频只有一个
        return 1;
        
    } else { //显示照片
        
        if (self.selectedArray.count == 0) {
            return 1;
        } else if (self.selectedArray.count > 0  && self.selectedArray.count < 9){
            return self.selectedArray.count + 1;
        } else {
            return 9;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
    NSInteger count = self.selectedArray.count;
    [cell.deletButton setHidden:NO];
    
    if (self.selectType == 1) { //显示视频
        
        if (count == 0) {
            cell.displayImageView.image = [UIImage imageNamed:@"compose_pic_add"];
            [cell.deletButton setHidden:YES];
            [cell.playImageView setHidden:YES];
            
        } else {
            VideoSelectModel *model = (VideoSelectModel *) self.selectedArray[indexPath.item];
            cell.displayImageView.image = model.coverImage;
            cell.videoModel = model;
            [cell.playImageView setHidden:NO];
            
            @weakify(self)
            cell.deleteBlock = ^(id nsobject) {
                
                @strongify(self)
                VideoSelectModel *model = (VideoSelectModel *)nsobject;
                [self.selectedArray removeObject:model];
                [[self getCurrentTableView:self] reloadData];
                [self.pictureCollectionView reloadData];
            };
        }
        
    } else {
        
        if (count == 0) {
            cell.displayImageView.image = [UIImage imageNamed:@"compose_pic_add"];
            [cell.deletButton setHidden:YES];
            
        } else if (count > 0  && count < 9){
            
            if (indexPath.item == count) {
                cell.displayImageView.image = [UIImage imageNamed:@"compose_pic_add"];
                [cell.deletButton setHidden:YES];
            } else {
                PhotoSelectModel *model = (PhotoSelectModel *)self.selectedArray[indexPath.item];
                UIImage *img = model.selectImage;
                cell.displayImageView.image = img;
                cell.photoModel = model;
                
                @weakify(self)
                cell.deleteBlock = ^(id nsobject) {
                    
                    @strongify(self)
                    PhotoSelectModel *model = (PhotoSelectModel *)nsobject;
                    [self.selectedArray removeObject:model];
                    [[self getCurrentTableView:self] reloadData];
                    [self.pictureCollectionView reloadData];
                };
            }
            
        } else {
            PhotoSelectModel *model = self.selectedArray[indexPath.item];
            UIImage *img = model.selectImage;
            cell.displayImageView.image = img;
            cell.photoModel = model;
            
            @weakify(self)
            cell.deleteBlock = ^(id nsobject) {
                
                @strongify(self)
                PhotoSelectModel *model = (PhotoSelectModel *)nsobject;
                [self.selectedArray removeObject:model];
                [[self getCurrentTableView:self] reloadData];
                [self.pictureCollectionView reloadData];
            };
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.selectedArray.count;
    if (self.selectType == 1) { //显示视频
        
        if (count == 0) {
            //[self takeVideo];
            [self takeAliVideo];
        } else {
            VideoSelectModel *model = (VideoSelectModel *)self.selectedArray[indexPath.item];
            [self previewVideo:model];
        }
        
    } else {
        
        if (count == 0) {
            [self takeAlbum];
        } else if (count > 0 && count <= 8) {
            if (indexPath.item == count) {
                [self takeAlbum];
            } else {
                [self previewPhoto:self.selectedArray withIndex:indexPath.item];
            }
        } else {
            [self previewPhoto:self.selectedArray withIndex:indexPath.item];
        }
    }
}

#pragma mark - 从手机相册选择
- (void)takeAlbum {
    
    //current maxImagesCount
    NSInteger currentMaxImagesCount = 9 - self.selectedArray.count;
    
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:currentMaxImagesCount columnNumber:4 delegate:self];
    pickerVC.allowPickingImage = YES;
    pickerVC.showSelectBtn     = YES;
    pickerVC.allowPickingGif   = NO;
    pickerVC.allowPickingVideo = NO;
    [[self getCurrentViewController:self] presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - 小视频
- (void)takeVideo {
    
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
    pickerVC.showSelectBtn     = YES;
    pickerVC.allowPickingVideo = YES;
    pickerVC.allowPickingGif   = NO;
    pickerVC.allowPickingImage = NO;
    [[self getCurrentViewController:self] presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - 视频录制与视频选择
- (void)takeAliVideo {
    AliyunVideoRecordParam *vrPara = [[AliyunVideoRecordParam alloc]init];
    vrPara.ratio       = isPad ? AliyunVideoVideoRatio1To1 : AliyunVideoVideoRatio3To4;
    vrPara.size        = AliyunVideoVideoSize540P;
    vrPara.minDuration = 1;
    vrPara.maxDuration = 120;
    vrPara.position    = AliyunCameraPositionBack;
    vrPara.beautifyStatus = YES;
    vrPara.beautifyValue  = 100;
    vrPara.encodeMode     = AliyunVideoQualityHight;
    vrPara.torchMode      = AliyunCameraTorchModeOff;
    vrPara.outputPath     = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
    
    AliyunVideoUIConfig *config     = [[AliyunVideoUIConfig alloc] init];
    config.timelineDeleteColor      = [UIColor redColor];
    config.timelineBackgroundCollor = [UIColor clearColor];
    //config.cutTopLineColor      = [UIColor clearColor];
    //config.cutBottomLineColor   = [UIColor clearColor];
    
    config.hiddenImportButton   = NO;
    config.hiddenFlashButton    = NO;
    config.hiddenBeautyButton   = NO;
    config.hiddenDeleteButton   = NO;
    config.hiddenCameraButton   = YES;
    config.hiddenDurationLabel  = NO;
    
    config.recordOnePart   = NO;
    config.imageBundleName = @"QPSDK";
    config.recordType      = AliyunVideoRecordTypeCombination;
    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
    
    UIViewController *recordVC = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:vrPara];
    [AliyunVideoBase shared].delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:recordVC];
    [[self getCurrentViewController:self] presentViewController:nav animated:YES completion:nil];
}

- (void)previewVideo:(VideoSelectModel *)model {
    
    TZVideoPlayerController *vc = [[TZVideoPlayerController alloc]init];
    TZAssetModel *assetModel = [TZAssetModel modelWithAsset:model.asset type:TZAssetModelMediaTypeVideo];
    vc.model                 = assetModel;
    vc.isAutoPlay            = YES;
    [[self getCurrentViewController:self] presentViewController:vc animated:YES completion:nil];
}

- (void)previewPhoto:(NSMutableArray<PhotoSelectModel *> *)modelArray withIndex:(NSInteger)index {
    
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *models = [NSMutableArray array];
    for (PhotoSelectModel *model in modelArray) {
        [photos addObject:model.selectImage];
        TZAssetModel *assetModel = [TZAssetModel modelWithAsset:model.asset type:TZAssetModelMediaTypePhoto];
        assetModel.isSelected = YES;
        [models addObject:assetModel];
    }
    
    TZPhotoPreviewController *vc = [[TZPhotoPreviewController alloc] init];
    vc.currentIndex = index;
    vc.models = models;
    vc.photos = photos;
    [[self getCurrentViewController:self] presentViewController:vc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    //NSLog(@"coverImage %@ asset %@", coverImage, asset);
    
    VideoSelectModel *model = [[VideoSelectModel alloc]init];
    model.coverImage = coverImage;
    model.asset = asset;
    [self.selectedArray addObject:model];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 刷新tableView和collectionView
    [[self getCurrentTableView:self] reloadData];
    [self.pictureCollectionView reloadData];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (photos.count != 0) {
        for (int i = 0; i < photos.count; i++) {
            PhotoSelectModel *model = [[PhotoSelectModel alloc]init];
            model.selectImage = photos[i];
            model.asset       = assets[i];
            [self.selectedArray addObject:model];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 刷新tableView和collectionView
    [[self getCurrentTableView:self] reloadData];
    [self.pictureCollectionView reloadData];
}

#pragma mark - ALiVideoRecordBaseDelegate
// 退出录制页面
- (void)videoBaseRecordVideoExit {
    //NSLog(@"退出录制页面");
    [[self getCurrentViewController:self] dismissViewControllerAnimated:YES completion:nil];
}

// 视频录制完成回调
- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
    
    [[self getCurrentViewController:self] dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"录制完成 videoPath %@",videoPath);
    
    dispatch_group_t uploadGroup =dispatch_group_create();
    dispatch_group_enter(uploadGroup);
    
    @weakify(self)
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        
        @strongify(self)
        NSLog(@"=====assetURL %@",assetURL);
        // 获取裁剪后的视频封面图
        UIImage *thumbnailImage = [self getScreenShotImageFromVideoPath:videoPath];
        
        __block TZAssetModel *assetModel;
        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
            NSLog(@"TZAlbumModel --%@",model);
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
                NSLog(@"TZAssetModel---%@",models);
                if (models.count > 0) {
                    assetModel = [models firstObject];
                    dispatch_group_leave(uploadGroup);
                }
            }];
        }];
        
        dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                VideoSelectModel *model = [[VideoSelectModel alloc]init];
                model.coverImage        = thumbnailImage;
                model.videoPath         = videoPath;
                model.asset             = assetModel.asset;
                [self.selectedArray addObject:model];
                
                [recordVC dismissViewControllerAnimated:YES completion:nil];
                // 刷新tableView和collectionView
                [[self getCurrentTableView:self] reloadData];
                [self.pictureCollectionView reloadData];
            });
        });
    }];
}

// 录制页跳转相册
- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {
    //NSLog(@"录制页跳转Library");
    AliyunVideoCropParam *vcPara = [[AliyunVideoCropParam alloc] init];
    vcPara.minDuration = 2.0;
    vcPara.videoOnly   = YES;
    vcPara.maxDuration = 10.0*60;
    vcPara.fps        = 25;
    vcPara.gop        = 1;
    vcPara.size       = AliyunVideoVideoSize540P;
    vcPara.ratio      = isPad ? AliyunVideoVideoRatio1To1 : AliyunVideoVideoRatio3To4;
    vcPara.cutMode    = AliyunVideoCutModeScaleAspectFill;
    vcPara.videoQuality = AliyunVideoQualityHight;
    vcPara.outputPath   = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
    return vcPara;
}

// 视频裁剪完成的回调
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {
    
    [[self getCurrentViewController:self] dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"视频裁剪完成  %@", videoPath);
    
    dispatch_group_t uploadGroup =dispatch_group_create();
    dispatch_group_enter(uploadGroup);
    
    @weakify(self)
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        
        NSLog(@"=====assetURL %@",assetURL);
        // 获取裁剪后的视频封面图
        UIImage *thumbnailImage = [self getScreenShotImageFromVideoPath:videoPath];
        
        @strongify(self)
        __block TZAssetModel *assetModel;
        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
            NSLog(@"TZAlbumModel --%@",model);
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
                NSLog(@"TZAssetModel---%@",models);
                if (models.count > 0) {
                    assetModel = [models firstObject];
                    dispatch_group_leave(uploadGroup);
                }
            }];
        }];
        
        dispatch_group_notify(uploadGroup, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                VideoSelectModel *model = [[VideoSelectModel alloc]init];
                model.coverImage        = thumbnailImage;
                model.videoPath         = videoPath;
                model.asset             = assetModel.asset;
                [self.selectedArray addObject:model];
                
                [cropVC dismissViewControllerAnimated:YES completion:nil];
                // 刷新tableView和collectionView
                [[self getCurrentTableView:self] reloadData];
                [self.pictureCollectionView reloadData];
            });
        });
    }];
}

- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {
    //NSLog(@"跳转录制页");
    return nil;
}

// 图片裁剪完成回调
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC image:(UIImage *)image {
    //NSLog(@"图片裁剪完成 image %@",image);
}

// 退出相册页
- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    //NSLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
}

#pragma mark lazy
- (UICollectionView *)pictureCollectionView {
    if (_pictureCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kPictureSelectItemWH, kPictureSelectItemWH);
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.frame collectionViewLayout:flowLayout];
        _pictureCollectionView = collectionView;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        collectionView.pagingEnabled = NO;
        collectionView.bounces = NO;
        
        //注册cell
        [collectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:@"PhotoCollectionCell"];
    }
    return _pictureCollectionView;
}

- (NSMutableArray *)selectedArray {
    
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


@end

