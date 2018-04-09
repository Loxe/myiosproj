//
//  ASaleOptionsView.h
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASaleOptionsView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *despTitle;

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *despOptions;

@property (nonatomic, copy) intBlock selectBlock;

- (instancetype) initWithFrame:(CGRect)frame options:(NSArray *)options;

- (void) selectItem:(NSInteger)index;

@end
