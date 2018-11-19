//
//  LoginViewController.m
//  文俊购房
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "LoginViewController.h"
#import "Loginview.h"
#import "RegisterViewController.h"
#import "ForgetPasswordController.h"

#import "PasswdPhoneFind.h"//短信找回密码
#import "PasswdEmailFindController.h"//邮箱找回密码

@interface LoginViewController ()

@property (nonatomic,strong)Loginview *loginview;
@property (nonatomic,assign)NSInteger flag;


@end

@implementation LoginViewController{
    UIView *bottonview;
}

//点击空白地方时关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    //隐藏底部导航栏
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    
    [self setNavTitle:@"登录" AndImg:nil];
    [self setNavRightBtnWithTitle:@[@"注册"] OrImage:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];

    self.loginview = [[Loginview alloc]initWithFrame:(CGRect){0,44,self.view.frame.size.width,self.view.frame.size.height - 44}];
    [self.view addSubview:self.loginview];
    
    __weak LoginViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        
        //点击返回按钮时
        if (sender.tag == 1) {
            [obj.tabBarController setHidesBottomBarWhenPushed:NO];//
            [obj.navigationController popViewControllerAnimated:YES];
        }
        //点击注册按钮时
        if (sender.tag == 11) {
            RegisterViewController *vcr = [[RegisterViewController alloc]init];
            [obj.navigationController pushViewController:vcr animated:YES];
        }
    };
    
    //Loginview登录代码块
    self.loginview.loginblock = ^(){
        [obj.view endEditing:YES];//收起键盘
        
        [obj.tabBarController setHidesBottomBarWhenPushed:NO];
        [obj.navigationController popViewControllerAnimated:YES];
    };
    
    
    //Loginview忘记密码代码块
    bottonview.hidden = YES;//一开始隐藏
    
    __weak UIView *bj = bottonview;
    self.flag = 0;//0点击忘记密码时会出现底部选项栏
    
    self.loginview.forgetblock = ^(){//将底部选项栏显示
        if(self.flag == 0){
            
            obj.flag = 1;
            bj.hidden = NO;
            [obj selectFun];
        }
    };

}

//忘记密码找回方式
-(void)selectFun{
    //底部view
    bottonview = [UIView new];
    [self.view addSubview:bottonview];
    [bottonview setBackgroundColor:[UIColor grayColor]];
    
    [bottonview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.bottom.mas_equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(130);
    }];
  
    
    //短信找回密码
    UIButton *phoneBtn = [UIButton new];
    [phoneBtn setTitle:@"短信找回" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneBtn.backgroundColor = [UIColor whiteColor];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchDown];
    [bottonview addSubview:phoneBtn];
    
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottonview.mas_left).offset(1);
        make.right.mas_equalTo(bottonview.mas_right).offset(-1);
        make.top.mas_equalTo(bottonview.mas_top).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    //邮箱找回密码
    UIButton *emailBtn = [UIButton new];
    [emailBtn setTitle:@"邮箱找回" forState:UIControlStateNormal];
    [emailBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    emailBtn.backgroundColor = [UIColor whiteColor];
    [emailBtn addTarget:self action:@selector(emailBtnClick) forControlEvents:UIControlEventTouchDown];
    [bottonview addSubview:emailBtn];
    
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottonview.mas_left).offset(1);
        make.right.mas_equalTo(bottonview.mas_right).offset(-1);
        make.top.mas_equalTo(phoneBtn.mas_bottom).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    //取消按钮
    UIButton *canceBtn = [UIButton new];
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    canceBtn.backgroundColor = [UIColor whiteColor];
    [canceBtn addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchDown];
    [bottonview addSubview:canceBtn];
    
    [canceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottonview.mas_left).offset(1);
        make.right.mas_equalTo(bottonview.mas_right).offset(-1);
        make.top.mas_equalTo(emailBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];
}

//手机验证找回
-(void)phoneBtnClick{
    PasswdPhoneFind *str = [[PasswdPhoneFind alloc]init];
    [self.navigationController pushViewController:str animated:YES];
}

//邮箱找回事件
-(void)emailBtnClick{
    PasswdEmailFindController *str = [[PasswdEmailFindController alloc]init];
    [self.navigationController pushViewController:str animated:YES];
}

//取消事件
-(void)canceBtnClick{
    bottonview.hidden = YES;
    self.flag = 0;
}


@end
