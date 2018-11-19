//
//  Sington.h
//  文俊购房
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sington : NSObject

//用户信息全局变量
@property (nonatomic,strong)NSString *tell;//电话
@property (nonatomic,strong)NSString *passwd;//密码
@property (nonatomic,strong)UIImage *img;//用户头像
@property (nonatomic,strong)NSString *name;//用户名

@property (nonatomic,assign)BOOL isLogin;//判断是否登录

@property (nonatomic,strong)NSString *city;//城市名，记录房源信息
@property (nonatomic,strong)NSArray *hotCityArr;//用于记录热门城市数组
@property (nonatomic,assign)NSInteger cityId;//用于记录选中城市的Id
@property (nonatomic,strong)NSArray *homeImgArr;//房屋图片数组

+(Sington *)sharSington;
+(id)allocWithZone:(struct _NSZone *)zone;

@end
