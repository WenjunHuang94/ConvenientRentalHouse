//
//  MyTabBarViewController.h
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sington.h"

@class MyTabBarViewController;
@protocol MyTabBarViewControllerDelegate <NSObject>

@optional

@end

@interface MyTabBarViewController : UITabBarController
//代理属性
@property (nonatomic,strong)id<MyTabBarViewControllerDelegate>mydelegate;

-(void)tabbarWithTitle:(NSArray *)titles AndNOImage:(NSArray *)images
         AndTitleColor:(UIColor *)color AndTitleFont:(UIFont *)font;

//重写方法，是否隐藏tabbar
-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed;

@end
