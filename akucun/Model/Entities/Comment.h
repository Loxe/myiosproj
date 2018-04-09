//
//  Comment.h
//  akucun
//
//  Created by Jarry on 2017/4/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface Comment : JTModel

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *productid;
@property (nonatomic, copy) NSString *pinglunzheID;

@property (nonatomic, assign) NSTimeInterval modifytime;
@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger xuhao;

@end
