//
//  RootViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "RootViewController.h"

#import "ScrollView.h"//广告轮播
#import "NormalTableViewCell.h"//房屋cell

#import "NewHomeCell.h"//最新房屋cell
#import "NewClientCell.h"//最新房客cell

#import "renterInfoDetailController.h"//最新房客详情
#import "SelectCityViewController.h"//城市选择

#import "MonenyGodViewController.h"//财神
#import "ScanViewController.h"  //扫一扫

#import "HomeDetailViewController.h"//房屋详情
#import "ShoppingController.h"//积分商城

#import "renterInfoController.h"//求租信息
#import "HomeController.h"//租房信息

#import "HomeMessageController.h"//房屋留言

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,SelectCityViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *moreview;

@property (nonatomic)BOOL morebtnFlag;
@property (nonatomic,strong)ScrollView *scoreview;
@property (nonatomic,strong)UIButton *moenyGod;
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)NSMutableArray *homeData;
@property (nonatomic,strong)UIActivityIndicatorView *activeIndicatorview;//数据加载旋转动画

@property (nonatomic,strong)NewHomeCell *homeCell;//最新房源cell
@property (nonatomic,strong)NewClientCell *ClientCell;//最新客户cell

@end

@implementation RootViewController

//房源信息数组
-(NSMutableArray *)homeData{
    if (!_homeData) {
        _homeData = [NSMutableArray array];
    }
    return _homeData;
}


-(void)viewWillAppear:(BOOL)animated{
   self.navigationController.navigationBar.barTintColor = RGB(0, 179, 90);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏信息
    [self setNavTitle:[Sington sharSington].city AndImg:[UIImage imageNamed:@"箭号-向下"]];
    [self setNavRightBtnWithTitle:nil OrImage:@[@"operation"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak RootViewController *obj = self;
    _morebtnFlag = YES;
    self.btnClick = ^(UIButton *sender){
        
        //点击中间城市按钮时
        if (sender.tag == 0) {
            __block SelectCityViewController *vcr = [[SelectCityViewController alloc]init];
            vcr.delegate = obj;//设置代理
            [obj.navigationController pushViewController:vcr animated:YES];
        }
        
        //点击右部更多按钮时
        if (sender.tag == 11) {
            //将更多选项显示
            if (_morebtnFlag == YES) {
                _morebtnFlag = NO;
                obj.moreview.hidden = NO;
            }else{
                _morebtnFlag = YES;
                obj.moreview.hidden = YES;
            }
        }
    };
    
    
    [self createTable];//创建table
    [self createView];//创建财神和功能栏等
    [self getPostHomeList];//获取数据
    [self addtimer];//添加时钟方法，让财神一直动
    
}

-(void)selectCity:(SelectCityViewController *)vcr AndCityName:(NSString *)name{
    
    [self setNavTitle:[Sington sharSington].city AndImg:[UIImage imageNamed:@"箭号-向下"]];//城市名
    [self getPostHomeList];//重新获取数据
}

//获取网络数据后再创造table
-(void)createTable{

    self.scoreview = [[ScrollView alloc]initWithFrame:(CGRect){0,0,k_w,260}];//创建广告滚动
  
    __weak RootViewController *obj = self;
    //点击功能按钮时
    self.scoreview.btnBlock = ^(UIButton *btn){
        
        if(btn.tag == 0){//点击租房信息
            HomeController *vcr = [[HomeController alloc]init];
            [obj.navigationController pushViewController:vcr animated:YES];
        }
        
        else if(btn.tag == 1){//点击求租信息
            renterInfoController *vcr = [[renterInfoController alloc]init];
            [obj.navigationController pushViewController:vcr animated:YES];
        }
        
        else if (btn.tag == 2) {//点击财神
            MonenyGodViewController *vcr = [[MonenyGodViewController alloc]init];
            [obj.navigationController pushViewController:vcr animated:YES];
        }
        
        else if (btn.tag == 3) {//点击扫一扫
            ScanViewController *vcr = [[ScanViewController alloc]init];
            [obj.navigationController pushViewController:vcr animated:YES];
        }
    };
    
    //tableview
    self.tableview = [[UITableView alloc]initWithFrame:(CGRect){0,0,k_w,k_h} style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    self.tableview.showsVerticalScrollIndicator = NO;//禁止横向移动
    [self.view addSubview:self.tableview];
    self.tableview.tableHeaderView = self.scoreview;
    [self setupRefresh];//调用上下拉刷新方法
    
    //数据加载旋转图标
    self.activeIndicatorview = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(self.view.frame.size.width - 50) / 2,(self.view.frame.size.height - 50) / 2,50,50}];
    [self.view addSubview:_activeIndicatorview];
    _activeIndicatorview.backgroundColor = [UIColor blackColor];
}

//下拉、上拉刷新
- (void)setupRefresh {
    
    //建立下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPostHomeList];//重新加载数据
        [self.scoreview getData];//更新广告数据
        [self.homeCell getData];//更新最新房源数据
        [self.ClientCell getData];//更新最新客户数据
        [self.tableview.mj_header endRefreshing];//停止下拉动画
    }];
    
    //建立上拉刷拉
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getPostHomeList];
        [self.scoreview getData];//更新广告数据
        [self.homeCell getData];//更新最新房源数据
        [self.ClientCell getData];//更新最新客户数据
        [self.tableview.mj_footer endRefreshing];
    }];
}

