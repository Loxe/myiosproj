//
//  TeamHeaderCell.m
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#define kLineW         (SCREEN_WIDTH-3*kOFFSET_SIZE-2*5)/5 //左右各多减了5，不然字显示不下
#define kSmallPointW   8.0
#define kBigPointW     10.0

#import "TeamHeaderCell.h"
#import "UIView+DDExtension.h"

@interface TeamHeaderCell()

@property(nonatomic, assign) NSInteger level;       // 团队等级
@property(nonatomic, assign) NSInteger monthsTotal; // 团队销售额

@property(nonatomic, assign) NSInteger todoReward;  // 待入账返利
@property(nonatomic, assign) NSInteger rewardTotal; // 累积返利金额

@property(nonatomic, assign) CGFloat attrWidth;

@end

@implementation TeamHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.levelDetailLabel];
//    [self.contentView addSubview:self.detailBtn];
    [self.contentView addSubview:self.teamTitleLabel];
    [self.contentView addSubview:self.teamCountLabel];
    
    [self.contentView addSubview:self.T1Label];
    [self.contentView addSubview:self.T1Line];
    [self.contentView addSubview:self.T1SmallPoint];
    [self.contentView addSubview:self.T1BigPoint];
    [self.contentView addSubview:self.T1DescLabel];
    
    [self.contentView addSubview:self.T2Label];
    [self.contentView addSubview:self.T2Line];
    [self.contentView addSubview:self.T2SmallPoint];
    [self.contentView addSubview:self.T2BigPoint];
    [self.contentView addSubview:self.T2DescLabel];
    
    [self.contentView addSubview:self.T3Label];
    [self.contentView addSubview:self.T3Line];
    [self.contentView addSubview:self.T3SmallPoint];
    [self.contentView addSubview:self.T3BigPoint];
    [self.contentView addSubview:self.T3DescLabel];
    
    [self.contentView addSubview:self.T4Label];
    [self.contentView addSubview:self.T4Line];
    [self.contentView addSubview:self.T4SmallPoint];
    [self.contentView addSubview:self.T4BigPoint];
    [self.contentView addSubview:self.T4DescLabel];
    
    [self.contentView addSubview:self.T5Label];
    [self.contentView addSubview:self.T5Line];
    [self.contentView addSubview:self.T5SmallPoint];
    [self.contentView addSubview:self.T5BigPoint];
    [self.contentView addSubview:self.T5DescLabel];
    
    [self.contentView addSubview:self.T6Label];
    [self.contentView addSubview:self.T6Line];
    [self.contentView addSubview:self.T6SmallPoint];
    [self.contentView addSubview:self.T6BigPoint];
    [self.contentView addSubview:self.T6DescLabel];
    [self.contentView addSubview:self.separateLine];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE);
        make.top.equalTo(self.contentView).offset(kOFFSET_SIZE*1.2);
//        make.height.equalTo(@30);
    }];

    [self.levelDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.levelLabel).offset(2);
        make.left.equalTo(self.levelLabel.mas_right).offset(0.5*kOFFSET_SIZE);
        make.width.equalTo(@60);
//        make.height.equalTo(@30);
    }];

//    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.levelLabel);
//        make.right.equalTo(self.contentView).offset(-kOFFSET_SIZE);
//        make.width.equalTo(@90);
//        make.height.equalTo(@30);
//    }];
    
    [self.teamTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(60);
        make.centerX.equalTo(self.contentView);
//        make.height.equalTo(@30);
    }];
    
