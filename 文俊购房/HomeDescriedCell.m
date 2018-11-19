//
//  HomeDescriedCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/2/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeDescriedCell.h"

@implementation HomeDescriedCell{
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    
    return self;
}


-(void)setUp{
    
    //租户人群标签
    _descriedLabel = [UILabel new];
    [_descriedLabel setTextColor:MainColor];
    _descriedLabel.numberOfLines = 0;
    
    [_descriedLabel setText:@"房源描述"];
    [self addSubview:_descriedLabel];
    
    //给下面文字自动设置大小,就只约束上左右即可,不要约束高
    [_descriedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    }];
    
    //租户人群内容
    _remark = [UILabel new];
    
    _remark.font = [UIFont boldSystemFontOfSize:14];  //UILabel的字体大小
    _remark.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    _remark.textAlignment = NSTextAlignmentLeft;  //文本向左对齐
    _remark.textColor = [UIColor redColor];
    
    [self addSubview:_remark];
    
    [_remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descriedLabel.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    }];
    
}

-(void)setObject:(AVObject *)object{
    _remark.text =[object objectForKey:@"description"];//房源描述
    
    [self layoutIfNeeded];//如果需要强制布局
    self.cellHeight = CGRectGetMaxY(_remark.frame) + 5;//计算cell的高度
}

@end