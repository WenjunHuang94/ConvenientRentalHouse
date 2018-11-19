//
//  MyInforViewController.h
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "NavgiationViewController.h"

@class MyInforViewController;
@protocol MyInforViewControllerDelegate <NSObject>

@optional
-(void)updataMy:(MyInforViewController *)vcr AndImg:(UIImage *)img;

@end

@interface MyInforViewController : NavgiationViewController
//只有声明在.h头文件里
@property (nonatomic,strong)UIImage *myimg;
@property (nonatomic,strong)UIButton *mybtn;

@end
