//
//  MyViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MyViewController.h"

#import "mymodel.h"
#import "LoginViewController.h"//登录

#import "MyCommentController.h"//我的评价
#import "MyCollectController.h"//我的收藏

#import "DesignViewController.h"//设置
#import "MyInforViewController.h"//我的详情

#import "MyTabBarViewController.h"

#import "PasswdPhoneFind.h"//短信找回密码
#import "FeedBackController.h"//反馈

#import "MySendHomeController.h"//我的房屋发布
#import "MyRenterController.h"//我的求租

#import "ModifyNameController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,DesignViewControllerDelegate,MyInforViewControllerDelegate>

@property (nonatomic,strong)MyTabBarViewController *mytabbar;

@property (nonatomic,strong)UIView *topview;
@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)UIButton *mybtn;
@property (nonatomic,strong)UIButton *loginbtn;
@property (nonatomic,strong)UIButton *tellbtn;
@property (nonatomic,strong)NSArray *data;//"我"界面的cell数据

@end

@implementation MyViewController

//用取"我"界面的cell数据
-(NSArray *)data{
    if (!_data) {
        _data = [mymodel arrWithDic];
    }
    return _data;
}

//可以改变状态栏的背影颜色，每次视图将要出现时都更新数据
-(void)viewWillAppear:(BOOL)animated{
    
    //将出现时顶部栏隐藏
    self.navigationController.navigationBarHidden = YES;
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, k_w, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:62 / 255.0 green:90 / 255.0 blue:131  / 255.0 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self reloadMyData];
}

//更新用户数据
-(void)reloadMyData{
    
    //每次进入时都更新数据
    [self.mybtn setImage:[Sington sharSington].img forState:UIControlStateNormal];
    [self.loginbtn setTitle:[Sington sharSington].name forState:UIControlStateNormal];
    [self.tellbtn setTitle:[Sington sharSington].tell forState:UIControlStateNormal];
    
    if ([Sington sharSington].isLogin == YES) {
        self.tellbtn.hidden = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)createView{
    
    //tableview
    CGFloat tableviewX = 0;
    CGFloat tableviewY = 0;
    //CGFloat tableviewW = self.view.frame.size.width;
    //CGFloat tableviewH = self.view.frame.size.height;
    self.tableview = [[UITableView alloc]initWithFrame:(CGRect){tableviewX,tableviewY,k_w,k_h} style:UITableViewStyleGrouped];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
  
    [self.view addSubview:self.tableview];
    
    //顶部topview
    self.topview = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,200}];
    self.topview.backgroundColor = [UIColor colorWithRed:62 / 255.0 green:90 / 255.0 blue:131  / 255.0 alpha:1];
    
    
    //将顶部topview设置为tableview的头
    self.tableview.tableHeaderView = self.topview;
    self.tableview.tableHeaderView.backgroundColor = [UIColor colorWithRed:62/255.0 green:90/255.0 blue:131/255.0 alpha:1];

    
    //头像按钮
    CGFloat mybtnW = 100;
    CGFloat mybtnH = 100;
    CGFloat mybtnX = (self.view.frame.size.width - mybtnW) / 2;
    CGFloat mybtnY = 30;
    self.mybtn = [[UIButton alloc]initWithFrame:(CGRect){mybtnX,mybtnY,mybtnW,mybtnH}];
    
    self.mybtn.layer.cornerRadius = mybtnW / 2;
    self.mybtn.layer.masksToBounds = YES;
    self.mybtn.backgroundColor = [UIColor colorWithRed:62/255.0 green:90/255.0 blue:131/255.0 alpha:1];
    [self.mybtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:self.mybtn];
    
    //登录按钮
    self.loginbtn = [[UIButton alloc]initWithFrame:(CGRect){(k_w - 150) / 2,CGRectGetMaxY(self.mybtn.frame),150,30}];
    self.loginbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.loginbtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];//跳到登录界面
    [self.topview addSubview:self.loginbtn];
    
    //用户电话按钮
    CGFloat tellbtnW = 150;
    CGFloat tellbtnH = 30;
    CGFloat tellbtnX = (self.view.frame.size.width - tellbtnW) / 2;
    CGFloat tellbtnY = CGRectGetMaxY(self.loginbtn.frame);
    self.tellbtn = [[UIButton alloc]initWithFrame:(CGRect){tellbtnX,tellbtnY,tellbtnW,tellbtnH}];
    self.tellbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.tellbtn.hidden = YES;
    
    //点击头像,跳到登录界面
    [self.tellbtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:self.tellbtn];
    
}

//跳到登录界面
-(void)login{
    
    if (![Sington sharSington].isLogin) {
        LoginViewController *vcr = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    
    //如果已经登录后
    else{
        MyInforViewController *vcr = [[MyInforViewController alloc]init];
        [self.navigationController pushViewController:vcr animated:YES];
    }
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.data[section];
    return arr.count;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    NSArray *arr = self.data[indexPath.section];
    mymodel *model = arr[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:model.imgname];
    cell.textLabel.text = model.content;
    
    //加向右的箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //联系客服
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"18670388380";
    }

    return cell;
}

//允许下拉，禁止上拉
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.tableview.contentOffset.y <= 0) {
        self.tableview.bounces = NO;
    }else{
        self.tableview.bounces = YES;
    }
}

//点击当前cell时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    if (indexPath.section == 0 && indexPath.row == 0) {//我的评价
        if (![Sington sharSington].isLogin) {
            [Tip myTip:@"请先登录!"];
        }
        
        else{
            MyCommentController *vcr = [[MyCommentController alloc]init];
            [self.navigationController pushViewController:vcr animated:YES];
            
        }
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1) {//我的收藏
        if (![Sington sharSington].isLogin) {
            [Tip myTip:@"请先登录!"];
        }
        
        else{
            MyCollectController *vcr = [[MyCollectController alloc]init];
            [self.navigationController pushViewController:vcr animated:YES];
            
        }
    }
    
    else if (indexPath.section == 0 && indexPath.row == 2) {//租房发布
        if (![Sington sharSington].isLogin) {
           [Tip myTip:@"请先登录!"];
        }
        
        else{
            MySendHomeController *vcr = [[MySendHomeController alloc]init];
            [self.navigationController pushViewController:vcr animated:YES];
            
        }
    }
    
    else if (indexPath.section == 0 && indexPath.row == 3) {//求租发布
        if (![Sington sharSington].isLogin) {
            [Tip myTip:@"请先登录!"];
        }
        
        else{
            MyRenterController *vcr = [[MyRenterController alloc]init];
            [self.navigationController pushViewController:vcr animated:YES];
            
        }
    }
    
    //帮助与反馈
    else if (indexPath.section == 1 && indexPath.row == 0){
        FeedBackController *vcr = [[FeedBackController alloc]init];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    
    //点击设置一栏时
    else if (indexPath.section == 2 && indexPath.row == 0) {
        DesignViewController *vcr = [[DesignViewController alloc]init];
        vcr.delegate = self;
        [self.navigationController pushViewController:vcr animated:YES];
        
    }
    
    //当点击联系客服时，拨打客服电话
    else if (indexPath.section == 2 && indexPath.row == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15507835782"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];

    }
 
}


@end
