//
//  NormalTableViewCell.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "NormalTableViewCell.h"

@implementation NormalTableViewCell

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 120, 90);
    CGContextAddLineToPoint(context, 350, 90);
    
    CGContextStrokePath(context);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //图片
        self.homeImage = [[UIImageView alloc]initWithFrame:(CGRect){10,10,100,70}];
        [self.contentView addSubview:self.homeImage];
        
        //房名
        CGFloat nameX = CGRectGetMaxX(_homeImage.frame) + 10;
        _name = [[UILabel alloc]initWithFrame:(CGRect){nameX,10,150,20}];
        _name.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_name];
        
        //类型
        _buildType = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_name.frame) + 10,10,80,20}];
        _buildType.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_buildType];
        
        //城市名
        _cityName = [[UILabel alloc]initWithFrame:(CGRect){nameX,40,50,20}];
        _cityName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_cityName];
        
        
        //区域名
        _districtName= [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_cityName.frame),40,150,20}];
        _districtName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_districtName];
        
        //租金
        _priceRemark= [[UILabel alloc]initWithFrame:(CGRect){nameX,CGRectGetMaxY(_cityName.frame),150,20}];
        _priceRemark.font = [UIFont systemFontOfSize:15];
        [_priceRemark setTextColor:[UIColor redColor]];
        [self.contentView addSubview:_priceRemark];
        
    }
    return self;
}

-(void)setObject:(AVObject *)object{
    self.home = object;
    
    //房屋首图片
    AVFile *file = [object objectForKey:@"mainImg"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        _homeImage.image = [UIImage imageWithData:data];
    }];
    
    _name.text = [object objectForKey:@"homeName"];//房名：南城印象
    _buildType.text = [object objectForKey:@"homeUseType"];//类型：住宅
    _cityName.text = [object objectForKey:@"city"];//城市:长沙
    _districtName.text = [object objectForKey:@"district"];//区域:雨花
    
    _priceRemark.text = [NSString stringWithFormat:@"%@元/月",[object objectForKey:@"rentMoney"]];//租金
}


@end
