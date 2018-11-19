//
//  HomeDetailCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#pragma 第二种模式的cell

#import <UIKit/UIKit.h>

@interface SecondCell : UITableViewCell

@property (strong, nonatomic) UILabel *contntLabel;//城市标签

@property (strong, nonatomic) UILabel *roomLabel;//房
@property (strong, nonatomic) UITextField *roomField;

@property (strong, nonatomic) UILabel *hallLabel;//厅
@property (strong, nonatomic) UITextField *hallField;

@property (strong, nonatomic) UILabel *toiletLabel;//卫
@property (strong, nonatomic) UITextField *toiletField;

@end
