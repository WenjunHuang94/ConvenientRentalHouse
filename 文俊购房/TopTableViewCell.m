//
//  TopTableViewCell.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "TopTableViewCell.h"

@implementation TopTableViewCell{
    UIImageView *imageview;
    UIButton *rentBtn;
    UIButton *averageBtn;
    UILabel *retnLabel;
    UILabel *averageLabel;
    UIButton *enterBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageview = [[UIImageView alloc]initWithFrame:(CGRect){10,10,self.frame.size.width + 35,120}];
        imageview.image = [UIImage imageNamed:@"金世纪花园"];
        
        [self.contentView addSubview:imageview];
        
        rentBtn = [[UIButton alloc]initWithFrame:(CGRect){10,CGRectGetMaxY(imageview.frame) + 10,20,20}];
        [rentBtn setImage:[UIImage imageNamed:@"佣金按钮"] forState:UIControlStateNormal];
        [self.contentView addSubview:rentBtn];
        
        averageBtn = [[UIButton alloc]initWithFrame:(CGRect){10,CGRectGetMaxY(rentBtn.frame)+ 5,20,20}];
        [averageBtn setImage:[UIImage imageNamed:@"均价按钮"] forState:UIControlStateNormal];
        [self.contentView addSubview:averageBtn];
        
        retnLabel = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(rentBtn.frame) + 5,CGRectGetMaxY(imageview.frame) + 10,100,20}];
        retnLabel.text = @"佣金：8888元";
        retnLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:retnLabel];
        
        averageLabel = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(rentBtn.frame) + 5,CGRectGetMaxY(rentBtn.frame)+ 5,150,20}];
        averageLabel.text = @"均价：1200元/m2";
        averageLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:averageLabel];
        
        enterBtn = [[UIButton alloc]initWithFrame:(CGRect){250,140,120,30}];
        [enterBtn setTitle:@"报备客户" forState:UIControlStateNormal];
        [enterBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        enterBtn.layer.cornerRadius = 5;
        enterBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:enterBtn];
    }
    return self;
}

@end
