//
//  FormTextField.m
//
//  Created by Jarry on 14-1-23.
//  Copyright (c) 2014年 Zenin-tech. All rights reserved.
//

#import "FormTextField.h"

@implementation FormTextField

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBorderStyle:UITextBorderStyleNone];
        
        [self setFont:[UIFont systemFontOfSize:14]];
        if (isIOS7) {
            [self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        }
        [self setBackgroundColor:[UIColor whiteColor]];

        //
        UILabel *titleLabel  = [[UILabel alloc] init];
        titleLabel.font = BOLDSYSTEMFONT(14);
        titleLabel.backgroundColor = CLEAR_COLOR;
        titleLabel.textColor = GRAY_COLOR;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumFontSize = 8;
        
        self.borderColor = COLOR_SEPERATOR_LINE;
        self.edgeOffset = UIOffsetMake(15, 10);
    }
    return self;
}

- (void) setFieldTitle:(NSString *)fieldTitle
{
    _fieldTitle = [fieldTitle copy];
    self.titleLabel.text = _fieldTitle;
}

/*// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect
{
    // Drawing code
    [DARKGRAY_COLOR set];
    CGSize newSize = [self.fieldTitle sizeWithFont:self.font constrainedToSize:self.bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect titleRect = CGRectMake(6, (self.bounds.size.height-newSize.height)/2, 200, newSize.height);
    [self.fieldTitle drawInRect:titleRect withFont:self.font];
}*/

- (CGRect) textRectForBounds:(CGRect)bounds
{
    if (self.fieldTitle.length == 0) {
        return CGRectMake(self.edgeOffset.horizontal, self.edgeOffset.vertical, bounds.size.width-self.edgeOffset.horizontal*2, bounds.size.height-self.edgeOffset.vertical*2);
    }
    //
//    CGSize newSize = [self.fieldTitle sizeWithFont:self.titleLabel.font constrainedToSize:self.bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font, NSFontAttributeName,nil];
    CGSize newSize =[self.fieldTitle boundingRectWithSize:CGSizeMake(200, 300)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:tdic
                                                  context:nil].size;
    CGFloat xOffset = newSize.width + 12;
    return CGRectMake(xOffset, 10, bounds.size.width-xOffset-8, bounds.size.height-20);
}

- (CGRect) editingRectForBounds:(CGRect)bounds
{
    if (self.fieldTitle.length == 0) {
        return CGRectMake(self.edgeOffset.horizontal, self.edgeOffset.vertical, bounds.size.width-self.edgeOffset.horizontal*2, bounds.size.height-self.edgeOffset.vertical*2);
    }
    //
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font, NSFontAttributeName,nil];
    CGSize newSize =[self.fieldTitle boundingRectWithSize:CGSizeMake(200, 300)
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:tdic
                                                     context:nil].size;
//    CGSize newSize = [self.fieldTitle sizeWithFont:self.titleLabel.font constrainedToSize:self.bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat xOffset = newSize.width + 12;
    return CGRectMake(xOffset, 10, bounds.size.width-xOffset-8, bounds.size.height-20);
}

- (void) layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    [layer setBorderWidth: 0.8];
    
    if (self.required && self.text.length == 0) {
        [layer setBorderColor: [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor];
    }
    else {
        [layer setBorderColor: self.borderColor.CGColor];
    }
    
    [layer setCornerRadius:5.0];
//    [layer setShadowOpacity:0.5];
//    [layer setShadowColor:[UIColor grayColor].CGColor];
//    [layer setShadowOffset:CGSizeMake(0.1, 0.1)];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10, 0, 100, self.height);
}

//- (void) drawPlaceholderInRect:(CGRect)rect
//{
//    if (isIOS7) {
//        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//        [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
//    }
//}


@end
