//
//  FormTextField.h
//
//  Created by Jarry on 14-1-23.
//  Copyright (c) 2014年 Zenin-tech. All rights reserved.
//

#import "MHTextField.h"

@interface FormTextField : MHTextField

@property   (nonatomic, copy)   NSString    *fieldTitle;
@property   (nonatomic, strong) UILabel     *titleLabel;

@property   (nonatomic, copy)   UIColor     *borderColor;

@property   (nonatomic) UIOffset edgeOffset;
             
@end
