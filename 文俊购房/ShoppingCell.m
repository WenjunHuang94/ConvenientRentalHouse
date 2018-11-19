//
//  ShoppingCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/25.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ShoppingCell.h"

@implementation ShoppingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //imgView
        _imgView = [[UIImageView alloc]initWithFrame:(CGRect){10,10,110,110}];
        [self addSubview:_imgView];
        
        //商品名称
        _shopingName = [[UILabel alloc]initWithFrame:(CGRect){150,10,100,30}];
        _shopingName.textColor = [UIColor blueColor];
        _shopingName.textAlignment = UITextAlignmentCenter;
        [self addSubview:_shopingName];
        
        //商名积分
        _shopingScore = [[UILabel alloc]initWithFrame:(CGRect){150,50,150,30}];
        [self addSubview:_shopingScore];
        
        //兑换
        _buyBtn = [[UIButton alloc]initWithFrame:(CGRect){150,90,100,30}];
        [_buyBtn setBackgroundColor:MainColor];
        [_buyBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_buyBtn];
        
        //剪为圆角
        _buyBtn.layer.cornerRadius = 10;
        _buyBtn.layer.masksToBounds = YES;
    }
    
    return self;
}

//点击兑换按钮时
-(void)click{
    self.buy();
}


@end
