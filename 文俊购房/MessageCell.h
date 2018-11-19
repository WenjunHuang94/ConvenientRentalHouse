//
//  MessageCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell

@property (nonatomic,strong)MessageModel *model;//model

@property (nonatomic, strong) UIImageView *imgView;//图片
@property (nonatomic, strong) UILabel *titleLabel;//头标题
@property (nonatomic, strong) UILabel *subtitleLabel;//描述

@end
