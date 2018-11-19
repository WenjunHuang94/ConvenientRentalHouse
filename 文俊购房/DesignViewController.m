//
//  DesignViewController.m
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "DesignViewController.h"
#import "Sington.h"
#import "ModifyViewController.h"

#import "PhoneVerifyController.h"//手机绑定
#import "EmailVerifyController.h"//邮箱绑定
#import "FeedBackController.h"//意见反馈

@interface DesignViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableview;

@end

@implementation DesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"设置" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    //将导航栏显示
    self.navigationController.navigationBarHidden = NO;
    
    __weak UIViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        //点击返回按钮时
        if (sender.tag == 1) {
            obj.navigationController.navigationBarHidden = YES;
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
}

-(void)createView{
    
    self.tableview = [[UITableView alloc]initWithFrame:(CGRect){0,-20,k_w,k_h} style:UITableViewStyleGrouped];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
    
    //tableview的底部view
    UIView *bottomView = [[UIView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(self.tableview.frame) + 20,self.view.frame.size.width,100}];
    self.tableview.tableFooterView = bottomView;
    
    CGFloat quitW = k_w - 20;
    CGFloat quitX = (k_w - quitW) / 2;
    UIButton *quit = [[UIButton alloc]initWithFrame:(CGRect){quitX,0,quitW,40}];
    quit.backgroundColor = [UIColor orangeColor];
    [quit setTitle:@"退出" forState:UIControlStateNormal];
    quit.layer.cornerRadius = 10;
    quit.layer.masksToBounds = YES;
    [quit addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:quit];
}

-(void)quitBtnClick{
    [AVUser logOut];//退出登录
    [Tip myTip:@"退出成功！"];
    [self.navigationController popViewControllerAnimated:YES];
    
    [Sington sharSington].tell = @"";
    [Sington sharSington].name = @"请登录";
    [Sington sharSington].img = [UIImage imageNamed:@"未登录头像"];
    [Sington sharSington].isLogin = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //加向右的箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"手机绑定";
        
    }
    else if (indexPath.row == 1) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //加向右的箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"邮箱绑定";
        
    }
    else if (indexPath.row == 2){
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //加向右的箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"意见反馈";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        PhoneVerifyController *str = [[PhoneVerifyController alloc]init];
        [self.navigationController pushViewController:str animated:YES];
    }
    
    else if (indexPath.row == 1){
        EmailVerifyController *str = [[EmailVerifyController alloc]init];
        [self.navigationController pushViewController:str animated:YES];
    }
    
    else if (indexPath.row == 2){
        FeedBackController *str = [[FeedBackController alloc]init];
        [self.navigationController pushViewController:str animated:YES];
    }
}



@end
