//
//  MessageNotificationCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MessageNotificationCell.h"

@implementation MessageNotificationCell

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
    _titleLabel.textColor = [UIColor redColor];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(30);
    }];
    
    //图片
    _imgView = [UIImageView new];
    [self addSubview:_imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(10);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.right.mas_equalTo(self).with.offset(-10);
        make.height.mas_equalTo(140);
    }];
    
    //内容
    _contentLabel = [UILabel new];
    [self addSubview:_contentLabel];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(10);
        make.top.mas_equalTo(_imgView.mas_bottom);
        make.right.mas_equalTo(self).with.offset(-10);
        make.bottom.mas_equalTo(self);
    }];
}

-(void)setObject:(AVObject *)object{
    NSLog(@"image = %@",[object objectForKey:@"image"]);
    
    //将日期转化为NSString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLabel.text = [dateFormatter stringFromDate:[object objectForKey:@"updatedAt"]];
    
    _titleLabel.text = [object objectForKey:@"title"];//标题
    
    //通告图片
    AVFile *file = [object objectForKey:@"image"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        UIImage *img = [UIImage imageWithData:data];//NSData转化为图片
        _imgView.image = img;
    }];
    
    //通知内容
    _contentLabel.text = [object objectForKey:@"content"];
}


@end
