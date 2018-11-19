//
//  HomeAreaCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/2/10.
//  Copyright © 2017年 wj. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface HomeAreaCell : UITableViewCell

@property(nonatomic,strong)UIImageView *areaImg;//楼层
@property (nonatomic,strong)UILabel *areaName; //房屋具地位置

-(void)setObject:(AVObject *)object;

@end
