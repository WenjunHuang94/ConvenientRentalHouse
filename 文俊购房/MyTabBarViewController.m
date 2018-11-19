//
//  MyTabBarViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "MyTabbarItem.h"


@interface MyTabBarViewController ()
@property (nonatomic,strong)UIView *mytabbar;

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.hidden = YES;
    [self createView];
}

-(void)createView{
    self.mytabbar = [[UIView alloc]initWithFrame:(CGRect){0,k_h - 49,k_w,49}];
    self.mytabbar.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:179 / 255.0 blue:90 / 255.0 alpha:1];
    [self.view addSubview:self.mytabbar];
}

-(void)tabbarWithTitle:(NSArray *)titles AndNOImage:(NSArray *)images
         AndTitleColor:(UIColor *)color AndTitleFont:(UIFont *)font{
    
    for (int i = 0;i < titles.count;i++) {
        MyTabbarItem *tabitem = [[MyTabbarItem alloc]initWithFrame:(CGRect){i * k_w / titles.count,0,k_w / titles.count,49} AndTitels:titles[i] AndImage:images[i] AndTitleColor:color AndTitleFont:font];
        tabitem.tag = i + 1;
        [tabitem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mytabbar addSubview:tabitem];
        
    }
}

-(void)itemClick:(UIButton *)sender{
    self.selectedIndex = sender.tag - 1;
}

//重写隐藏底部bar的方法，可以隐藏自定义tabbarview
-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    if (hidesBottomBarWhenPushed == YES) {
        self.mytabbar.hidden = YES;
    }else
        self.mytabbar.hidden = NO;
    
}



@end
