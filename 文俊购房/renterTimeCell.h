//
//  renterTimeCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/15.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface renterTimeCell : UITableViewCell

@property (nonatomic,strong)UILabel *timeLabel;//签约租期
@property (nonatomic,strong)UILabel *time;

@property (nonatomic,strong)UILabel *startTimeLabel;//最晚入住
@property (nonatomic,strong)UILabel *startTime;

-(void)setObject:(AVObject *)object;

@end
