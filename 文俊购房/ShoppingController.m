//
//  ShoppingController.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/17.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ShoppingController.h"
#import "ShoppingTopView.h"

#import "ShoppingCell.h"

@interface ShoppingController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)ShoppingTopView *topView;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation ShoppingController

-(void)viewWillAppear:(BOOL)animated{
    
    if([Sington sharSington].isLogin){//若已登录
        AVUser *user = [AVUser currentUser];
        
        self.topView.score.text = [user objectForKey:@"score"];//显示积分
        NSDate *now = [NSDate date];//系统时间
        
        //按日期格式比较
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *signDate = [dateFormatter stringFromDate:[user objectForKey:@"signDate"]];
        NSString *nowDate = [dateFormatter stringFromDate:now];
    
        if ([signDate isEqualToString:nowDate]) {
            [self.topView.registerBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
        }
        else{
            [self.topView.registerBtn setTitle:@"今日未签到" forState:UIControlStateNormal];
        }
        
    }
    else{
        self.topView.score.text = @"未登录";
        [self.topView.registerBtn setTitle:@"今日未签到" forState:UIControlStateNormal];
    }
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
   
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavTitle:@"积分商城" AndImg:nil];

    [self createView];//添加控件
    [self getData];//获取数据
}

//获取数据
-(void)getData{
    //获取数据
    AVQuery *query = [AVQuery queryWithClassName:@"ShoppingStore"];
    [query includeKey:@"image"];
    [query orderByDescending:@"updatedAt"];
    
    [self.activeView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.data = objects;
            [self.tableView reloadData];//更新数据
        }
        
        else{
            [Tip myTip:@"加载失败!"];
        }
        
        [self.activeView stopAnimating];
    }];
 
}

//创造控件
-(void)createView{
    
    //topView
    self.topView = [[ShoppingTopView alloc]initWithFrame:(CGRect){0,0,k_w,120}];
    
    __weak ShoppingTopView *shopView = self.topView;
    self.topView.registerBlock = ^(){//点击topView中签到按钮时
        if([Sington sharSington].isLogin)//已登录
        {
            AVUser *user = [AVUser currentUser];
            
            NSDate *now = [NSDate date];//系统时间
            
            //按日期格式比较
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSString *signDate = [dateFormatter stringFromDate:[user objectForKey:@"signDate"]];
            NSString *nowDate = [dateFormatter stringFromDate:now];
            
            if ([signDate isEqualToString:nowDate]) {
                [Tip myTip:@"您已签到过!"];
            }
            
            else{//未签到过，进行签到
                NSInteger currentScore = [[user objectForKey:@"score"] integerValue] + 20;//加20积分
                NSString *score = [NSString stringWithFormat:@"%d",currentScore];//转为Str
                
                //更新积分到用户
                AVUser *user = [AVUser currentUser];
                [user setObject:now forKey:@"signDate"];
                [user setObject:score forKey:@"score"];
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                    if (succeeded) {
                        [shopView.registerBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
                        shopView.score.text = score;
                        [Tip myTip:@"签到成功！"];
                        
                    }
                    else{
                        [Tip myTip:@"签到失败！"];
                    }
                }];

            }

        }
        else{//未登录
            [Tip myTip:@"请先登录！"];
        }
        
    };
    
    //tableView
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(0);
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
        make.bottom.mas_equalTo(self.view).with.offset(-10);
    }];
    
    //设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableHeaderView = self.topView;
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

//设置每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ShoppingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    AVObject *object = self.data[indexPath.row];
    
    //通告图片
    AVFile *file = [object objectForKey:@"image"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        UIImage *img = [UIImage imageWithData:data];//NSData转化为图片
        cell.imgView.image = img;
    }];
   
    cell.shopingName.text = [object objectForKey:@"name"];
    cell.shopingScore.text = [NSString stringWithFormat:@"兑换积分:%@",[object objectForKey:@"score"]];
    
    //点击兑换按钮时
    cell.buy = ^(){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否兑换该商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.alertViewStyle = UIAlertViewStyleDefault;
        [aler show];
        aler.tag = indexPath.row;
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}

//设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

//点击警告选项卡时，处理事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //alertView.tag来区分不同警告栏，buttonIndex来区分所选项
    if(buttonIndex == 1){//点击确定时
        if (![Sington sharSington].isLogin) {
            [Tip myTip:@"请先登录!"];
            return;
        }
 
        AVObject *object = self.data[alertView.tag];//对应商品
        NSInteger score = [[object objectForKey:@"score"] integerValue];//点击的兑换的商品积分
        
        if ([self.topView.score.text integerValue] >= score) {//当积分足够时
            
            NSInteger result = [self.topView.score.text integerValue] - score;
            NSString  *currentScore = [NSString stringWithFormat:@"%d",result];
            
            AVUser *user = [AVUser currentUser];//更新积分到用户
            [user setObject:currentScore forKey:@"score"];
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    
                    AVObject *exchange = [AVObject objectWithClassName:@"ShoppingExchange"];
                    [exchange setObject:[Sington sharSington].tell forKey:@"phoneNumber"];
                    [exchange setObject:[object objectForKey:@"name"] forKey:@"shoppingName"];
                    [exchange saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        if (succeeded) {
                            self.topView.score.text = currentScore;
                            [Tip myTip:@"兑换成功!"];
                        }else{
                            [Tip myTip:@"兑换失败!"];
                        }
                    }];
                }
            }];
        }
        
        else{//积分不足时
            [Tip myTip:@"您的当前积分不足!"];
        }
        
    }
    
}


@end
