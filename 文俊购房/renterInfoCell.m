//
//  renterInfoCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "renterInfoCell.h"

@implementation renterInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

//设置控件
-(void)setup {
    
    //用户头像
    self.MyImage = [UIImageView new];
    [self.contentView addSubview:self.MyImage];

    [self.MyImage setImage:[UIImage imageNamed:@"默认头像"]];
    
    self.MyImage.layer.cornerRadius = 10;
    [self.MyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    //房名
    _name= [UILabel new];
    _name.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_name];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(5);
        make.left.mas_equalTo(self.MyImage.mas_right).with.offset(10);
        make.height.mas_equalTo(30);
    }];

    //城市名
    _cityName = [UILabel new];
    _cityName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_cityName];
    
    [_cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.MyImage.mas_right).with.offset(10);
        make.height.mas_equalTo(30);
    }];

    //区域名
    _districtName= [UILabel new];
    _districtName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_districtName];
    
    [_districtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cityName.mas_top);
        make.left.mas_equalTo(self.cityName.mas_right).with.offset(20);
        make.height.mas_equalTo(self.cityName);
    }];

    
    //月租
    _priceRemark= [UILabel new];
    _priceRemark.font = [UIFont systemFontOfSize:18];
    _priceRemark.textColor = RGB(244, 95, 0);
    [self.contentView addSubview:_priceRemark];
    
    [_priceRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cityName.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.cityName);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    //时间
    self.timeLabel = [UILabel new];
    [self addSubview:self.timeLabel];
    
    [self.timeLabel setFont:[UIFont systemFontOfSize:13]];
    [self.timeLabel setTextColor:[UIColor grayColor]];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceRemark.mas_bottom).with.offset(0);
        make.right.mas_equalTo(self).with.offset(-10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(20);
    }];

}

////给控件赋值
-(void)setObject:(AVObject *)object{

    AVFile *file = [object objectForKey:@"image"];//获取用户头像
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        UIImage *img = [UIImage imageWithData:data];
        self.MyImage.image = img;
    }];
    
    _cityName.text = [object objectForKey:@"city"];//城市
    _districtName.text = [NSString stringWithFormat:@"%@区",[object objectForKey:@"district"]];//区域
    _name.text = [object objectForKey:@"homeName"];//房名
    _priceRemark.text = [NSString stringWithFormat:@"%@元/月",[object objectForKey:@"rentMoney"]];//租金
    
    
    //将日期转化为NSString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLabel.text = [dateFormatter stringFromDate:[object objectForKey:@"updatedAt"]];
}

@end
