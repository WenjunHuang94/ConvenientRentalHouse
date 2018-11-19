//
//  renterInfoController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "renterInfoController.h"

//下拉菜单
#import "CFDropDownMenuView.h"
#import "CFMacro.h"
#import "UIView+CFFrame.h"

#import "renterInfoCityCell.h"//cell
#import "renterInfoCell.h"//infoCell

#import "renterReleaseController.h"//找房发布
#import "SelectCityViewController.h"//选择城市

#import "renterInfoDetailController.h"//房客详情

@interface renterInfoController()<UITableViewDelegate,UITableViewDataSource,SelectCityViewControllerDelegate,CFDropDownMenuViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画
@property (nonatomic,strong)renterInfoCityCell *cityCell;//城市Cell

/* CFDropDownMenuView */
@property (nonatomic, strong) CFDropDownMenuView *dropDownMenuView;
@property (nonatomic, strong) NSString *rentMoney;//租金
@property (nonatomic, strong) NSString *area;//面积
@property (nonatomic, strong) NSString *homeUseType;//全租、合租


@end

@implementation renterInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rentMoney = @"全部";//租金
    self.area = @"全部";//面积
    self.homeUseType = @"全部";//全租、合租
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavTitle:@"求租信息" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    [self setNavRightBtnWithTitle:nil OrImage:@[@"btn_comment"]];

    __weak renterInfoController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {//返回
            [obj.navigationController popViewControllerAnimated:YES];
        }
        
        else if (sender.tag == 11){//发布找房信息
            if ([Sington sharSington].isLogin) {
                renterReleaseController *vcr = [[renterReleaseController alloc]init];
                [obj.navigationController pushViewController:vcr animated:YES];
            }
            else{
                [Tip myTip:@"请先登录！"];
            }
            
        }
    };
    
    [self createView];//创建view
    
    // 配置CFDropDownMenuView
    self.tableView.tableHeaderView = self.dropDownMenuView;//直接用self调用即可构造下拉菜单成功
    
    [self getData];
}

#pragma mark - lazy
/* 配置CFDropDownMenuView */
- (CFDropDownMenuView *)dropDownMenuView
{
    // DEMO
    _dropDownMenuView = [[CFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, CFScreenWidth, 45)];
    
    /**
     *  stateConfigDict 属性 格式 详见CFDropDownMenuView.h文件
     */
    //    _dropDownMenuView.stateConfigDict = @{
    //                                        @"selected" : @[[UIColor redColor], @"红箭头"],
    //                                        };
    //    _dropDownMenuView.stateConfigDict = @{
    //                                        @"normal" : @[[UIColor orangeColor], @"测试黄"],
    //                                        };
    //    _dropDownMenuView.stateConfigDict = @{
    //                                         @"selected" : @[CF_Color_DefaultColor, @"天蓝箭头"],
    //                                         @"normal" : @[[UIColor orangeColor], @"橙箭头"]
    //                                         };
    // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
    _dropDownMenuView.dataSourceArr = @[
                                        @[@"全部",@"1-500", @"500-1000", @"1000-1500", @"1500以上"],
                                        @[@"全部", @"1-50㎡", @"50-100㎡", @"100-150㎡", @"150㎡以上"],
                                        @[@"全部",@"全租", @"合租"]
                                        ].mutableCopy;
    
    _dropDownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"月租", @"面积",@"租赁", nil];
    
    _dropDownMenuView.delegate = self;
    
    // 下拉列表 起始y
    
    _dropDownMenuView.startY = CGRectGetMaxY(_dropDownMenuView.frame);
    
    /**
     *  回调方式一: block
     */
    __weak typeof(self) weakSelf = self;
    _dropDownMenuView.chooseConditionBlock = ^(NSString *currentTitle, NSArray *currentTitleArray){
        /**
         实际开发情况 --- 仅需要拿到currentTitle / currentTitleArray 作为参数 向服务器请求数据即可
         */
        //currentTitle对应的是当前选择的是哪一栏
        //currentTitleArray[i]]对应的是每列标题是哪一栏
        NSLog(@"%@",currentTitle);
        NSLog(@"%@    %@     %@",currentTitleArray[0],currentTitleArray[1],currentTitleArray[2]);
        
        weakSelf.rentMoney = currentTitleArray[0];//租金
        weakSelf.area = currentTitleArray[1];//面积
        weakSelf.homeUseType = currentTitleArray[2];//租房类型:全部、全租、合租
        
        [weakSelf getData];
    };
    
    return _dropDownMenuView;
    
}

