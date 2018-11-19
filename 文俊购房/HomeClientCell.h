//
//  HomeClientCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/21.
//  Copyright © 2017年 wj. All rights reserved.
//

#pragma 房屋详情界面，租户主要人群介绍

#import "Sington.h"

#import <UIKit/UIKit.h>

@interface HomeClientCell : UITableViewCell

@property (nonatomic,strong)UILabel *targetcusLabel;//租户要求
@property (nonatomic,strong)UILabel *targetcus;//租户要求内容

@property (nonatomic,assign)CGFloat cellHeight;//记录高度

-(void)setObject:(AVObject *)object;

@end
