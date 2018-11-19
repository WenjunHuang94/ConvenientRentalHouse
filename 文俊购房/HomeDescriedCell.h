//
//  HomeDescriedCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/2/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#pragma 房屋详情中，房屋优势信息显示

#import <UIKit/UIKit.h>
#import "Sington.h"

@interface HomeDescriedCell : UITableViewCell

@property (nonatomic,strong)UILabel *remark;
@property (nonatomic,strong)UILabel *descriedLabel;

@property (nonatomic,assign)CGFloat cellHeight;//记录高度
-(void)setObject:(AVObject *)object;
@end
