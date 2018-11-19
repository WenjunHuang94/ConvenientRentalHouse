//
//  ScoreNotificationController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/12.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ScoreNotificationController.h"
#import "MessageNotificationCell.h"//Cell

@interface ScoreNotificationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation ScoreNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavTitle:@"积分通知" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];

    __weak ScoreNotificationController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];//创建VIEW
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
    
    [self setupRefresh];//添加上拉、下拉刷新
    
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

//获取网络数据
-(void)getData{
    AVQuery *query = [AVQuery queryWithClassName:@"ScoreNotification"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"image"];//包含图片所有信息
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {//成功
            self.dataArr = objects;
            [self.tableView reloadData];//更新数据
        }
        
        else{
            [Tip myTip:@"加载失败!"];
        }
        
        [self.activeView stopAnimating];
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
