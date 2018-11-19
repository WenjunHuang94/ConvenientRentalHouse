//
//  CollectionCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame]) {
        //注意cell里面的控件 使用的位置 是相对于cell 的位置的 所以使用bounds
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        
        _cityLabel = [UILabel new];
        [self addSubview:_cityLabel];
        [_cityLabel setBackgroundColor:MainColor];
        
        [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(5);
            make.left.mas_equalTo(self.mas_left).with.offset(5);
            make.height.mas_equalTo(30);
        }];
        
    }
       return self;
}

//设置图片
-(void)setObject:(AVObject *)object
{
    AVFile *file = [object objectForKey:@"image"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (!error) {
            _imageView.image = [UIImage imageWithData:data];//NSData转化为图片
        }
    }];
    
    _cityLabel = [object objectForKey:@"city"];

}


@end