//创建财神和功能栏等
-(void)createView{
    
    //财神
    CGFloat moenyGodW = 60;
    self.moenyGod = [[UIButton alloc]initWithFrame:(CGRect){k_w - moenyGodW,(k_h - moenyGodW) / 2,moenyGodW,moenyGodW}];
    self.moenyGod.layer.cornerRadius = moenyGodW / 2;
    self.moenyGod.layer.masksToBounds = YES;
    
    //写动画图片要有状态
    [self.moenyGod setImage:[UIImage imageNamed:@"God_00"] forState:UIControlStateNormal];
    //添加财神点击事件
    [self.moenyGod addTarget:self action:@selector(monenyGodClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.moenyGod];
    
    //财神拖动事件
    [self pan];
    
    //功能栏
    _moreview = [[UIView alloc]initWithFrame:(CGRect){0,63,self.view.frame.size.width,50}];
    _moreview.backgroundColor = [UIColor colorWithRed:43 / 255.0 green:11 / 255.0 blue:0 / 255.0 alpha:1];
    
    _moreview.hidden = YES;//隐藏
    [self.view addSubview:_moreview];
    
    NSArray *arrlabel = @[@"扫一扫"];
    CGFloat btnW = 60;
    CGFloat btnH = 50;
    CGFloat spaceX = 20;
    CGFloat X = (k_w - arrlabel.count * btnW  - (arrlabel.count - 1)* spaceX) / 2;
    
    for (int i = 0; i < arrlabel.count; i++) {
        
        CGFloat btnX =  X + (spaceX + btnW) * i;
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){btnX,5,btnW,btnH}];
        UIImage *image = [UIImage imageNamed:arrlabel[i]];
        [btn setImage:image forState:UIControlStateNormal];
        
        NSString *title = arrlabel[i];
        [btn setTitle:title forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:12];
        btn.titleLabel.font = font;
        
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(morebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreview addSubview:btn];
        
        //设置按钮文字
        CGSize imagesize = image.size;
        CGSize titlesize = [title sizeWithFont:font constrainedToSize:(CGSize){MAXFLOAT,49}];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [btn setTitleEdgeInsets:(UIEdgeInsets){image.size.height,(btn.frame.size.width - titlesize.width) / 2 - imagesize.width,0,0}];
        [btn setImageEdgeInsets:(UIEdgeInsets){0,(btn.frame.size.width - imagesize.width) / 2,0,0}];
    }
    
}

//获取首界面网络数据信息
-(void)getPostHomeList{
    
    AVQuery *query = [AVQuery queryWithClassName:@"Home"];
    
    [query whereKey:@"city" equalTo:[NSString stringWithFormat:@"%@",[Sington sharSington].city]];//城市
    [query orderByDescending:@"updatedAt"];//按时间降序排列
    
    //查询 boolean 值时，很多开发者会错误地使用 0 和 1，正确方法为@(YES)
    [query whereKey:@"homeVerify" equalTo:@(YES)];
    query.limit = 20;//限定20条
    
    [query includeKey:@"mainImg"];//包含房屋首页图片所有信息
    [query includeKey:@"imgArr"];//包含房屋所有图片信息
    [query includeKey:@"MessageArr"];

    [self.activeIndicatorview startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Tip myTip:@"获取数据失败!"];
        }
        else{
            self.homeData = [NSMutableArray arrayWithArray:objects];
            [self.tableview reloadData];//获取数据后再刷新
        }
        
        [self.activeIndicatorview stopAnimating];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return _homeData.count + 2;
}

