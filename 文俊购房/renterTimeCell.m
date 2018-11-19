//
//  renterTimeCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/15.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "renterTimeCell.h"

@implementation renterTimeCell

//画图一定要在UIVW类中画，才会有下面这个方法来画
-(void)drawRect:(CGRect)rect{
    [self drawLine];
}

//画线
-(void)drawLine{
    
    [[UIColor lightGrayColor]set];//设置线的颜色
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //画线的起点
    CGContextMoveToPoint(context, k_w / 2 + 40, 10);
    //画线的顶点
    CGContextAddLineToPoint(context, k_w / 2 - 40, 80);
    
    CGContextStrokePath(context);
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    //租期标签
    _timeLabel = [UILabel new];
    [self addSubview:_timeLabel];
    
    [_timeLabel setText:@"签约日期"];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    //租期
    _time = [UILabel new];
    [self addSubview:_time];
    //[_time setText:@"1年"];
    [_time setTextColor:[UIColor redColor]];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.timeLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    //租期标签
    _startTimeLabel = [UILabel new];
    [self addSubview:_startTimeLabel];
    
    [_startTimeLabel setText:@"最晚入住"];
    
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_top);
        make.right.mas_equalTo(self.mas_right).with.offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    //租期
    _startTime = [UILabel new];
    [self addSubview:_startTime];
    
    //[_startTime setText:@"随时起住"];
    [_startTime setTextColor:[UIColor redColor]];
    
    [_startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_startTimeLabel.mas_bottom).with.offset(0);
        make.right.mas_equalTo(self.startTimeLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
}

-(void)setObject:(AVObject *)object{
    _time.text = [object objectForKey:@"time"];
    _startTime.text = [object objectForKey:@"startTime"];
}

@end
