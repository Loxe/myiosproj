//
//  OptionsPopupView.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMPopupView.h"

@interface OptionsPopupView : MMPopupView

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *options;

@property (nonatomic, copy) intIdBlock completeBolck;

- (instancetype) initWithTitle:(NSString *)title
                       options:(NSArray *)options
                        images:(NSArray *)images
                      selected:(NSInteger)index;

- (instancetype) initWithTitle:(NSString *)title
                       options:(NSArray *)options
                      selected:(NSInteger)index;

- (void) actionOK;

@end

@interface OptionPopupCell : UITableViewCell

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLabel;

@end
