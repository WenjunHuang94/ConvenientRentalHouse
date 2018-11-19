//
//  ForgetView.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/9.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetView : UIView<UITextFieldDelegate>//文本框代理，用于限制输入内容位数

@property (nonatomic,strong)UITextField *tellfield;//手机号
@property (nonatomic,strong)UITextField *identifyingCodeField;//安全码，用于找回密码
@property (nonatomic,strong)UITextField *passfield;//设置新的密码

@end
