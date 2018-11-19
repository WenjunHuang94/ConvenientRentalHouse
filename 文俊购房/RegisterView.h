//
//  RegisterView.h
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView//<UITextFieldDelegate>

//点击请选择城市时,代码块
@property (nonatomic,strong)void(^selectBlock)();

@property (nonatomic,strong)UITextField *tellfield;//手机号
@property (nonatomic,strong)UITextField *codeField;//验证码(安全码)
@property (nonatomic,strong)UITextField *mailField;//邮箱
@property (nonatomic,strong)UITextField *passfield;//密码

@property (nonatomic,strong)UITextField *name;//用户名
@property (nonatomic,strong)UIButton *city;//城市

@end
