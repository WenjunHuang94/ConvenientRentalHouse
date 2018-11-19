//
//  ShoppingTopView.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/17.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ShoppingTopView.h"

@implementation ShoppingTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:163 / 255.0 blue:34 / 255.0 alpha:1]];
        
        //积分标签
        CGFloat width = 60;
        self.scoreLabel = [[UILabel alloc]initWithFrame:(CGRect){(self.frame.size.width - width - width) / 2,30,width,30}];
       
        [self.scoreLabel setText:@"积分:"];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.scoreLabel];
        
        //积分
        self.score = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(self.scoreLabel.frame),30,width,30}];
        self.score.textColor = [UIColor redColor];
        self.score.text = @"未登录";
        self.score.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.score];
        
        //签到按钮
        CGFloat btnWidth = 150;
        self.registerBtn = [[UIButton alloc]initWithFrame:(CGRect){(self.frame.size.width - btnWidth) / 2,CGRectGetMaxY(self.scoreLabel.frame) + 10,btnWidth,40}];
        
        [self.registerBtn setBackgroundColor:MainColor];
        
        [self.registerBtn setTitle:@"今日未签到" forState:UIControlStateNormal];
        [self addSubview:self.registerBtn];
        
        //签到按钮，添加点击事件
        [self.registerBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
        
    }
    
    return self;
}

-(void)click{
    self.registerBlock();
}

@end
