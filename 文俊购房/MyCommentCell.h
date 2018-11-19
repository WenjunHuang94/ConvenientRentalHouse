//
//  MyCommentCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/24.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) CGFloat cellHeight;//cell高度

-(void)setObject:(AVObject *)object;


@end