//构造tableView
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
    
    [self setupRefresh];//添加上下拉刷新
    
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
    
    //AVQuery
    AVQuery *query = [AVQuery queryWithClassName:@"RenterHome"];
    
    [query whereKey:@"city" equalTo:[Sington sharSington].city];//对应所选城市
    [query orderByDescending:@"updatedAt"];//按时间降序排列
    
    //如果租金选择为全部或则没有选择,不设置查询条件，则得出所有结果
    if([self.rentMoney isEqualToString:@"全部"] || [self.rentMoney isEqualToString:@"租金"]);
    else if([self.rentMoney isEqualToString:@"1-500"]){//比较查询只适用于可比较大小的数据类型，如整型、浮点等
        [query whereKey:@"rentMoney" greaterThanOrEqualTo:@1];
        [query whereKey:@"rentMoney" lessThanOrEqualTo:@500];
    }
    else if([self.rentMoney isEqualToString:@"500-1000"]){
        [query whereKey:@"rentMoney" greaterThan:@500];
        [query whereKey:@"rentMoney" lessThanOrEqualTo:@1000];
    }
    else if([self.rentMoney isEqualToString:@"1000-1500"]){
        [query whereKey:@"rentMoney" greaterThan:@1000];
        [query whereKey:@"rentMoney" lessThanOrEqualTo:@1500];
    }
    else if([self.rentMoney isEqualToString:@"1500以上"]){
        [query whereKey:@"rentMoney" greaterThan:@1500];
    }
    
    //如果面积选择为全部或则没有选择,不设置查询条件，则得出所有结果
    if([self.area isEqualToString:@"全部"] || [self.area isEqualToString:@"面积"]);
    else if([self.area isEqualToString:@"1-50㎡"]){//比较查询只适用于可比较大小的数据类型，如整型、浮点等
        [query whereKey:@"area" greaterThanOrEqualTo:@1];
        [query whereKey:@"area" lessThanOrEqualTo:@50];
    }
    else if([self.area isEqualToString:@"50-100㎡"]){
        [query whereKey:@"area" greaterThan:@50];
        [query whereKey:@"area" lessThanOrEqualTo:@100];
    }
    else if([self.area isEqualToString:@"100-150㎡"]){
        [query whereKey:@"area" greaterThan:@100];
        [query whereKey:@"area" lessThanOrEqualTo:@150];
    }
    else if([self.area isEqualToString:@"150㎡以上"]){
        [query whereKey:@"area" greaterThan:@150];
    }
    
    //如果租房类型为全部或没有选择,不设置查询条件，则得出所有结果
    if([self.homeUseType isEqualToString:@"全部"] || [self.homeUseType isEqualToString:@"租赁"]);
    else{
        [query whereKey:@"homeUseType" equalTo:self.homeUseType];
    }
    
    
    [query includeKey:@"owner"];//包含用户
    [query includeKey:@"image"];//包含用户头像
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count +1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        self.cityCell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        if (!self.cityCell) {
            self.cityCell = [[renterInfoCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
        }
        self.cityCell.currentCityLabel.text = [Sington sharSington].city;//城市名
        self.cityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//加右箭头
        
        return self.cityCell;
    }
    
    AVObject *object = self.dataArr[indexPath.section - 1];//获取object对象
    
    renterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"renterInfoCell"];
    if (!cell) {
        cell = [[renterInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"renterInfoCell"];
    }
    [cell setObject:object];//设值
        
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//选择城市时
        SelectCityViewController *vcr = [[SelectCityViewController alloc]init];
        vcr.delegate = self;//设置城市代理
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else{
        AVObject *object = self.dataArr[indexPath.section -1];
        
        renterInfoDetailController *vcr = [[renterInfoDetailController alloc]init];
        
        vcr.object = object;//传值
        [self.navigationController pushViewController:vcr animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}

//每一栏的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
    else
        return 140;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//选择城市代理
-(void)selectCity:(SelectCityViewController *)vcr AndCityName:(NSString *)name{
    self.rentMoney = @"全部";//租金
    self.area = @"全部";//租金
    self.homeUseType = @"全部";//租房类型:全租、合租
    [self getData];//更新城市数据
    
}


@end
