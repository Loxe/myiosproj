//
//  TeamHeaderCell.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"
#import "ResponseTeamDetail.h"

typedef void(^ClickBlock)(id nsobject);

@interface TeamHeaderCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray   *titelLabelArray;
@property (nonatomic, strong) NSMutableArray   *smallPointArray;
@property (nonatomic, strong) NSMutableArray   *bigPointArray;
@property (nonatomic, strong) NSMutableArray   *descLabelArray;
@property (nonatomic, strong) NSMutableArray   *levelArray;

@property(nonatomic, strong) UILabel *levelLabel;
@property(nonatomic, strong) UILabel *levelDetailLabel;

@property(nonatomic, strong) UIButton   *detailBtn;
@property(nonatomic,   copy) ClickBlock detailBlock;

@property(nonatomic, strong) UILabel *teamTitleLabel;
//@property(nonatomic, strong) UILabel *teamCountLabel;
@property(nonatomic, strong) UICountingLabel *teamCountLabel;

@property(nonatomic, strong) UILabel *T1Label;
@property(nonatomic, strong) UIView  *T1Line;
@property(nonatomic, strong) UIView  *T1SmallPoint;
@property(nonatomic, strong) UIView  *T1BigPoint;
@property(nonatomic, strong) UILabel *T1DescLabel;

@property(nonatomic, strong) UILabel *T2Label;
@property(nonatomic, strong) UIView  *T2Line;
@property(nonatomic, strong) UIView  *T2SmallPoint;
@property(nonatomic, strong) UIView  *T2BigPoint;
@property(nonatomic, strong) UILabel *T2DescLabel;

@property(nonatomic, strong) UILabel *T3Label;
@property(nonatomic, strong) UIView  *T3Line;
@property(nonatomic, strong) UIView  *T3SmallPoint;
@property(nonatomic, strong) UIView  *T3BigPoint;
@property(nonatomic, strong) UILabel *T3DescLabel;

@property(nonatomic, strong) UILabel *T4Label;
@property(nonatomic, strong) UIView  *T4Line;
@property(nonatomic, strong) UIView  *T4SmallPoint;
@property(nonatomic, strong) UIView  *T4BigPoint;
@property(nonatomic, strong) UILabel *T4DescLabel;

@property(nonatomic, strong) UILabel *T5Label;
@property(nonatomic, strong) UIView  *T5Line;
@property(nonatomic, strong) UIView  *T5SmallPoint;
@property(nonatomic, strong) UIView  *T5BigPoint;
@property(nonatomic, strong) UILabel *T5DescLabel;

@property(nonatomic, strong) UILabel *T6Label;
@property(nonatomic, strong) UIView  *T6Line;
@property(nonatomic, strong) UIView  *T6SmallPoint;
@property(nonatomic, strong) UIView  *T6BigPoint;
@property(nonatomic, strong) UILabel *T6DescLabel;

@property(nonatomic, strong) UIView  *separateLine;

@property(nonatomic, strong) ResponseTeamDetail *response;

@end
