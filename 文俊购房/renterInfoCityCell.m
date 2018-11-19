//
//  renterInfoCityCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "renterInfoCityCell.h"

@implementation renterInfoCityCell{
    UILabel *postionLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        postionLabel = [[UILabel alloc]initWithFrame:(CGRect){5,10,90,20}];
        postionLabel.text = @"当前城市:";
        postionLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:postionLabel];
        
        _currentCityLabel = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(postionLabel.frame) + 5,10,200,20}];
        _currentCityLabel.textColor = [UIColor orangeColor];
        _currentCityLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_currentCityLabel];
        
        
    }
    return self;
}


@end
