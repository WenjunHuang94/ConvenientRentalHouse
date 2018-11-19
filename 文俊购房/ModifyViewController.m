//
//  ModifyViewController.m
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ModifyViewController.h"
#import "ModifyView.h"
#import "Sington.h"

@interface ModifyViewController ()
@property (nonatomic,strong)ModifyView *modiview;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"修改密码" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    [self setNavRightBtnWithTitle:@[@"完成"] OrImage:nil];
    
    __weak ModifyViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        //点击返回按钮时
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }else if (sender.tag == 11){
            [obj check];
        }
    };
    
     _modiview = [[ModifyView alloc]initWithFrame:(CGRect){0,44,self.view.frame.size.width,self.view.frame.size.height - 44}];
    [self.view addSubview:_modiview];
    
}

//检查输入
-(void)check{
    
    //判断旧密码是否为空
    if([_modiview.oldfield.text isEqualToString:@""]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入旧密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        _modiview.oldfield.text = @"";
    }
    
    //判断旧密码位数
    else if(_modiview.oldfield.text.length < 6){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"旧密码位数错误!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        _modiview.oldfield.text = @"";
    }
    
    //判断新密码是否为空
    else if([_modiview.passfield.text isEqualToString:@""]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入新密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        _modiview.passfield.text = @"";
    }
    
    //判断新密码位数是否正确
    else if(_modiview.passfield.text.length < 6){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"新密码位数错误!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        _modiview.passfield.text = @"";
    }
  
    //再次输入新密码位数是否为空
    else if ([_modiview.againfield.text isEqualToString:@""]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请再次输入新密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        _modiview.againfield.text = @"";
    }
    
    //再次输入新密码位数是否正确
    else if (_modiview.againfield.text.length < 6){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"再次输入新密码位数错误!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        _modiview.againfield.text = @"";
    }
    
    //旧密码错误
    else if (![_modiview.oldfield.text isEqualToString:[Sington sharSington].passwd]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"旧密码错误!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
    }
    
    //
    else if (![_modiview.passfield.text isEqualToString:_modiview.againfield.text]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"新密码输入不一致!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
    }
    else
    {
        [self successTip];
    }
}

-(void)successTip{
    CGFloat laW = 250;
    CGFloat laH = 60;
    CGFloat laX = (self.view.frame.size.width - laW) / 2;
    CGFloat laY = (self.view.frame.size.height - laH) / 2;
    UILabel *la =[[UILabel alloc]initWithFrame:(CGRect){laX,laY,laW,laH}];
    la.text = @"修改密码成功";
    la.textAlignment = NSTextAlignmentCenter;
    la.font = [UIFont systemFontOfSize:15];
    la.backgroundColor = [UIColor lightGrayColor];
    la.textAlignment = NSTextAlignmentCenter;
    la.font = [UIFont systemFontOfSize:15];
    la.backgroundColor = [UIColor lightGrayColor];
    la.alpha = 0;
    la.layer.cornerRadius = 10;
    la.layer.masksToBounds = YES;
    [self.view addSubview:la];
    [UIView animateWithDuration:1 animations:^{
        la.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            la.alpha = 0;
        } completion:^(BOOL finished) {
            [la removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    //加载用户数据
//    NSArray *data = [User loadUserData];
//    //找到对应用户并修改密码
//    for (User *user in data) {
//        if ([user.tell isEqualToString:[Sington sharSington].tell]) {
//            user.passwd = _modiview.passfield.text;
//            //保存修改后的数据到文件夹中
//            [User saveUserData:data];
//            //记录新的密码
//            [Sington sharSington].passwd = user.passwd;
//        }
//    }
}


@end
