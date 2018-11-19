//
//  MessageController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"//cell

#import "MessageNotificationController.h"

@interface MessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *controllers;//控制器名称数组
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation MessageController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"消息" AndImg:nil];
    
    [self initData];
}

- (void)initData {
    
    //控制器名数组
    _controllers = @[@"MessageNotificationController",
                     @"HomeNotificationController",
                     @"ClientNotificationController",
                     @"ScoreNotificationController"];
    
    NSArray *titleArr = @[@"系统通知",@"房源通知",@"房客通知",@"积分通知"];
    
    NSArray *subtitleArr = @[@"系统消息已更新",@"房源通知已更新",@"房客通知已更新",@"积分通知已更新"];
    
    NSArray *imageNameArr = @[@"msg_system",@"msg_house",@"msg_client",@"msg_score"];
    
    self.dataArray = [NSMutableArray array];
    
    for (int i = 0 ; i < titleArr.count; i++) {
        //设置model
        MessageModel *model = [MessageModel new];
        model.img = [UIImage imageNamed:imageNameArr[i]];
        model.title = titleArr[i];
        model.subTitle = subtitleArr[i];

        [self.dataArray addObject:model];//添加moel到数组
    }
    
    [self createView];
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
        make.bottom.mas_equalTo(self.view);
    }];
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    [self.activeView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activeView.backgroundColor = [UIColor blackColor];
    
    [self setupRefresh];//添加上下拉刷新
    [self getData];
    
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

//获取数据
-(void)getData{
    
    //AVQuery
    AVQuery *query = [AVQuery queryWithClassName:@"Message"];
    [query orderByAscending:@"createdAt"];
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {//成功
            for (int i = 0 ; i < objects.count; i++) {
                //设置model
                MessageModel *model = self.dataArray[i];
                model.subTitle = [objects[i] objectForKey:@"content"];
            }
            [self.tableView reloadData];//重新刷新
        }
        
        [self.activeView stopAnimating];
    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"message";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //model通过setModel赋值
    MessageModel *model = self.dataArray[indexPath.section];
    [cell setModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//加右箭头
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//row高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class cls = NSClassFromString(_controllers[indexPath.section]);
    UIViewController *controller = [[cls alloc]init];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
