//
//  HomeEquipmentCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/2/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeEquipmentCell.h"

@implementation HomeEquipmentCell{
    UILabel *equipmentLabel;//房屋配置标签
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

//设置控件
- (void)setup {
   
    //配置标签
    equipmentLabel = [UILabel new];
    [equipmentLabel setText:@"房屋配套"];
    [equipmentLabel setTextColor:MainColor];
    [self addSubview:equipmentLabel];
    
    [equipmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    //功能按钮
    CGFloat space = 15;
    CGFloat width = 70;
    CGFloat height = 25;
    CGFloat X = (k_w - 3 * width  - 2 * space) / 2;
    
    NSArray *imgArr = @[@"空调",@"免费停车",@"免费WiFi",@"洗浴"];
    
    for (int i = 0; i < imgArr.count; i++) {
        int row = i / 3;
        int column = i % 3;
        
        CGFloat btnX =  X + (space + width) * column;
        CGFloat btnY =  35 + (space + height) * row;
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){btnX,btnY,width,height}];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [btn setSelected:NO];//设置为不选中状态
        [btn setTag:i+1];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        [btn.layer setBorderWidth:2];
    }
    
}

-(void)setObject:(AVObject *)object{
    
    if ([[object objectForKey:@"airConditioner"] isEqualToString:@"1"]) {
        UIButton *btn = [self viewWithTag:1];
        [btn.layer setBorderColor:RGB(226, 25, 76).CGColor];
    }
    
    if ([[object objectForKey:@"parking"] isEqualToString:@"1"]) {
        UIButton *btn = [self viewWithTag:2];
        [btn.layer setBorderColor:RGB(226, 25, 76).CGColor];
    }
    if ([[object objectForKey:@"wifi"] isEqualToString:@"1"]) {
        UIButton *btn = [self viewWithTag:3];
        [btn.layer setBorderColor:RGB(226, 25, 76).CGColor];
    }
    if ([[object objectForKey:@"wash"] isEqualToString:@"1"]) {
        UIButton *btn = [self viewWithTag:4];
        [btn.layer setBorderColor:RGB(226, 25, 76).CGColor];
    }
}

@end
