//
//  MyCollectController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/28.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MyCollectController.h"

#import "NormalTableViewCell.h"//ROOT--房屋Cell
#import "HomeDetailViewController.h"//房屋详情

@interface MyCollectController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation MyCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavTitle:@"我的收藏" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    __weak MyCollectController *obj = self;
    self.btnClick = ^(UIButton *sender){
        
        if (sender.tag == 1) {//点击返回
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];//创建View
    [self getData];
    
}

//获取数据
-(void)getData{
    
    AVUser *user = [AVUser currentUser];
    self.dataArr = [user objectForKey:@"collectHomeArr"];
    [self.tableView reloadData];//重新刷新
}

//构造控件
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
    
    [self setupRefresh];
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
    
}

//cell向左滑动
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteCollect:indexPath];
    }];
    
    return @[deleteAction];
}

-(void)deleteCollect:(NSIndexPath *)indexPath{//删除收藏房屋
    AVUser *user = [AVUser currentUser];
    NSMutableArray *collectHomeArr = [user objectForKey:@"collectHomeArr"];
    
    for(int i = 0;i < collectHomeArr.count;i++){
        if ([collectHomeArr[i] isEqualToString:self.dataArr[indexPath.section]]) {
            [collectHomeArr removeObjectAtIndex:i];
        }
    }
    
    [user setObject:collectHomeArr forKey:@"collectHomeArr"];
    
    [self.activeView startAnimating];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"取消收藏成功!"];
            [self.tableView reloadData];//dataArr一直指向collectHomeArr,可直接刷新
        }
        else{
            [Tip myTip:@"取消收藏失败!"];
        }
        [self.activeView stopAnimating];
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"cell";
    //房源cell
    NormalTableViewCell *normalcell = [tableView dequeueReusableCellWithIdentifier:identify];//这句话为复用
    if (!normalcell) {
        normalcell = [[NormalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"Home"];
    
    
    [query includeKey:@"mainImg"];//包含房屋首页图片所有信息
    [query includeKey:@"imgArr"];//包含房屋所有图片信息
    
    [query getObjectInBackgroundWithId:self.dataArr[indexPath.section] block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            if (indexPath.section == self.dataArr.count) {//所有图片都加载失败
                [Tip myTip:@"加载数据失败！"];
            }
        }
        else{
            [normalcell setObject:object];
        }
    }];
    
    return normalcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    NormalTableViewCell *normalcell = [tableView cellForRowAtIndexPath:indexPath];
    
    [Sington sharSington].homeImgArr = [normalcell.home objectForKey:@"imgArr"];//房屋图片
    HomeDetailViewController *vcr = [[HomeDetailViewController alloc]init];
    vcr.object = normalcell.home;//赋值AVObject
    
    [self.navigationController pushViewController:vcr animated:YES];
}


//每组尾部宽度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//每行实际高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end