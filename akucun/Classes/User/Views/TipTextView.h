//
//  TipTextView.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipTextView : UIView

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *textLabel;

- (void) setText:(NSString *)text;

- (void) setAttributeText:(NSAttributedString *)attrText;

@end