//    [self.teamCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.teamTitleLabel.mas_bottom).offset(kOFFSET_SIZE);
//        make.centerX.equalTo(self.contentView);
//        make.height.equalTo(@50);
//    }];
    
    /** T1 */
    [self.T1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-60);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE*1.5+kSmallPointW*0.5);
        make.width.equalTo(@(kLineW));
        make.height.equalTo(@1);
    }];
    
    [self.T1SmallPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE*1.5);
        make.centerY.equalTo(self.T1Line);
        make.width.height.equalTo(@(kSmallPointW));
    }];
    
    [self.T1BigPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.T1SmallPoint);
        make.width.height.equalTo(@(kBigPointW));
    }];
    
    [self.T1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T1BigPoint);
        make.bottom.equalTo(self.T1BigPoint.mas_top).offset(-8);
        make.width.height.equalTo(@30);
    }];
    
    [self.T1DescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.T1BigPoint);
        make.left.equalTo(self.contentView).offset(kOFFSET_SIZE*1.5-kSmallPointW);
        make.top.equalTo(self.T1BigPoint.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(kLineW-20));
        make.height.equalTo(@30);
    }];
    
    /** T2 */
    [self.T2Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.T1Line);
        make.left.equalTo(self.T1Line.mas_right);
        make.width.equalTo(@(kLineW));
        make.height.equalTo(@1);
    }];
    
    [self.T2SmallPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.T2Line).offset(-kSmallPointW*0.5);
        make.centerY.equalTo(self.T2Line);
        make.width.height.equalTo(@(kSmallPointW));
    }];
    
    [self.T2BigPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.T2SmallPoint);
        make.width.height.equalTo(@(kBigPointW));
    }];
    
    [self.T2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T2BigPoint);
        make.bottom.equalTo(self.T2BigPoint.mas_top).offset(-8);
        make.width.height.equalTo(@30);
    }];
    
    [self.T2DescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T2BigPoint);
        make.top.equalTo(self.T2BigPoint.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(kLineW-5));
        make.height.equalTo(@30);
    }];
    
    /** T3 */
    [self.T3Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.T1Line);
        make.left.equalTo(self.T2Line.mas_right);
        make.width.equalTo(@(kLineW));
        make.height.equalTo(@1);
    }];
    
    [self.T3SmallPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.T3Line).offset(-kSmallPointW*0.5);
        make.centerY.equalTo(self.T3Line);
        make.width.height.equalTo(@(kSmallPointW));
    }];
    
    [self.T3BigPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.T3SmallPoint);
        make.width.height.equalTo(@(kBigPointW));
    }];
    
    [self.T3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T3BigPoint);
        make.bottom.equalTo(self.T3BigPoint.mas_top).offset(-8);
        make.width.height.equalTo(@30);
    }];
    
    [self.T3DescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T3BigPoint);
        make.top.equalTo(self.T3BigPoint.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(kLineW-5));
        make.height.equalTo(@30);
    }];
    
    /** T4 */
    [self.T4Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.T1Line);
        make.left.equalTo(self.T3Line.mas_right);
        make.width.equalTo(@(kLineW));
        make.height.equalTo(@1);
    }];
    
    [self.T4SmallPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.T4Line).offset(-kSmallPointW*0.5);
        make.centerY.equalTo(self.T4Line);
        make.width.height.equalTo(@(kSmallPointW));
    }];
    
    [self.T4BigPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.T4SmallPoint);
        make.width.height.equalTo(@(kBigPointW));
    }];
    
    [self.T4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T4BigPoint);
        make.bottom.equalTo(self.T4BigPoint.mas_top).offset(-8);
        make.width.height.equalTo(@30);
    }];
    
    [self.T4DescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T4BigPoint);
        make.top.equalTo(self.T4BigPoint.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(kLineW-5));
        make.height.equalTo(@30);
    }];
    
    /** T5 */
    [self.T5Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.T1Line);
        make.left.equalTo(self.T4Line.mas_right);
        make.width.equalTo(@(kLineW));
        make.height.equalTo(@1);
    }];
    
    [self.T5SmallPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.T5Line).offset(-kSmallPointW*0.5);
        make.centerY.equalTo(self.T5Line);
        make.width.height.equalTo(@(kSmallPointW));
    }];
    
    [self.T5BigPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.T5SmallPoint);
        make.width.height.equalTo(@(kBigPointW));
    }];
    
    [self.T5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T5BigPoint);
        make.bottom.equalTo(self.T5BigPoint.mas_top).offset(-8);
        make.width.height.equalTo(@30);
    }];
    
    [self.T5DescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T5BigPoint);
        make.top.equalTo(self.T5BigPoint.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(kLineW-5));
        make.height.equalTo(@30);
    }];
    
    /** T6 */
    [self.T6Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.T1Line);
        make.left.equalTo(self.T5Line.mas_right);
        make.width.equalTo(@(kLineW));
        make.height.equalTo(@1);
    }];
    
    [self.T6SmallPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.T6Line).offset(-kSmallPointW*0.5);
        make.centerY.equalTo(self.T6Line);
        make.width.height.equalTo(@(kSmallPointW));
    }];
    
    [self.T6BigPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.T6SmallPoint);
        make.width.height.equalTo(@(kBigPointW));
    }];
    
    [self.T6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T6BigPoint);
        make.bottom.equalTo(self.T6BigPoint.mas_top).offset(-8);
        make.width.height.equalTo(@30);
    }];
    
    [self.T6DescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.T6BigPoint);
        make.top.equalTo(self.T6BigPoint.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(kLineW-10));
        make.height.equalTo(@30);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.teamCountLabel setHidden:YES];
    
    // 默认不显示大点
    [self.T1BigPoint setHidden:YES];
    [self.T2BigPoint setHidden:YES];
    [self.T3BigPoint setHidden:YES];
    [self.T4BigPoint setHidden:YES];
    [self.T5BigPoint setHidden:YES];
    [self.T6BigPoint setHidden:YES];
    
    [self.T6Line setHidden:YES];
    
    self.titelLabelArray = [NSMutableArray arrayWithArray:@[self.T1Label, self.T2Label, self.T3Label, self.T4Label, self.T5Label, self.T6Label]];
    self.smallPointArray = [NSMutableArray arrayWithArray:@[self.T1SmallPoint, self.T2SmallPoint, self.T3SmallPoint, self.T4SmallPoint, self.T5SmallPoint, self.T6SmallPoint]];
    self.bigPointArray   = [NSMutableArray arrayWithArray:@[self.T1BigPoint, self.T2BigPoint, self.T3BigPoint, self.T4BigPoint, self.T5BigPoint, self.T6BigPoint]];
    self.descLabelArray  = [NSMutableArray arrayWithArray:@[self.T1DescLabel, self.T2DescLabel, self.T3DescLabel, self.T4DescLabel, self.T5DescLabel, self.T6DescLabel]];
}

