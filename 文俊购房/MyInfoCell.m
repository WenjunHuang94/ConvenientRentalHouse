//
//  MyInfoCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/6/1.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    //时间标签
    _contentLabel = [UILabel new];
    [self addSubview:_contentLabel];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.text = @"用户名";
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(15);
        make.top.mas_equalTo(self).with.offset(10);
        make.height.mas_equalTo(30);
    }];
    
    //标题
    _content = [UILabel new];
    _content.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_content];
    _content.textColor = [UIColor redColor];
    [_content setFont:[UIFont systemFontOfSize:15]];
    _content.text = @"111";
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-30);
        make.top.mas_equalTo(_contentLabel.mas_top);
        make.height.mas_equalTo(_contentLabel.mas_height);
    }];
    
}

-(void)setObject:(AVObject *)object{
   
}

@end
