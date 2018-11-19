//
//  HomeAreaCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/2/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeAreaCell.h"

@implementation HomeAreaCell{
    UILabel *area;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //地址图片
        _areaImg = [[UIImageView alloc]initWithFrame:(CGRect){10,10,20,20}];
        [_areaImg setImage:[UIImage imageNamed:@"地址"]];
        [self addSubview:_areaImg];
        
        //地址标签
        area = [[UILabel alloc]initWithFrame:(CGRect){30,10,40,20}];
        [area setText:@"地址:"];
        [self addSubview:area];
        
        //租房位置名
        self.areaName = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(area.frame),10,self.frame.size.width - 90,20}];
        self.areaName.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.areaName];
        
    }
    return self;
}

-(void)setObject:(AVObject *)object{
    //房屋详情地址
    _areaName.text = [object objectForKey:@"areaDetail"];
 
}

@end
