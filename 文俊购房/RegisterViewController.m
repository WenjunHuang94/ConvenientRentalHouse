//
//  RegisterViewController.m
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "SelectCityViewController.h"

#import "PhoneVerifyController.h"

@interface RegisterViewController ()<SelectCityViewControllerDelegate>

@property (nonatomic,strong)RegisterView *gegister;//注册视图
@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"用户注册" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    [self setNavRightBtnWithTitle:@[@"提交"] OrImage:nil];
    
    __weak RegisterViewController *obj = self;
    self.btnClick = ^(UIButton *sender){//顶部点击代码块
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
        else if (sender.tag == 11){
            //检查输入
            [obj check];
        }
    };
    
    //注册View
    _gegister = [[RegisterView alloc]initWithFrame:(CGRect){0,44,k_w,k_h - 44}];
    [self.view addSubview:_gegister];
    
    //点击选择城市时(代码块)
    _gegister.selectBlock = ^(){
        SelectCityViewController *vcr = [[SelectCityViewController alloc]init];
        vcr.delegate = obj;
        [obj.navigationController pushViewController:vcr animated:YES];
    };
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}

 //点击注册按钮时，检查输入
-(void)check{
    
//    _gegister.tellfield.text = @"15507835782";
//    _gegister.codeField.text = @"454545";
//    _gegister.mailField.text = @"785941939@qq.com";
//    _gegister.passfield.text = @"hello7566";
//    _gegister.name.text = @"wj";
//    _gegister.city.titleLabel.text= @"长沙";//所在城市
    
    //判断手机号位数否正确
    if ([_gegister.tellfield.text isEqualToString:@""]) {
        [Tip myTip:@"请输入手机号!"];
        _gegister.tellfield.text = @"";
    }
    else if (_gegister.tellfield.text.length != 11) {
        [Tip myTip:@"手机号码位数错误!"];
        _gegister.tellfield.text = @"";
    }
    
//    //判断安全码是否正确
//    else if ([_gegister.codeField.text isEqualToString:@""] ) {
//        [Tip myTip:@"请输入安全码!"];
//        _gegister.codeField.text = @"";
//    }
//    else if (_gegister.codeField.text.length != 6) {
//        [Tip myTip:@"安全码位数错误!"];
//        _gegister.codeField.text = @"";
//    }
    
    //判断邮箱否正确
    else if ([_gegister.mailField.text isEqualToString:@""] ) {
        [Tip myTip:@"请输入邮箱!"];
        _gegister.mailField.text = @"";
    }
    
    //判断密码位数否正确
    else if ([_gegister.passfield.text isEqualToString:@""]) {
        [Tip myTip:@"请输入密码!"];
        _gegister.passfield.text = @"";
    }
    
    else if ((_gegister.passfield.text.length < 6) || (_gegister.passfield.text.length > 16)) {
        [Tip myTip:@"密码位数错误!"];
        _gegister.passfield.text = @"";
    }
    
    //当没有输入姓名时
    else if ([_gegister.name.text isEqualToString:@""]){
        [Tip myTip:@"请输入用户名!"];
        _gegister.name.text = @"";
    }
    
    //当没有选择城市时
    else if ([_gegister.city.titleLabel.text isEqualToString:@"请选择城市"] || [_gegister.city.titleLabel.text isEqualToString:@""]){
        [Tip myTip:@"请选择城市!"];
    }
    
    else
    {
        //给用户注册，AVUser，写入_User表
        AVUser *user = [AVUser user];
        user.mobilePhoneNumber = _gegister.tellfield.text;//手机号
        
        //根据Key赋值
        [user setObject:@"0" forKey:@"score"];
        //[user setObject:_gegister.codeField.text forKey:@"safeCode"];//验证码
        user.email = _gegister.mailField.text;//邮箱
        user.password = _gegister.passfield.text;//密码
        user.username = _gegister.name.text;//用户名
        [user setObject:_gegister.city.titleLabel.text forKey:@"city"];//所在城市
        
        //写头像
        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"默认头像"]);
        AVFile *file = [AVFile fileWithData:data];
        [user setObject:file forKey:@"image"];
        
        [self.activeView startAnimating];//加载动画
        //把数据直接写到User表
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {//注册成功,再保存用户别的信息
                [Tip myTip:@"注册成功！"];
                PhoneVerifyController *str = [[PhoneVerifyController alloc]init];
                [self.navigationController pushViewController:str animated:YES];

            }
        
            else if (error.code == 125){ //错误编码125，邮箱非法
                [Tip myTip:@"请输入合法的邮箱号！"];
                _gegister.mailField.text = @"";
            }
            else if (error.code == 203){ //错误编码203，邮箱已占用
                [Tip myTip:@"此电子邮箱已经被占用!"];
                _gegister.mailField.text = @"";
            }
            
            else if (error.code == 214){ //错误编码214，手机号已占用
                [Tip myTip:@"此手机号已经被占用！"];
                _gegister.tellfield.text = @"";
            }
            else if (error.code == 127){//编码127，无效的手机号
                [Tip myTip:@"无效的手机号码！"];
                _gegister.tellfield.text = @"";
            }
            else if (error.code == -1001){//编码-1001，请求时间超过
                [Tip myTip:@"请求时间超过！"];
            }
            
            else {
                NSLog(@"注册失败 %@", error);
                [Tip myTip:@"注册失败！"];
            }
            
            [self.activeView stopAnimating];//停止动画
        }];

    }

}

//点击空白地方，即view时关闭键盘，别的控制都是添加在view上的，会覆盖掉效果，所以点别的控件无效
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


//代理方法，将定位到的城市填入注册界面中的所在城市里
-(void)selectCity:(SelectCityViewController *)vcr AndCityName:(NSString *)name{
    [self.gegister.city setTitle:name forState:UIControlStateNormal];
    [self.gegister.city setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

@end
