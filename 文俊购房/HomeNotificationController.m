//
//  HomeNotificationController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/12.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeNotificationController.h"
#import "MessageNotificationCell.h"

@interface HomeNotificationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation HomeNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"房源通知" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak HomeNotificationController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];//创建VIEW
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
    
    [self getData];
}

//获取数据
-(void)getData{
    
    AVQuery *query = [AVQuery queryWithClassName:@"HomeNotification"];
    [query orderByDescending:@"createdAt"];//按时间降序排列
    [query includeKey:@"image"];//包含图片所有信息
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {//成功
            self.dataArr = objects;
            
            [self.tableView reloadData];//重新加载数据
        }
        
        else{
            [Tip myTip:@"加载失败!"];
        }
        
        [self.activeView stopAnimating];
        
    }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"cell";
    MessageNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[MessageNotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    //AVObject
    AVObject *object = self.dataArr[indexPath.row];
    [cell setObject:object];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}

@end
