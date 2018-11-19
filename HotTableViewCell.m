//
//  HotTableViewCell.m
//  文俊购房
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat startX = 20;
        CGFloat startY = 10;
        CGFloat space = 30;
        
        CGFloat width = 60;
        CGFloat height = 30;
        
        for (int i = 0; i < [Sington sharSington].hotCityArr.count; i++) {
            
            CGFloat row = i / 3;
            CGFloat col = i % 3;
            CGFloat x = startX + col * (space + width);
            CGFloat y = startY + row * (space + height);
            UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){x,y,width,height}];
            
            AVObject *object = [[Sington sharSington].hotCityArr objectAtIndex:i];//取出object
      
            btn.tag = [[object objectForKey:@"cityId"] integerValue];//设置tag
            [btn setTitle:[object objectForKey:@"cityName"] forState:UIControlStateNormal];

            [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor orangeColor];
            [self.contentView addSubview:btn];
            
        }
    }
    
    return self;
}

//点击事件
-(void)btnclick:(UIButton *)sender{
    
    [Sington sharSington].cityId = sender.tag;//给赋选取热门城市ID值
    NSLog(@"%d",sender.tag);     
    self.myblock(sender);
    
}

@end