- (void)setResponse:(ResponseTeamDetail *)response {
    
    /**一、 处理数据 */
    self.level       = response.level;
    self.monthsTotal = response.monthsTotal;

    NSString *level1 = [NSString stringWithFormat:@"%ldW",(long)response.levelOne/1000000];
    NSString *level2 = [NSString stringWithFormat:@"%ldW",(long)response.levelTwo/1000000];
    NSString *level3 = [NSString stringWithFormat:@"%ldW",(long)response.levelThree/1000000];
    NSString *level4 = [NSString stringWithFormat:@"%ldW",(long)response.levelFour/1000000];
    NSString *level5 = [NSString stringWithFormat:@"%ldW",(long)response.levelFive/1000000];
    NSString *level6 = [NSString stringWithFormat:@"%ldW",(long)response.levelSix/1000000];
    
    self.levelArray = [NSMutableArray arrayWithArray:@[level1, level2, level3, level4, level5, level6]];
    
    /**二、赋值数据 */
    /** 1.等级数值 */
    self.levelDetailLabel.text = [NSString stringWithFormat:@"T%ld",(long)self.level];
    self.levelDetailLabel.textColor = self.level > 0 ? COLOR_MAIN : COLOR_TEXT_NORMAL;
    
    /** 2.总金额label */
    CGFloat beginValue = 100;
    CGFloat toValue    = self.monthsTotal / 100.0f;
    
    if (toValue > 100) {
        NSLog(@"======>> 100");
        // 根据toValue，来决定起始数字位数
        NSString *toValueStr = FORMAT(@"%.0f",toValue); // 去掉小数点
        NSString *beginValueStr = @"1";
        for (int i = 0; i < toValueStr.length-1; i++) {
            beginValueStr = [beginValueStr stringByAppendingFormat:@"%d",0];
        }
        beginValue = [beginValueStr floatValue];
        
        //1 普通文本，带逗号
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterDecimalStyle;
        //            cell.teamCountLabel.formatBlock = ^NSString *(CGFloat value) {
        //                NSString *formatted = [formatter stringFromNumber:@((int)value)];
        //                return [NSString stringWithFormat:@"¥ %@",formatted];
        //            };
        //            cell.teamCountLabel.method = UILabelCountingMethodEaseOut;
        //            [cell.teamCountLabel countFrom:100000 to:toValue withDuration:1.5];
        
        //2 富文本显示
        self.teamCountLabel.attributedFormatBlock = ^NSAttributedString *(CGFloat value) {
            //NSDictionary *normal    = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-UltraLight" size: 20] };
            //NSDictionary *highlight = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 20] };
            NSDictionary *pre  = @{ NSFontAttributeName: BOLDSYSTEMFONT(14) };
            NSDictionary *post = @{ NSFontAttributeName: SYSTEMFONT(32) };
            
            //NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
            //[attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
            NSString *prefix    = @"¥ ";
            NSString *formatted = [formatter stringFromNumber:@((int)value)];
            //NSString *postfix = [NSString stringWithFormat:@"%d", (int)value];
            NSString *postfix   = [NSString stringWithFormat:@"%@",formatted];
            
            //NSMutableAttributedString *prefixAttr = [[NSMutableAttributedString alloc] initWithString: prefix
            //                                                                                           attributes: pre];
            //NSAttributedString *postfixAttr = [[NSAttributedString alloc] initWithString: postfix
            //                                                                              attributes: normal];
            NSMutableAttributedString *prefixAttr  = [[NSMutableAttributedString alloc] initWithString: prefix
                                                                                            attributes: pre];
            NSAttributedString        *postfixAttr = [[NSAttributedString alloc] initWithString: postfix
                                                                                     attributes: post];
            [prefixAttr appendAttributedString: postfixAttr];
            return prefixAttr;
        };
        
        [self.teamCountLabel countFrom:beginValue to:toValue withDuration:1.5];
        [self.teamCountLabel sizeToFit];
        [self.teamCountLabel setHidden:NO];
        CGSize attrSize = [self.teamCountLabel.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                           context:nil].size;
        
//        self.attrWidth = attrSize.width+50;
        self.attrWidth = attrSize.width;
        
    } else if (toValue > 0 && toValue < 100) {
        
        NSLog(@"======>> 0 && 100");
        NSNumber *teamNum  = [NSNumber numberWithInteger:self.monthsTotal];
        NSString *priceStr = [self.contentView getPriceString:teamNum];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
        self.teamCountLabel.attributedText = attrText;
        [self.teamCountLabel sizeToFit];
        [self.teamCountLabel setHidden:NO];
        
        CGSize attrSize = [self.teamCountLabel.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                           context:nil].size;
        self.attrWidth = attrSize.width+50;
//        self.attrWidth = attrSize.width;
    } else {
        NSLog(@"======> < 0");
//        [self.teamCountLabel setHidden:YES];
//        self.attrWidth = 0.0;
        NSNumber *teamNum  = [NSNumber numberWithInteger:self.monthsTotal];
        NSString *priceStr = [self.contentView getPriceString:teamNum];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrText addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(14) range:NSMakeRange(0, 2)];
        self.teamCountLabel.attributedText = attrText;
        [self.teamCountLabel sizeToFit];
        [self.teamCountLabel setHidden:NO];
        
        CGSize attrSize = [self.teamCountLabel.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                           context:nil].size;
        self.attrWidth = attrSize.width+50;
//        self.attrWidth = attrSize.width;
    }

    
    /** 3.等级阶段控件处理 */
    if (self.level <= 0) {
        for (int i = 0; i <= self.levelArray.count-1; i++) {
            UILabel *label = (UILabel *)self.descLabelArray[i];
            label.text = self.levelArray[i];
        }
        
        NSString  *sourceStr = @"差5W升级";
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:sourceStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(1, sourceStr.length-3)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(sourceStr.length-2, 2)];
        
        self.T1DescLabel.attributedText = attStr;
        
    } else {
        
        for (int i = 0; i <= self.levelArray.count-1; i++) {
            if (i+1 < self.level) {
                UILabel *titleLabel = (UILabel *)self.titelLabelArray[i];
                //titleLabel.text = [NSString stringWithFormat:@"T%d",i+1];
                titleLabel.textColor = COLOR_TEXT_DARK;
                
                UILabel *descLabel  = (UILabel *)self.descLabelArray[i];
                descLabel.text      = self.levelArray[i];
                descLabel.textColor = COLOR_TEXT_DARK;
                
                UIView *smallPoint = (UIView *)self.smallPointArray[i];
                smallPoint.backgroundColor = COLOR_TEXT_DARK;
                
            } else if (i+1 == self.level) {
                UILabel *titleLabel = (UILabel *)self.titelLabelArray[i];
                //titleLabel.text = [NSString stringWithFormat:@"T%d",i+1];
                titleLabel.textColor = COLOR_MAIN;
                titleLabel.font = SYSTEMFONT(20);
                
                UILabel *descLabel  = (UILabel *)self.descLabelArray[i];
                descLabel.text      = self.levelArray[i];
                descLabel.textColor = COLOR_MAIN;
                
                UIView *smallPoint = (UIView *)self.smallPointArray[i];
                [smallPoint setHidden:YES];
                
                UIView *bigPoint = (UIView *)self.bigPointArray[i];
                [bigPoint setHidden:NO];
                
            } else {
//                UILabel *titleLabel = (UILabel *)self.titelLabelArray[i];
                //titleLabel.text = [NSString stringWithFormat:@"T%d",i+1];
                
                UILabel *descLabel  = (UILabel *)self.descLabelArray[i];
                descLabel.text      = self.levelArray[i];
                
                if (self.level+1 <= self.levelArray.count && i == self.level) { //特殊处理
                    
                    NSString  *specialStr1 = self.levelArray[i];
                    NSString  *specialStr2 = [specialStr1 substringToIndex:specialStr1.length-1];
                    NSInteger special      = [specialStr2 integerValue]*1000000;
                    
                    NSInteger needFenCount = special - self.monthsTotal;
                    CGFloat   value        = needFenCount / 1000000.0f;
                    NSString  *neeYuanStr  = FORMAT(@"%.0f",value);
                    NSString  *sourceStr   = [NSString stringWithFormat:@"差%@W升级",neeYuanStr];
                    
                    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:sourceStr];
                    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, 1)];
                    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(1, sourceStr.length-3)];
                    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(sourceStr.length-2, 2)];
                    
                    UILabel *descLabel = (UILabel *)self.descLabelArray[i];
                    descLabel.attributedText = attStr;
                }
            }
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.teamCountLabel.left  = (SCREEN_WIDTH-self.attrWidth)*0.5;
    self.teamCountLabel.top   = self.teamTitleLabel.bottom + kOFFSET_SIZE;
    self.teamCountLabel.width = self.attrWidth + 50;
