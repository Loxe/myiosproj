//
//  CorpCellLayout.h
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "CorpInfo.h"

@interface CorpCellLayout : AKCellLayout

@property (nonatomic,strong) CorpInfo* model;

@property (nonatomic,assign) BOOL isOpened;

@property (nonatomic,assign) CGFloat menuPosition;

@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic,assign) CGRect imagesRect;

//@property (nonatomic,assign) CGFloat contentLeft;
//@property (nonatomic,assign) CGFloat contentWidth;
//@property (nonatomic,assign) CGFloat contentBottom;


- (id) initWithModel:(CorpInfo *)model isOpened:(BOOL)isOpened;

@end
