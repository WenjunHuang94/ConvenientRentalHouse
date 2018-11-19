//
//  HomeTableViewCell.m
//  文俊购房
//
//  Created by 俊帅 on 16/7/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    self.city = [[UILabel alloc]initWithFrame:(CGRect){20,10,100,30}];
    [self addSubview:self.city];
    
    self.districtName = [[UILabel alloc]initWithFrame:(CGRect){120,10,170,30}];
    [self addSubview:self.districtName];
    
    self.bname = [UILabel new];
    [self addSubview:self.bname];
    [self.bname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
        make.height.mas_equalTo(30);
    }];
}

-(void)setObject:(AVObject *)object{
    //城市
    _city.text = [object objectForKey:@"city"];
    //区域
    _districtName.text = [NSString stringWithFormat:@"%@区",[object objectForKey:@"district"]];
    //房名
    _bname.text = [object objectForKey:@"homeName"];
}

@end
