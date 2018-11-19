//
//  NavgiationViewController.h
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavgiationViewController : UIViewController

-(void)setNavTitle:(NSString *)title AndImg:(UIImage *)image;//设置顶部导航栏中间
-(void)setNavLeftBtnWithTitle:(NSArray *)titles OrImage:(NSArray *)images;//设置顶部导航栏左边
-(void)setNavRightBtnWithTitle:(NSArray *)titles OrImage:(NSArray *)images;//设置顶部导航栏右边
@property (nonatomic ,copy)void (^btnClick)(UIButton *);

@end
