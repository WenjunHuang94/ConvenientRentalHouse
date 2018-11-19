//
//  HomeClientCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/21.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeClientCell.h"

@implementation HomeClientCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    
    return self;
}


-(void)setUp{
    
    //租户人群标签
    _targetcusLabel = [UILabel new];
    [_targetcusLabel setTextColor:MainColor];
    
    [_targetcusLabel setText:@"租户要求"];
    [self addSubview:_targetcusLabel];
    
    //给下面文字自动设置大小,就只约束上左右即可,不要约束高
    [_targetcusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    }];
    
    //租户人群内容
    _targetcus = [UILabel new];
    
    _targetcus.font = [UIFont boldSystemFontOfSize:14];  //UILabel的字体大小
    _targetcus.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    _targetcus.textAlignment = NSTextAlignmentLeft;  //文本向左对齐
    _targetcus.textColor = [UIColor redColor];
    
    [self addSubview:_targetcus];
    
    [_targetcus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.targetcusLabel.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    }];

}

-(void)setObject:(AVObject *)object{
    _targetcus.text =[object objectForKey:@"require"];
    
    [self layoutIfNeeded];//如果需要强制布局
    self.cellHeight = CGRectGetMaxY(_targetcus.frame) + 5;//计算cell的高度
}

@end
