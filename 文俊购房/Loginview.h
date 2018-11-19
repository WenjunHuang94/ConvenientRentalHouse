//
//  Loginview.h
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sington.h"

@interface Loginview : UIView<UITextFieldDelegate>

//登录模块，要获取所有的用户信息
@property (nonatomic ,copy)NSString *userPath;
@property (nonatomic,strong)NSArray *data;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

//点击登录按钮时,代码块
@property (nonatomic,strong)void(^loginblock)();

//点击忘记密码按钮时，代码块
@property (nonatomic,strong)void(^forgetblock)();

@end
