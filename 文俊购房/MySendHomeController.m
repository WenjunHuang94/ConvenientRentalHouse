//
//  MySendHomeController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/13.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MySendHomeController.h"
#import "MySendHomeCell.h"

#import "HomeDetailViewController.h"//房屋详情

@interface MySendHomeController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *homeData;//所有数据

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation MySendHomeController

//房源信息数组
-(NSArray *)homeData{
    if (!_homeData) {
        _homeData = [NSMutableArray array];
    }
    return _homeData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavTitle:@"我的租房" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak MySendHomeController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            obj.navigationController.navigationBarHidden = YES;
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];//构造TableView
    [self getData];
}

-(void)createView{
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(0);
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
        make.bottom.mas_equalTo(self.view).with.offset(0);
    }];
    
    [self setupRefresh];//设置上下拉刷新
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}

- (void)setupRefresh {
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//下载网络数据
-(void)getData{
    
    AVQuery *query = [AVQuery queryWithClassName:@"Home"];
    
    //只获取该用户数据
    [query whereKey:@"phoneNumber" equalTo:[Sington sharSington].tell];
    [query includeKey:@"imgArr"];//包含房屋所有图片信息
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {//失败
            [Tip myTip:@"获取数据失败!"];
        }
        else{//成功
            self.homeData = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
        
        [self.activeView stopAnimating];//旋转动画暂停
    }];
}

//cell向左滑动
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteCollect:indexPath];
    }];
   
    
    return @[deleteAction];
}

-(void)deleteCollect:(NSIndexPath *)indexPath{//删除我的租房
    [self.activeView startAnimating];
    
    AVObject *object = self.homeData[indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (!error) {//成功
            [Tip myTip:@"删除成功!"];
            [self.homeData removeObjectAtIndex:indexPath.row];//数组中直接删除后tableView再刷新
            [self.tableView reloadData];
        }
        
        else if(error.code == 403){
            [Tip myTip:@"禁止删除!"];
        }
        
        else{
            [Tip myTip:@"删除失败!"];
        }
        
        [self.activeView stopAnimating];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //房源cell
    
    MySendHomeCell *normalcell = [tableView dequeueReusableCellWithIdentifier:@"MySendHomeCell"];//这句话为复用
    if (!normalcell) {
        normalcell = [[MySendHomeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MySendHomeCell"];
    }
    
    AVObject *home = self.homeData[indexPath.row];
    [normalcell setObject:home];
        
    return normalcell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//点击选择每一个房源时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    HomeDetailViewController *vcr = [[HomeDetailViewController alloc]init];
    AVObject *home = self.homeData[indexPath.row];
    [Sington sharSington].homeImgArr = [home objectForKey:@"imgArr"];//房屋图片
   
    vcr.object = home;//赋值AVObject
    [self.navigationController pushViewController:vcr animated:YES];

    
}

//点击警告选项卡时，处理事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) { //确定删除
        [self.activeView startAnimating];
        
        AVObject *object = self.homeData[alertView.tag];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (!error) {//成功
                [Tip myTip:@"删除成功!"];
            }
            
            else if(error.code == 403){
               [Tip myTip:@"禁止删除!"];
            }
            
            else{
               [Tip myTip:@"删除失败!"];
            }
            
            [self.activeView stopAnimating];
        }];
        
    }
    
}


@end
