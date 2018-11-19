//
//  renterShowCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/6/2.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface renterShowCell : UITableViewCell

@property(nonatomic,strong)UILabel *rentMoenyLabel;
@property(nonatomic,strong)UILabel *rentMoneny;

@property(nonatomic,strong)UILabel *roomLabel;//房型
@property(nonatomic,strong)UILabel *room;

@property(nonatomic,strong)UILabel *areaLabl;
@property(nonatomic,strong)UILabel *area;

@property(nonatomic,strong)UILabel *floorLabel;
@property(nonatomic,strong)UILabel *floor;

@property(nonatomic,strong)UILabel *decorationLabel;//装修标签
@property(nonatomic,strong)UILabel *decoration;//装修

@property(nonatomic,strong)UILabel *propertyTypeLabel;//类型标签
@property(nonatomic,strong)UILabel *propertyType;//类型

-(void)setObject:(AVObject *)object;

@end
