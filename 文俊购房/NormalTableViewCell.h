//
//  NormalTableViewCell.h
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *homeImage;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *buildType;
@property (nonatomic,strong)UILabel *cityName;

@property (nonatomic,strong)UILabel *districtName;
@property (nonatomic,strong)UILabel *priceRemark;
@property (nonatomic,strong)UIButton *commissionBtn;
@property (nonatomic,strong)UILabel *commissionLabel;

-(void)setObject:(AVObject *)object;
@property (nonatomic,strong)AVObject *home;//用object名会出错

@end