//    self.teamCountLabel.width = self.attrWidth;
}

- (void)detailBtnDidClick:(UIButton *)btn {
    if (self.detailBlock) {
        self.detailBlock(btn);
    }
}

#pragma mark - LAZY
- (UILabel *)levelLabel {
    if (_levelLabel == nil) {
        _levelLabel = [[UILabel alloc]init];
        _levelLabel.text      = @"团队等级:";
        _levelLabel.textColor = COLOR_TEXT_NORMAL;
        _levelLabel.font      = BOLDSYSTEMFONT(13);
    }
    return _levelLabel;
}

- (UILabel *)levelDetailLabel {
    if (_levelDetailLabel == nil) {
        _levelDetailLabel = [[UILabel alloc]init];
        _levelDetailLabel.text      = @"--";
        _levelDetailLabel.textColor = COLOR_MAIN;
        _levelDetailLabel.font      = BOLDSYSTEMFONT(25);
    }
    return _levelDetailLabel;
}

- (UIButton *)detailBtn {
    if (_detailBtn == nil) {
        _detailBtn = [[UIButton alloc]init];
        _detailBtn.titleLabel.font = [FontUtils smallFont];
        [_detailBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        
        NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc]initWithString:@"团队返利规则"];
        [normalStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [normalStr length])];
        [normalStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_NORMAL range:NSMakeRange(0, [normalStr length])];
        
        NSMutableAttributedString *highlightStr = [[NSMutableAttributedString alloc]initWithString:@"团队返利规则"];
        [highlightStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightStr length])];
        
        [_detailBtn setAttributedTitle:normalStr forState:UIControlStateNormal];
        [_detailBtn setAttributedTitle:highlightStr forState:UIControlStateHighlighted];
        [_detailBtn addTarget:self action:@selector(detailBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
}

- (UILabel *)teamTitleLabel {
    if (_teamTitleLabel == nil) {
        _teamTitleLabel = [[UILabel alloc]init];
        _teamTitleLabel.text      = @"团队销售额";
        _teamTitleLabel.textColor = COLOR_TEXT_NORMAL;
        _teamTitleLabel.font      = [FontUtils smallFont];
    }
    return _teamTitleLabel;
}

- (UICountingLabel *)teamCountLabel {
    if (_teamCountLabel == nil) {
        _teamCountLabel = [[UICountingLabel alloc]init];
//        _teamCountLabel.backgroundColor = [UIColor orangeColor];
        _teamCountLabel.textColor = COLOR_MAIN;
        _teamCountLabel.font      = BOLDSYSTEMFONT(32);
        _teamCountLabel.animationDuration = 1.0f;
    }
    return _teamCountLabel;
}

- (UILabel *)T1Label {
    if (_T1Label == nil) {
        _T1Label = [[UILabel alloc]init];
        _T1Label.text      = @"T1";
        _T1Label.textColor = COLOR_TEXT_LIGHT;
        _T1Label.font      = [FontUtils smallFont];
        _T1Label.textAlignment = NSTextAlignmentCenter;
    }
    return _T1Label;
}

- (UIView *)T1Line {
    if (_T1Line == nil) {
        _T1Line = [[UIView alloc]init];
        _T1Line.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _T1Line;
}

- (UIView *)T1SmallPoint {
    if (_T1SmallPoint == nil) {
        _T1SmallPoint = [[UIView alloc]init];
        _T1SmallPoint.backgroundColor     = COLOR_TEXT_LIGHT;
        _T1SmallPoint.layer.cornerRadius  = 0.5*kSmallPointW;
        _T1SmallPoint.layer.masksToBounds = YES;
        _T1SmallPoint.layer.borderColor   = WHITE_COLOR.CGColor;
        _T1SmallPoint.layer.borderWidth   = 0.5;
    }
    return _T1SmallPoint;
}

- (UIView *)T1BigPoint {
    if (_T1BigPoint == nil) {
        _T1BigPoint = [[UIView alloc]init];
        _T1BigPoint.backgroundColor     = COLOR_MAIN;
        _T1BigPoint.layer.cornerRadius  = 0.5*kBigPointW;
        _T1BigPoint.layer.masksToBounds = YES;
        _T1BigPoint.layer.borderColor   = COLOR_MAIN.CGColor;
        _T1BigPoint.layer.borderWidth   = 0.5;
    }
    return _T1BigPoint;
}

- (UILabel *)T1DescLabel {
    if (_T1DescLabel == nil) {
        _T1DescLabel = [[UILabel alloc]init];
        _T1DescLabel.text      = @"";
        _T1DescLabel.textColor = COLOR_TEXT_LIGHT;
        _T1DescLabel.font      = SYSTEMFONT(11);
        _T1DescLabel.adjustsFontSizeToFitWidth = YES;
        _T1DescLabel.textAlignment = NSTextAlignmentCenter;
        _T1DescLabel.numberOfLines = 0;
    }
    return _T1DescLabel;
}

- (UILabel *)T2Label {
    if (_T2Label == nil) {
        _T2Label = [[UILabel alloc]init];
        _T2Label.text      = @"T2";
        _T2Label.textColor = COLOR_TEXT_LIGHT;
        _T2Label.font      = [FontUtils smallFont];
        _T2Label.textAlignment = NSTextAlignmentCenter;
    }
    return _T2Label;
}

- (UIView *)T2Line {
    if (_T2Line == nil) {
        _T2Line = [[UIView alloc]init];
        _T2Line.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _T2Line;
}

- (UIView *)T2SmallPoint {
    if (_T2SmallPoint == nil) {
        _T2SmallPoint = [[UIView alloc]init];
        _T2SmallPoint.backgroundColor     = COLOR_TEXT_LIGHT;
        _T2SmallPoint.layer.cornerRadius  = 0.5*kSmallPointW;
        _T2SmallPoint.layer.masksToBounds = YES;
        _T2SmallPoint.layer.borderColor   = WHITE_COLOR.CGColor;
        _T2SmallPoint.layer.borderWidth   = 0.5;
    }
    return _T2SmallPoint;
}

- (UIView *)T2BigPoint {
    if (_T2BigPoint == nil) {
        _T2BigPoint = [[UIView alloc]init];
        _T2BigPoint.backgroundColor     = COLOR_MAIN;
        _T2BigPoint.layer.cornerRadius  = 0.5*kBigPointW;
        _T2BigPoint.layer.masksToBounds = YES;
        _T2BigPoint.layer.borderColor   = COLOR_MAIN.CGColor;
        _T2BigPoint.layer.borderWidth   = 0.5;
    }
    return _T2BigPoint;
}

- (UILabel *)T2DescLabel {
    if (_T2DescLabel == nil) {
        _T2DescLabel = [[UILabel alloc]init];
        _T2DescLabel.text      = @"";
        _T2DescLabel.textColor = COLOR_TEXT_LIGHT;
        _T2DescLabel.font      = SYSTEMFONT(11);
        _T2DescLabel.adjustsFontSizeToFitWidth = YES;
        _T2DescLabel.textAlignment = NSTextAlignmentCenter;
        _T2DescLabel.numberOfLines = 0;
    }
    return _T2DescLabel;
}

- (UILabel *)T3Label {
    if (_T3Label == nil) {
        _T3Label = [[UILabel alloc]init];
        _T3Label.text      = @"T3";
        _T3Label.textColor = COLOR_TEXT_LIGHT;
        _T3Label.font      = [FontUtils smallFont];
        _T3Label.textAlignment = NSTextAlignmentCenter;
    }
    return _T3Label;
}

- (UIView *)T3Line {
    if (_T3Line == nil) {
        _T3Line = [[UIView alloc]init];
        _T3Line.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _T3Line;
}

- (UIView *)T3SmallPoint {
    if (_T3SmallPoint == nil) {
        _T3SmallPoint = [[UIView alloc]init];
        _T3SmallPoint.backgroundColor     = COLOR_TEXT_LIGHT;
        _T3SmallPoint.layer.cornerRadius  = 0.5*kSmallPointW;
        _T3SmallPoint.layer.masksToBounds = YES;
        _T3SmallPoint.layer.borderColor   = WHITE_COLOR.CGColor;
        _T3SmallPoint.layer.borderWidth   = 0.5;
    }
    return _T3SmallPoint;
}

- (UIView *)T3BigPoint {
    if (_T3BigPoint == nil) {
        _T3BigPoint = [[UIView alloc]init];
        _T3BigPoint.backgroundColor     = COLOR_MAIN;
        _T3BigPoint.layer.cornerRadius  = 0.5*kBigPointW;
        _T3BigPoint.layer.masksToBounds = YES;
        _T3BigPoint.layer.borderColor   = COLOR_MAIN.CGColor;
        _T3BigPoint.layer.borderWidth   = 0.5;
    }
    return _T3BigPoint;
}

- (UILabel *)T3DescLabel {
    if (_T3DescLabel == nil) {
        _T3DescLabel = [[UILabel alloc]init];
        _T3DescLabel.text      = @"";
        _T3DescLabel.textColor = COLOR_TEXT_LIGHT;
        _T3DescLabel.font      = SYSTEMFONT(11);
        _T3DescLabel.adjustsFontSizeToFitWidth = YES;
        _T3DescLabel.textAlignment = NSTextAlignmentCenter;
        _T3DescLabel.numberOfLines = 0;
    }
    return _T3DescLabel;
}

- (UILabel *)T4Label {
    if (_T4Label == nil) {
        _T4Label = [[UILabel alloc]init];
        _T4Label.text      = @"T4";
        _T4Label.textColor = COLOR_TEXT_LIGHT;
        _T4Label.font      = [FontUtils smallFont];
        _T4Label.textAlignment = NSTextAlignmentCenter;
    }
    return _T4Label;
}

- (UIView *)T4Line {
    if (_T4Line == nil) {
        _T4Line = [[UIView alloc]init];
        _T4Line.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _T4Line;
}

- (UIView *)T4SmallPoint {
    if (_T4SmallPoint == nil) {
        _T4SmallPoint = [[UIView alloc]init];
        _T4SmallPoint.backgroundColor     = COLOR_TEXT_LIGHT;
        _T4SmallPoint.layer.cornerRadius  = 0.5*kSmallPointW;
        _T4SmallPoint.layer.masksToBounds = YES;
        _T4SmallPoint.layer.borderColor   = WHITE_COLOR.CGColor;
        _T4SmallPoint.layer.borderWidth   = 0.5;
    }
    return _T4SmallPoint;
}

- (UIView *)T4BigPoint {
    if (_T4BigPoint == nil) {
        _T4BigPoint = [[UIView alloc]init];
        _T4BigPoint.backgroundColor     = COLOR_MAIN;
        _T4BigPoint.layer.cornerRadius  = 0.5*kBigPointW;
        _T4BigPoint.layer.masksToBounds = YES;
        _T4BigPoint.layer.borderColor   = COLOR_MAIN.CGColor;
        _T4BigPoint.layer.borderWidth   = 0.5;
    }
    return _T4BigPoint;
}

- (UILabel *)T4DescLabel {
    if (_T4DescLabel == nil) {
        _T4DescLabel = [[UILabel alloc]init];
        _T4DescLabel.text      = @"";
        _T4DescLabel.textColor = COLOR_TEXT_LIGHT;
        _T4DescLabel.font      = SYSTEMFONT(11);
        _T4DescLabel.adjustsFontSizeToFitWidth = YES;
        _T4DescLabel.textAlignment = NSTextAlignmentCenter;
        _T4DescLabel.numberOfLines = 0;
    }
    return _T4DescLabel;
}

- (UILabel *)T5Label {
    if (_T5Label == nil) {
        _T5Label = [[UILabel alloc]init];
        _T5Label.text      = @"T5";
        _T5Label.textColor = COLOR_TEXT_LIGHT;
        _T5Label.font      = [FontUtils smallFont];
        _T5Label.textAlignment = NSTextAlignmentCenter;
    }
    return _T5Label;
}

- (UIView *)T5Line {
    if (_T5Line == nil) {
        _T5Line = [[UIView alloc]init];
        _T5Line.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _T5Line;
}

- (UIView *)T5SmallPoint {
    if (_T5SmallPoint == nil) {
        _T5SmallPoint = [[UIView alloc]init];
        _T5SmallPoint.backgroundColor     = COLOR_TEXT_LIGHT;
        _T5SmallPoint.layer.cornerRadius  = 0.5*kSmallPointW;
        _T5SmallPoint.layer.masksToBounds = YES;
        _T5SmallPoint.layer.borderColor   = WHITE_COLOR.CGColor;
        _T5SmallPoint.layer.borderWidth   = 0.5;
    }
    return _T5SmallPoint;
}

- (UIView *)T5BigPoint {
    if (_T5BigPoint == nil) {
        _T5BigPoint = [[UIView alloc]init];
        _T5BigPoint.backgroundColor     = COLOR_MAIN;
        _T5BigPoint.layer.cornerRadius  = 0.5*kBigPointW;
        _T5BigPoint.layer.masksToBounds = YES;
        _T5BigPoint.layer.borderColor   = COLOR_MAIN.CGColor;
        _T5BigPoint.layer.borderWidth   = 0.5;
    }
    return _T5BigPoint;
}

- (UILabel *)T5DescLabel {
    if (_T5DescLabel == nil) {
        _T5DescLabel = [[UILabel alloc]init];
        _T5DescLabel.text      = @"";
        _T5DescLabel.textColor = COLOR_TEXT_LIGHT;
        _T5DescLabel.font      = SYSTEMFONT(11);
        _T5DescLabel.adjustsFontSizeToFitWidth = YES;
        _T5DescLabel.textAlignment = NSTextAlignmentCenter;
        _T5DescLabel.numberOfLines = 0;
    }
    return _T5DescLabel;
}

- (UILabel *)T6Label {
    if (_T6Label == nil) {
        _T6Label = [[UILabel alloc]init];
        _T6Label.text      = @"T6";
        _T6Label.textColor = COLOR_TEXT_LIGHT;
        _T6Label.font      = [FontUtils smallFont];
        _T6Label.textAlignment = NSTextAlignmentCenter;
    }
    return _T6Label;
}

- (UIView *)T6Line {
    if (_T6Line == nil) {
        _T6Line = [[UIView alloc]init];
        _T6Line.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _T6Line;
}

- (UIView *)T6SmallPoint {
    if (_T6SmallPoint == nil) {
        _T6SmallPoint = [[UIView alloc]init];
        _T6SmallPoint.backgroundColor     = COLOR_TEXT_LIGHT;
        _T6SmallPoint.layer.cornerRadius  = 0.5*kSmallPointW;
        _T6SmallPoint.layer.masksToBounds = YES;
        _T6SmallPoint.layer.borderColor   = WHITE_COLOR.CGColor;
        _T6SmallPoint.layer.borderWidth   = 0.5;
    }
    return _T6SmallPoint;
}

- (UIView *)T6BigPoint {
    if (_T6BigPoint == nil) {
        _T6BigPoint = [[UIView alloc]init];
        _T6BigPoint.backgroundColor     = COLOR_MAIN;
        _T6BigPoint.layer.cornerRadius  = 0.5*kBigPointW;
        _T6BigPoint.layer.masksToBounds = YES;
        _T6BigPoint.layer.borderColor   = COLOR_MAIN.CGColor;
        _T6BigPoint.layer.borderWidth   = 0.5;
    }
    return _T6BigPoint;
}

- (UILabel *)T6DescLabel {
    if (_T6DescLabel == nil) {
        _T6DescLabel = [[UILabel alloc]init];
        _T6DescLabel.text      = @"";
        _T6DescLabel.textColor = COLOR_TEXT_LIGHT;
        _T6DescLabel.font      = SYSTEMFONT(11);
        _T6DescLabel.adjustsFontSizeToFitWidth = YES;
        _T6DescLabel.textAlignment = NSTextAlignmentLeft;
        _T6DescLabel.numberOfLines = 0;
    }
    return _T6DescLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor = COLOR_TEXT_LIGHT;
    }
    return _separateLine;
}

- (NSMutableArray *)titelLabelArray {
    if (_titelLabelArray == nil) {
        _titelLabelArray = [NSMutableArray array];
    }
    return _titelLabelArray;
}

- (NSMutableArray *)smallPointArray {
    if (_smallPointArray == nil) {
        _smallPointArray = [NSMutableArray array];
    }
    return _smallPointArray;
}

- (NSMutableArray *)bigPointArray {
    if (_bigPointArray == nil) {
        _bigPointArray = [NSMutableArray array];
    }
    return _bigPointArray;
}

- (NSMutableArray *)descLabelArray {
    if (_descLabelArray == nil) {
        _descLabelArray = [NSMutableArray array];
    }
    return _descLabelArray;
}

- (NSMutableArray *)levelArray {
    if (_levelArray == nil) {
        _levelArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @""]];
    }
    return _levelArray;
}

@end
