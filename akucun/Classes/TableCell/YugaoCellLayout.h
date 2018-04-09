//
//  YugaoCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/4/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "LiveInfo.h"
#import "Trailer.h"

@interface YugaoCellLayout : AKCellLayout

@property (nonatomic,strong) LiveInfo* model;
@property (nonatomic,strong) Trailer* trailer;

@property (nonatomic,assign) BOOL isOpened;

@property (nonatomic,assign) CGFloat menuPosition;

@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic,assign) CGRect imagesRect;
//@property (nonatomic,copy) NSArray* imagePostions;

@property (nonatomic,assign) CGFloat contentLeft;
@property (nonatomic,assign) CGFloat contentWidth;
@property (nonatomic,assign) CGFloat contentBottom;

@property (nonatomic,assign) CGFloat nameCenterY, nameRight;


- (id) initWithModel:(LiveInfo *)model isOpened:(BOOL)isOpened;

- (id) initWithTrailer:(Trailer *)trailer isOpened:(BOOL)isOpened;

@end
