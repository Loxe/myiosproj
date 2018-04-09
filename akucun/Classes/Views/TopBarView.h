//
//  TopBarView.h
//  akucun
//
//  Created by Jarry on 2017/6/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBarView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) intBlock selectBlock;

- (instancetype) initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
