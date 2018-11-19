//
//  ThirdCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/17.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ThirdCell.h"

@implementation ThirdCell

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
    
    //输入框
    _contentField = [UITextField new];
    [self addSubview:_contentField];
    _contentField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contntLabel.mas_right).offset(10);
        make.top.mas_equalTo(_contntLabel);
        make.height.mas_equalTo(_contntLabel);
    }];
    
    //单位标识
    _identifyLabel = [UILabel new];
    [self addSubview:_identifyLabel];
    _identifyLabel.font = [UIFont systemFontOfSize:15];
    
    [_identifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //只是这句这样输入内容后,若不添加右约束，identifyLabel会一直往后移动
        make.left.mas_equalTo(self.contentField.mas_right).with.offset(0);
        
        
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(_contntLabel.mas_top);
        make.height.mas_equalTo(_contntLabel.mas_height);
    }];

}

@end
