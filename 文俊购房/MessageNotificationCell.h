//
//  MessageNotificationCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNotificationCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

-(void)setObject:(AVObject *)object;

@end
