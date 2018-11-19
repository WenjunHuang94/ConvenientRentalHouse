//
//  EquipmentCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/26.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "EquipmentCell.h"

@implementation EquipmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

//设置控件
- (void)setup {
    
    //功能按钮
    CGFloat space = 15;
    CGFloat width = 65;
    CGFloat height = 25;
    CGFloat X = (k_w - 3 * width  - 2 * space) / 2;
    
    NSArray *imgArr = @[@"空调",@"免费停车",@"免费WiFi",@"洗浴"];
    
    for (int i = 0; i < imgArr.count; i++) {
        int row = i / 3;
        int column = i % 3;
        
        CGFloat btnX =  X + (space + width) * column;
        CGFloat btnY =  10 + (space + height) * row;
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){btnX,btnY,width,height}];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [btn setSelected:NO];//设置为不选中状态
        [btn setTag:i+1];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        [btn.layer setBorderWidth:2];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    }

}

-(void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;//改变选中状态,改为选中
    if(btn.selected){
        [btn.layer setBorderColor:RGB(226, 25, 76).CGColor];
    }
    else{
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    }

}

@end
