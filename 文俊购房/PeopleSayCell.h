//
//  PeopleSayCell.h
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaySayModel.h"
@interface PeopleSayCell : UITableViewCell

@property (nonatomic,strong)UIImageView *peopleImage;
@property (nonatomic,assign)NSInteger btnArrCount;

//SaySayModel数据
@property (nonatomic,strong)SaySayModel *saysaymodel;
@property (nonatomic,strong)NSArray *btnArr;
//通过代码块在控制器更新数据
@property (nonatomic,strong)void (^update)();

@end
