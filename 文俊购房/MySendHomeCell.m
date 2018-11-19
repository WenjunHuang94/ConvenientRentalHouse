//
//  MySendHomeCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/13.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MySendHomeCell.h"

@implementation MySendHomeCell

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
        
        //类型
        _verifyBtn = [[UIButton alloc]initWithFrame:(CGRect){k_w - 100,40,90,30}];
        [_verifyBtn setBackgroundColor:[UIColor orangeColor]];
        [self.contentView addSubview:_verifyBtn];
        
        //租金
        _priceRemark= [[UILabel alloc]initWithFrame:(CGRect){nameX,CGRectGetMaxY(_cityName.frame),150,20}];
        _priceRemark.font = [UIFont systemFontOfSize:15];
        [_priceRemark setTextColor:[UIColor redColor]];
        [self.contentView addSubview:_priceRemark];
        
    }
    return self;
}

-(void)setObject:(AVObject *)home{
    //房屋首图片
    //客户端 SDK 接口可以下载文件并把它缓存起来，只要文件的 URL 不变，那么一次下载成功之后，就不会再重复下载，目的是为了减少客户端的流量
    AVFile *file = [home objectForKey:@"mainImg"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        _homeImage.image = [UIImage imageWithData:data];
    }];
    
    _name.text = [home objectForKey:@"homeName"];//房名：南城印象
    _buildType.text = [home objectForKey:@"homeUseType"];//类型：住宅
    _cityName.text = [home objectForKey:@"city"];//城市:长沙
    _districtName.text = [home objectForKey:@"district"];//区域:雨花
    
    _priceRemark.text = [NSString stringWithFormat:@"%@元/月",[home objectForKey:@"rentMoney"]];//租金
    
    if ([[home objectForKey:@"homeVerify"] integerValue] == 1) {//返回的是指针,需要取出值
        [_verifyBtn setTitle:@"已通过" forState:UIControlStateNormal];
    }else{
        [_verifyBtn setTitle:@"未通过" forState:UIControlStateNormal];
    }

}

@end
