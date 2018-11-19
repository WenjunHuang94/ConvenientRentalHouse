//
//  HomeShowCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/2/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeShowCell.h"

@implementation HomeShowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //租金标签
        _rentMoenyLabel = [[UILabel alloc]initWithFrame:(CGRect){10,10,40,20}];
        [_rentMoenyLabel setText:@"租金:"];
        [self addSubview:_rentMoenyLabel];
        
        //租金数值
        _rentMoneny = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_rentMoenyLabel.frame),10,160,20}];
        [_rentMoneny setTextColor:[UIColor redColor]];
        _rentMoneny.font = [UIFont systemFontOfSize:20];
        [self addSubview:_rentMoneny];
        
        //房型标签
        _roomLabel = [[UILabel alloc]initWithFrame:(CGRect){10,CGRectGetMaxY(_rentMoenyLabel.frame) + 5,40,20}];
        [_roomLabel setText:@"房型:"];
        [self addSubview:_roomLabel];
        
        //房型数值
        _room = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_roomLabel.frame),CGRectGetMinY(_roomLabel.frame),160,20}];
        [self addSubview:_room];
        
        
        //面积标签
        _areaLabl = [[UILabel alloc]initWithFrame:(CGRect){10,CGRectGetMaxY(_roomLabel.frame) + 5,40,20}];
        [_areaLabl setText:@"面积:"];
        [self addSubview:_areaLabl];
        
        //面积数值
        _area = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_areaLabl.frame),CGRectGetMinY(_areaLabl.frame),160,20}];
        [_area setText:@"110平米"];
        [self addSubview:_area];
        
        //楼层标签
        _floorLabel = [[UILabel alloc]initWithFrame:(CGRect){k_w - 130,CGRectGetMinY(_rentMoenyLabel.frame),40,20}];
        [_floorLabel setText:@"楼层:"];
        [self addSubview:_floorLabel];
        
        //楼层数值
        _floor = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_floorLabel.frame),CGRectGetMinY(_floorLabel.frame),110,20}];
        [self addSubview:_floor];
        
        //装修标签
        _decorationLabel = [[UILabel alloc]initWithFrame:(CGRect){k_w - 130,CGRectGetMinY(_roomLabel.frame),40,20}];
        [_decorationLabel setText:@"装修:"];
        [self addSubview:_decorationLabel];
        
        //装修
        _decoration = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_decorationLabel.frame),CGRectGetMinY(_decorationLabel.frame),110,20}];
        [self addSubview:_decoration];
        
        //类型标签
        _propertyTypeLabel = [[UILabel alloc]initWithFrame:(CGRect){k_w - 130,CGRectGetMinY(_areaLabl.frame),40,20}];
        [_propertyTypeLabel setText:@"类型:"];
        [self addSubview:_propertyTypeLabel];
        
        //类型
        _propertyType = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(_propertyTypeLabel.frame),CGRectGetMinY(_propertyTypeLabel.frame),110,20}];
        [self addSubview:_propertyType];
        
    }
    return self;
}

-(void)setObject:(AVObject *)object{
    //租金
    _rentMoneny.text = [NSString stringWithFormat:@"%@元/月",[object objectForKey:@"rentMoney"]];
    //房型
    _room.text = [object objectForKey:@"homeType"];
    //面积
    _area.text = [NSString stringWithFormat:@"%@平米",[object objectForKey:@"area"]];
    
    //楼
    _floor.text = [NSString stringWithFormat:@"%@楼",[object objectForKey:@"floor"]];
    //装修
    _decoration.text = [object objectForKey:@"homeEquipment"];
    //类型
    _propertyType.text = [object objectForKey:@"homeUseType"];
}

@end
