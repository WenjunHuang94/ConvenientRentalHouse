//
//  HomeTableViewCell.h
//  文俊购房
//
//  Created by 俊帅 on 16/7/17.
//  Copyright © 2016年 wj. All rights reserved.

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *city;//城市名
@property (nonatomic,strong)UILabel *districtName;//地区名，如天雨区
@property (nonatomic,strong)UILabel *bname;//小区名，如南城印象

-(void)setObject:(AVObject *)object;

@end
