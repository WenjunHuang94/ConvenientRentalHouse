//
//  MySendHomeCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/13.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySendHomeCell : UITableViewCell

@property (nonatomic,strong)UIImageView *homeImage;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *buildType;

@property (nonatomic,strong)UILabel *cityName;
@property (nonatomic,strong)UILabel *districtName;
@property (nonatomic,strong)UILabel *priceRemark;

@property (nonatomic,strong)UIButton *verifyBtn;//是否已验证

-(void)setObject:(AVObject *)home;

@end
