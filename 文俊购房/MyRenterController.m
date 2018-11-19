//
//  MyRenterController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/16.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MyRenterController.h"
#import "renterInfoCell.h"//求租信息cell

#import "renterInfoDetailController.h"//求租信息详情
#import "MyRenterModifyController.h"//我的求租编辑

@interface MyRenterController()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MyRenterModifyControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;//所有数据

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation MyRenterController

//房源信息数组
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavTitle:@"我的求租" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak MyRenterController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            
            obj.navigationController.navigationBarHidden = YES;
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
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
    
    AVUser *current = [AVUser currentUser];
    AVQuery *query = [AVQuery queryWithClassName:@"RenterHome"];
    [query orderByDescending:@"updatedAt"];
    
    //只获取该用户数据
    [query whereKey:@"phoneNumber" equalTo:current.mobilePhoneNumber];
    [query includeKey:@"imgArr"];//包含房屋所有图片信息
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            [Tip myTip:@"获取数据失败!"];
        }
        else{//成功
            self.dataArr = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];//刷新
        }
        [self.activeView stopAnimating];//旋转动画暂停
    }];
}

//cell向左滑动
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteFun:indexPath];
    }];
    
    //编辑
    UITableViewRowAction *modifyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        MyRenterModifyController *vcr = [[MyRenterModifyController alloc]init];
        vcr.object = self.dataArr[indexPath.section];
        vcr.delegate = self;
        
        [self.navigationController pushViewController:vcr animated:YES];
    }];
    [modifyAction setBackgroundColor:[UIColor grayColor]];
    
    return @[deleteAction,modifyAction];
}


-(void)UpdateModify:(MyRenterModifyController *)vcr{//编辑提交后更新信息
    [self.tableView reloadData];
}

-(void)deleteFun:(NSIndexPath *)indexPath{//删除
    [self.activeView startAnimating];
    
    AVObject *object = self.dataArr[indexPath.section];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (!error) {//成功
            [Tip myTip:@"删除成功!"];
            [self.dataArr removeObjectAtIndex:indexPath.row];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AVObject *object = self.dataArr[indexPath.section];//获取object对象
    
    renterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"renterInfoCell"];
    if (!cell) {
        cell = [[renterInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"renterInfoCell"];
    }
    [cell setObject:object];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//点击选择每一个房源时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    renterInfoDetailController *vcr = [[renterInfoDetailController alloc]init];
    AVObject *object = self.dataArr[indexPath.section];
    vcr.object = object;
    
    [self.navigationController pushViewController:vcr animated:YES];
}

//点击警告选项卡时，处理事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) { //确定删除
        [self.activeView startAnimating];
        
        AVObject *object = self.dataArr[alertView.tag];
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
