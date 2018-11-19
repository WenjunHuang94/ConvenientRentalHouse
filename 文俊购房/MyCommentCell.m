//
//  MyCommentCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/24.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MyCommentCell.h"

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

- (void)setup {
    
    //时间标签
    _timeLabel = [UILabel new];
    [self addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self).with.offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
    
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    _titleLabel.text = @"我的评价";
    _titleLabel.textColor = [UIColor redColor];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(30);
    }];
    
    
    //内容
    _contentLabel = [UILabel new];
    [self addSubview:_contentLabel];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(10);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.right.mas_equalTo(self).with.offset(-10);
    }];
}




-(void)setObject:(AVObject *)object{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLabel.text = [dateFormatter stringFromDate:[object objectForKey:@"updatedAt"]];//日期
    
    _contentLabel.text = [object objectForKey:@"content"];//评论内容
    
    [self layoutIfNeeded];//如果需要强制布局,必须放在计算高度前
    self.cellHeight = CGRectGetMaxY(_contentLabel.frame) + 5;//计算cell的高度
    
}


@end
