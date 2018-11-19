//
//  HomeDetailCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "NormalCell.h"

@implementation NormalCell

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
    
    //时间标签
    _areaLabel = [UILabel new];
    [self addSubview:_areaLabel];
    _areaLabel.text = @"城市";
    _areaLabel.font = [UIFont systemFontOfSize:15];
    
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(10);
        make.top.mas_equalTo(self).with.offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    _tipLabel = [UITextField new];
    [self addSubview:_tipLabel];
    _tipLabel.enabled = NO;//禁止输入
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_areaLabel.mas_right).offset(10);
        make.top.mas_equalTo(_areaLabel);
        make.right.mas_equalTo(self).offset(-40);
        make.height.mas_equalTo(_areaLabel);
    }];
    
    _tipLabel.placeholder = @"选择所在城市";
    
}

@end
