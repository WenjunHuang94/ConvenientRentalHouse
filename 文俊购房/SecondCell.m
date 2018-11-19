//
//  HomeDetailCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "SecondCell.h"

@implementation SecondCell

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
    
    
    
    //房
    _roomField = [UITextField new];
    [self addSubview:_roomField];
    _roomField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_roomField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contntLabel.mas_right).offset(10);
        make.top.mas_equalTo(_contntLabel);
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(_contntLabel);
    }];
    
    _roomLabel = [UILabel new];
    [self addSubview:_roomLabel];
    _roomLabel.font = [UIFont systemFontOfSize:15];
    
    [_roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_roomField.mas_right).with.offset(0);
        make.top.mas_equalTo(_roomField);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(30);
    }];
    
    //厅
    _hallField = [UITextField new];
    [self addSubview:_hallField];
    _hallField.keyboardType = UIKeyboardTypeNumberPad;

    [_hallField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_roomLabel.mas_right).offset(0);
        make.top.mas_equalTo(_contntLabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(_contntLabel);
    }];
    
    _hallLabel = [UILabel new];
    [self addSubview:_hallLabel];
    _hallLabel.font = [UIFont systemFontOfSize:15];
    
    [_hallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hallField.mas_right).with.offset(0);
        make.top.mas_equalTo(_roomField);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(30);
    }];
    
    //卫
    _toiletField = [UITextField new];
    [self addSubview:_toiletField];
    _toiletField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_toiletField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hallLabel.mas_right).offset(0);
        make.top.mas_equalTo(_contntLabel);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(_contntLabel);
    }];
    
    _toiletLabel = [UILabel new];
    [self addSubview:_toiletLabel];
    _toiletLabel.font = [UIFont systemFontOfSize:15];
    
    [_toiletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(0);
        make.top.mas_equalTo(_roomField);
        
        make.height.mas_equalTo(30);
    }];
    
}

@end