//tableleView每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//最新房源
        self.homeCell = [tableView dequeueReusableCellWithIdentifier:@"NewHomeCell"];
        if (!self.homeCell) {
             self.homeCell = [[NewHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewHomeCell"];
        }
        
        //点新最新房源中一,进入详情界面
        __weak RootViewController *obj = self;
        self.homeCell.collectViewBlock = ^(AVObject *object){
            AVObject *home = object;
            [Sington sharSington].homeImgArr = [home objectForKey:@"imgArr"];//房屋图片
            HomeDetailViewController *vcr = [[HomeDetailViewController alloc]init];
            vcr.object = home;//赋值AVObject
            
            [obj.navigationController pushViewController:vcr animated:YES];
        };
        
        return self.homeCell;
    }
    
    if (indexPath.section == 1) {//最新房客
        self.ClientCell = [tableView dequeueReusableCellWithIdentifier:@"NewClientCell"];
        if (!self.ClientCell) {
            self.ClientCell = [[NewClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewClientCell"];
        }
        
        //点新最新房源中一,进入详情界面
        __weak RootViewController *obj = self;
        self.ClientCell.collectViewBlock = ^(AVObject *object){
            renterInfoDetailController *vcr = [[renterInfoDetailController alloc]init];
            vcr.object = object;//传值
            [obj.navigationController pushViewController:vcr animated:YES];
        };

        return self.ClientCell;
    }
    
    //房源cell
    NormalTableViewCell *normalcell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];//这句话为复用
    if (!normalcell) {
        normalcell = [[NormalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"normalcell"];
    }
    
    AVObject *home = self.homeData[indexPath.section-2];
    [normalcell setObject:home];

    return normalcell;
    
}

//点击选择每一个房源时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 1) {
        return;
    }
    
    AVObject *home = self.homeData[indexPath.section-2];
    [Sington sharSington].homeImgArr = [home objectForKey:@"imgArr"];//房屋图片
    HomeDetailViewController *vcr = [[HomeDetailViewController alloc]init];
    vcr.object = home;//赋值AVObject
    
    [self.navigationController pushViewController:vcr animated:YES];
 
}


//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2) {
        return 30;
    }
    return 10;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"全国最新房源";
    }
    else if (section == 1) {
        return @"全国最新客户";
    }
    else if (section == 2) {
        return @"城市最新房源";
    }
    return @"";
}

//每一栏的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section == 0 || indexPat.section == 1) {
        return 180;
    }
    
    return 100;
}

//点击扫描按钮时
-(void)morebtnClick:(UIButton *)sender{
    if (sender.tag == 1) {
        ScanViewController *vcr = [[ScanViewController alloc]init];
        [self.navigationController pushViewController:vcr animated:YES];
    }
}

//点击财神
-(void)monenyGodClick{
    MonenyGodViewController *vcr = [[MonenyGodViewController alloc]init];
    [self.navigationController pushViewController:vcr animated:YES];
}

//添加时钟方法，让财神一直动
-(void)addtimer{
    _timer = [NSTimer timerWithTimeInterval:0.9 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:_timer forMode:NSRunLoopCommonModes];
}

//财神动画事件
-(void)startAnimation{
    NSArray *arr = [NSArray array];
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i <3; i++) {
        NSString *name = [NSString stringWithFormat:@"God_%02d",i];
        UIImage *image = [UIImage imageNamed:name];
        [marr addObject:image];
        
    }
    arr = marr;
    
    self.moenyGod.imageView.animationImages = arr;
    self.moenyGod.imageView.animationDuration = 3 * 0.3;
    self.moenyGod.imageView.animationRepeatCount = 1000;
    [self.moenyGod.imageView startAnimating];

}

//财神拖动事件，通过手势实现
-(void)pan{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClick:)];
    [self.moenyGod addGestureRecognizer:pan];
}

-(void)panClick:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.moenyGod];
    
    CGPoint center = self.moenyGod.center;
    //将获取到的拖动手势平移距离加上,不要用平移来实现位置变动，因为只是视图变动,center值不会改变
    center.x += point.x;
    center.y += point.y;
    self.moenyGod.center = center;
    
    [pan setTranslation:CGPointZero inView:self.moenyGod];
    
    //当拖动事件结束时，用状态来判断
    if(pan.state == UIGestureRecognizerStateEnded){
        [self panEnd];
    }
    
}

//拖动结束后，财神自动调到视图边框
-(void)panEnd{
    CGPoint center = self.moenyGod.center;
    
    if (center.x < k_w / 2) {
        center.x = self.moenyGod.frame.size.width / 2;
    }
    else if (center.x > k_w / 2){
        center.x = k_w - self.moenyGod.frame.size.width / 2;
    }
    //注意判断，X和Y分开判断用if
    //状态栏20，导航栏44
    if (center.y < 64){
        center.y = 64 + k_h / 2;
    }
    else if (center.y > k_h - 49){
        center.y = k_h - 49 - k_h / 2;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.moenyGod.center = center;
    }];
}


@end
