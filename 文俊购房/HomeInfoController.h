//
//  HomeInfoController.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "NavgiationViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HomeInfoController : NavgiationViewController

@property (nonatomic,strong) NSString *city;//城市
@property (nonatomic,strong) NSString *district;//区域
@property (nonatomic,strong) NSString *homeName;//房名
@property (nonatomic,strong) NSString *areaDetail;//详细地址

@property (nonatomic,strong) NSString *homeType;//房型
@property (nonatomic,strong) NSString *area;//面积
@property (nonatomic,strong) NSString *floor;//楼层

@property (nonatomic,strong) NSString *rentMoney;//租金
@property (nonatomic,strong) NSString *homeEquipment;//装修
@property (nonatomic,strong) NSString *homeUseType;//类型

@property (nonatomic,strong) NSString *airConditioner;//空调
@property (nonatomic,strong) NSString *parking;//免费停车
@property (nonatomic,strong) NSString *wifi;//WIFI
@property (nonatomic,strong) NSString *wash;//洗浴



@end
