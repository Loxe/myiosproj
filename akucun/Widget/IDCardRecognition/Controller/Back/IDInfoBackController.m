//
//  IDInfoBackController.m
//  IDCardRecognition
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 zhongfeng. All rights reserved.
//

#import "IDInfoBackController.h"
#import "IDInfo.h"
#import "AVCaptureBackController.h"
#import "IDCardController.h"

@interface IDInfoBackController ()

@property (strong, nonatomic) IBOutlet UIImageView *IDImageView;
@property (strong, nonatomic) IBOutlet UILabel *IDNumLabel;

@end

@implementation IDInfoBackController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"身份证信息";
    
    self.IDImageView.layer.cornerRadius = 8;
    self.IDImageView.layer.masksToBounds = YES;
    
    self.IDNumLabel.text = _IDInfo.num;
    self.IDImageView.image = _IDImage;
}

#pragma mark - 错误，重新拍摄
- (IBAction)shootAgain:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 正确，下一步
- (IBAction)nextStep:(UIButton *)sender {
    NSLog(@"经用户核对，身份证号码正确，那就进行下一步，比如身份证图像或号码经加密后，传递给后台");
    
    NSArray *vcArray = self.navigationController.viewControllers;
    for (UIViewController *tempVC in vcArray) {
        if ([tempVC isKindOfClass:[IDCardController class]]) {
            IDCardController *IDCardVC = (IDCardController *)tempVC;
            IDCardVC.IDCardBackImg = _IDImage;
            [self.navigationController popToViewController:IDCardVC animated:YES];
        }
    }
}





@end
