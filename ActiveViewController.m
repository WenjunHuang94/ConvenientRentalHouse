//
//  ActiveViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ActiveViewController.h"
#import "PeopleSayCell.h"
#import "MyTabBarViewController.h"
#import "LoginViewController.h"

@interface ActiveViewController ()<UITableViewDataSource,UITableViewDelegate,MyTabBarViewControllerDelegate>
@property (nonatomic,strong)MyTabBarViewController *activetabbar;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *data;
@end

@implementation ActiveViewController

//懒加载数据
-(NSArray *)data{
    if (!_data) {
        _data = [SaySayModel arrWithDic];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated{
    //每次出现的时候都要让tabbar属性重新指向自定义tabbar,这样才能让代理响应时响应到当前显示的控制器，所以要在每次视图出现时重新指向
    _activetabbar = (MyTabBarViewController *)self.tabBarController;
    self.activetabbar.mydelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置自定义tabbar的代理
    
    
    [self setNavTitle:@"全部动态" AndImg:[UIImage imageNamed:@"城市下拉1"]];
    [self setNavLeftBtnWithTitle:@[@"消息"] OrImage:nil];
    [self setNavRightBtnWithTitle:nil OrImage:@[@"认证"]];
    
    CGFloat tableviewX = 0;
    CGFloat tableviewY = 44;
    CGFloat tableviewW = self.view.frame.size.width;
    CGFloat tableviewH = self.view.frame.size.height - tableviewY;
    
    self.tableview = [[UITableView alloc]initWithFrame:(CGRect){tableviewX,tableviewY,tableviewW,tableviewH} style:UITableViewStyleGrouped];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
    
    self.tableview.showsVerticalScrollIndicator = NO;
    
    
    self.tableview.allowsSelection = NO;
}

//tableView行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

//构造cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaySayModel *saysaymodel = self.data[indexPath.row];
    //重新加载必须这样写
    PeopleSayCell *cell = [[PeopleSayCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [cell setSaysaymodel:saysaymodel];
    //打开第二个界面
    //刷新数据
    cell.update = ^{
        [self.tableview reloadData];
    };
    
    return cell;
}

//设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}

-(void)NoLogin:(MyTabBarViewController *)tabbar{
    LoginViewController *vcr = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vcr animated:YES];
}

@end
