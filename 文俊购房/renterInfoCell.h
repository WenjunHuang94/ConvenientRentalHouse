//
//  renterInfoCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface renterInfoCell : UITableViewCell

@property (nonatomic,strong)UIImageView *MyImage;//客户头像

@property (nonatomic,strong)UILabel *cityName;
@property (nonatomic,strong)UILabel *districtName;
@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *priceRemark;//月租
@property (nonatomic,strong)UIButton *homeBtn;//房型
@property (nonatomic,strong)UIImageView *icon;//图标

@property (nonatomic,strong)UILabel *contentLabel;//需求描述

@property (nonatomic,strong)UILabel *timeLabel;

-(void)setObject:(AVObject *)object;//设置模型

@end
