//
//  HomeMessageCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/31.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMessageCell : UITableViewCell

@property (nonatomic,strong)UIButton *imgBtn;//头像
@property (nonatomic,strong)UILabel *name;//用户名

@property (nonatomic,strong)UILabel *phone;//手机号
@property (nonatomic,strong)UILabel *date;//日期
@property (nonatomic,strong)UILabel *content;//留言内容

@property (nonatomic,assign)CGFloat cellHeight;

-(void)setDic:(NSDictionary *)dic;

@end
