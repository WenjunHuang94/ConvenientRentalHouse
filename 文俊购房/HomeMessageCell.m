//
//  HomeMessageCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/31.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeMessageCell.h"

@implementation HomeMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    //头像
    self.imgBtn = [UIButton new];
    [self addSubview:self.imgBtn];
    [self.imgBtn.layer setCornerRadius:25];
    [self.imgBtn setBackgroundImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    //用户名
    self.name = [UILabel new];
    [self addSubview:self.name];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgBtn.mas_right).with.offset(5);
        make.top.mas_equalTo(self.imgBtn.mas_top);
        make.height.mas_equalTo(25);
    }];
    
    //手机号
    self.phone = [UILabel new];
    [self addSubview:self.phone];
    [self.phone setFont:[UIFont systemFontOfSize:13]];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_left);
        make.top.mas_equalTo(self.name.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    
    //时间
    self.date = [UILabel new];
    [self addSubview:self.date];
    [self.date setFont:[UIFont systemFontOfSize:13]];
    
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.top.mas_equalTo(self.imgBtn.mas_top);
        make.height.mas_equalTo(25);
    }];
    
    //留言
    self.content = [UILabel new];
    [self addSubview:self.content];
    self.content.numberOfLines = 0;
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_left);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.top.mas_equalTo(self.phone.mas_bottom).with.offset(5);
    }];
}

-(void)setDic:(NSDictionary *)dic{
    
    self.name.text = [dic objectForKey:@"name"];
    self.phone.text = [dic objectForKey:@"mobilePhoneNumber"];
    self.date.text = [dic objectForKey:@"date"];
    self.content.text = [dic objectForKey:@"content"];
    
    [self layoutIfNeeded];//如果需要强制布局
    self.cellHeight = CGRectGetMaxY(_content.frame) + 5;//计算cell的高度
}

@end
