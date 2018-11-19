//
//  HomeCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "Cell.h"

@implementation Cell

//画图一定要在UIVW类中画，才会有下面这个方法来画
-(void)drawRect:(CGRect)rect{
    [self drawLine];
}

//画分割线
-(void)drawLine{
    [[UIColor blackColor]set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 90, 10);
    CGContextAddLineToPoint(context, 90, 40);
    
    CGContextStrokePath(context);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

//设置控件
- (void)setup {
    
    //内容标签
    _contntLabel = [UILabel new];
    [self addSubview:_contntLabel];
    _contntLabel.font = [UIFont systemFontOfSize:15];
    
    [_contntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(10);
        make.top.mas_equalTo(self).with.offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    //提示标签
    _tipField = [UITextField new];
    [self addSubview:_tipField];
    
    [_tipField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contntLabel.mas_right).offset(10);
        make.top.mas_equalTo(_contntLabel);
        make.right.mas_equalTo(self).offset(-40);
        make.height.mas_equalTo(_contntLabel);
    }];

}

@end
