//
//  SelectCityViewController.h
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "NavgiationViewController.h"

@class SelectCityViewController;
@protocol SelectCityViewControllerDelegate <NSObject>
@optional
//选择城市，用于注册时填入所在城市信息
-(void)selectCity:(SelectCityViewController*)vcr AndCityName:(NSString *)name;

@end

@interface SelectCityViewController : NavgiationViewController
@property (nonatomic,weak)id<SelectCityViewControllerDelegate>delegate;

@end
