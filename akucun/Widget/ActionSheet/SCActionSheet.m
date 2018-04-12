//
//  SCActionSheet.m
//  akucun
//
//  Created by Jarry on 2017/6/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "SCActionSheet.h"
//#include <objc/runtime.h>

@interface SCActionSheet ()

@property (nonatomic, strong) UIAlertController * alert;

@end

@implementation SCActionSheet

#pragma mark - public

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message items:(NSArray *)items
{
    self = [super init];
    if (self) {
        // 构造方法中创建声明的对象
        _alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        self.actionTitles = items;
    }
    return self;
}

- (void) showWithController:(UIViewController *)controller finished:(intBlock)finished
{
    self.finished = finished;
    // 在相应的Controller中弹出弹窗
    if (isPad) {
        _alert.popoverPresentationController.sourceView = controller.view;
    }
    [controller presentViewController:_alert animated:YES completion:nil];
}

#pragma mark - setter

// 重写声明的数组属性的setter方法
- (void) setActionTitles:(NSArray *)actionTitles
{
    // 对属性赋值
    _actionTitles = actionTitles;
    
    // for循环创建Action
    for (int i = 0; i < actionTitles.count; i++) {
                
        UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.finished) {
                self.finished(i);
            }
            // 点击之后返回到当前界面
            [self.alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
//        NSString *title = actionTitles[i];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
//        [text addAttribute:NSFontAttributeName value:[FontUtils buttonFont] range:NSMakeRange(0, title.length)];
//        [action setValue:text forKey:@"attributedTitle"];

        [action setValue:COLOR_SELECTED forKey:@"_titleTextColor"];
        [self.alert addAction:action];
    }
    
    // Cancel
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:GRAY_COLOR forKey:@"_titleTextColor"];
    [self.alert addAction:cancelAction];
}

@end
