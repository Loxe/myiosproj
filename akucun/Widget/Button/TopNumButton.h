//
//  TopNumButton.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopNumButton : UIButton

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) UILabel *numLabel;

- (void) setTitle:(NSString *)title number:(NSInteger)number;

@end
