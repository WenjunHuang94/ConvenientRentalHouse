//
//  MessageCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

//设置控件
-(void)setup {
    
    //图片
    _imgView = [UIImageView new];
    [self addSubview:_imgView];
    //[_imgView setBackgroundColor:[UIColor yellowColor]];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(10);
        make.left.mas_equalTo(self).with.offset(10);
        make.bottom.mas_equalTo(self).with.offset(-10);
        make.width.mas_equalTo(50);
    }];
    
    //头标题
    _titleLabel = [UILabel new];
    [self addSubview:_titleLabel];
    //[_titleLabel setBackgroundColor:[UIColor yellowColor]];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgView.mas_top);
        make.left.mas_equalTo(_imgView.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    //子标题
    _subtitleLabel = [UILabel new];
    [self addSubview:_subtitleLabel];
    _subtitleLabel.font = [UIFont systemFontOfSize:12];
    //[_subtitleLabel setBackgroundColor:[UIColor yellowColor]];
    
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.height.mas_equalTo(_titleLabel.mas_height);
        make.right.mas_equalTo(self);
    }];

}

//给控件赋值
-(void)setModel:(MessageModel *)model{

    self.imgView.image = model.img;
    self.titleLabel.text = model.title;
    _subtitleLabel.text = model.subTitle;

}


@end
