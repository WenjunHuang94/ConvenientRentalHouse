//
//  Sington.m
//  文俊购房
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "Sington.h"

static Sington *sington = nil;

@implementation Sington

//调用这个单例对象
+(Sington *)sharSington{
    
    if (sington == nil) {//当这个对象为空时，构造出来
    
        sington = [[Sington alloc] init];
        sington.name = @"请登录";
        sington.img = [UIImage imageNamed:@"未登录头像"];
        sington.isLogin = NO;
        
        sington.hotCityArr = [NSArray array];//热门城市数组
        //sington.cityId = 2;//最开始默认城市是长沙,对应ID是2
        sington.city = @"桂林";//以城市名展示房屋数据
    }
    
    return sington;//返回单例对象
}

//重写alloc方法，只能构造出一个实例
+(id)allocWithZone:(struct _NSZone *)zone{
    //当单例对象为空时，构造出一个实例
    if (sington == nil) {
        sington = [super allocWithZone:zone];
    }
    return sington;
}


@end
