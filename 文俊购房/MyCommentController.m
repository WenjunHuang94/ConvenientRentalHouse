//
//  MyCommentController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/24.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MyCommentController.h"
#import "MyCommentCell.h"

@interface MyCommentController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;//数据arr
@property (nonatomic,strong)NSMutableArray *cellHeightArr;//cell高度arr

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation MyCommentController

-(NSMutableArray *)cellHeightArr{
    if (!_cellHeightArr) {
        _cellHeightArr = [NSMutableArray array];
    }
    return _cellHeightArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavTitle:@"我的评价" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    __weak MyCommentController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {//点击返回
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];//创建view
    [self getData];//获取数据
}

//获取数据
-(void)getData{
    AVUser *user = [AVUser currentUser];
    
    //查询数据
    AVQuery *query = [AVQuery queryWithClassName:@"FeedBack"];
    [query whereKey:@"phoneNumber" equalTo:user.mobilePhoneNumber];//匹配手机号
    [query orderByDescending:@"updatedAt"];//按时间降序排列
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {//成功
            self.dataArr = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];//重新刷新
        }
        else{
            [Tip myTip:@"加载失败!"];
        }
        
        [self.activeView stopAnimating];
    }];
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

//cell向左滑动
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //点击删除事件
        [self deleteCollect:indexPath];
    }];
    
    return @[deleteAction];
}

-(void)deleteCollect:(NSIndexPath *)indexPath{//删除收藏房屋
    
    AVObject *object = self.dataArr[indexPath.section];
    
    [self.activeView startAnimating];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"删除评论成功!"];
            
            [self.dataArr removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
        }
        else{
            [Tip myTip:@"删除评论失败!"];
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
    
    static NSString *identify = @"cell";
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
       cell = [[MyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    AVObject *object = self.dataArr[indexPath.section];
    [cell setObject:object];
    
    [self.cellHeightArr addObject:@(cell.cellHeight)];//添加的是指针
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}

//每组尾部宽度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//每行估算高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

//每行实际高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellHeightArr[indexPath.section] floatValue];//取值
}

@end

