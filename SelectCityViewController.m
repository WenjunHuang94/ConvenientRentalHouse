//
//  SelectCityViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "SelectCityViewController.h"
#import "cityModel.h"
#import "CurrentTableViewCell.h"
#import "HotTableViewCell.h"
#import "Sington.h"

#import <CoreLocation/CoreLocation.h>

@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong)UIView *topview;
@property (nonatomic,strong)UITextField *search;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *data;

@property (nonatomic,strong)HotTableViewCell *hotcell;//热门城市
@property (nonatomic,strong)CurrentTableViewCell *currentcell;//当前城市

@property (nonatomic,strong)CLLocationManager *manager;//定位管理

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation SelectCityViewController

//定位管理
-(CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        //设置定位代理
        _manager.delegate = self;
    }
    return _manager;
}

//视图将要出现时，都进行一次定位更新
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //一直允许定位
    [self.manager requestAlwaysAuthorization];
    
    //开始定位城市，会调用代理方法
    [self.manager startUpdatingLocation];
    
}


//city.plist文件中的城市数组
-(NSArray *)data{
    if (!_data) {
        _data = [cityModel arrWithArr];
    }
    return _data;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"选择城市" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    __weak SelectCityViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        
        if (sender.tag == 1) {//返回
            [Sington sharSington].city = obj.currentcell.currentCityLabel.text;
            
            //用于注册界面选择城市
            if([obj.delegate respondsToSelector:@selector(selectCity:AndCityName:)]){
                [obj.delegate selectCity:obj AndCityName:[Sington sharSington].city];
            }
            [obj.navigationController popViewControllerAnimated:YES];
            
        }
    };
    
    [self createView];//构造view
    [self getPostCityName];//获取热门城市列表
}



//构造控件
-(void)createView{
    
    self.tableview = [[UITableView alloc]initWithFrame:(CGRect){0,0,k_w,k_h} style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.backgroundColor = [UIColor colorWithRed:251 / 255.0 green:246 / 255.0 blue:237 / 255.0 alpha:1];
    self.tableview.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableview];
    [self setupRefresh];//调用上下拉刷新方法
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}

//下拉、上拉刷新
- (void)setupRefresh {
    
    //下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPostCityName];//重新加载数据
        [self.tableview.mj_header endRefreshing];//停止下拉动画
    }];
    
    //上拉加载
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getPostCityName];
        [self.tableview.mj_footer endRefreshing];
    }];
}

//获取热门城市数据
-(void)getPostCityName{
    
    [self.activeView startAnimating];//开始加载动画
    
    AVQuery *query = [AVQuery queryWithClassName:@"HotCity"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {//成功
            [Sington sharSington].hotCityArr = objects;
            
            [self.tableview reloadData];//更新
        }
        else{
            [Tip myTip:@"热门城市加载失败！"];
        }
        
        [self.activeView stopAnimating];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count + 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    
    else{//按大写英文对应的城市分组数量
        
        cityModel *model = self.data[section - 2];
        return model.citys.count - 1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//当前城市
        
        self.currentcell = [tableView dequeueReusableCellWithIdentifier:@"currentcell"];
        if (!self.currentcell) {
            self.currentcell = [[CurrentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"currentcell"];
        }
        self.currentcell.currentCityLabel.text = [Sington sharSington].city;
        
        return self.currentcell;
    }
    
    else if (indexPath.section == 1){//热门城市列表
        self.hotcell =  [[HotTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"hotcell"];
        
        __weak SelectCityViewController *obj = self;
        self.hotcell.myblock = ^(UIButton *sender){
            //将选中的城市名显示在当前城市上
            obj.currentcell.currentCityLabel.text = sender.titleLabel.text;
            [obj.manager stopUpdatingLocation];//停止定位
        };

        return self.hotcell;
    }
    
    else{//全国城市
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        //对应组数
        cityModel *city = self.data[indexPath.section - 2];
        //对应列数
        NSString *str = city.citys[indexPath.row + 1];
        cell.textLabel.text = str;
        
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return @"GPS";
    }
    
    else if (section == 1)
        return @"热门城市";
    
    else
    {
        cityModel *city = self.data[section - 2];
        return city.citys[0];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
   else if (indexPath.section == 1)
       return 50 + ([Sington sharSington].hotCityArr.count / 3) * 60;
   else
       return 50;
}

//显示城市A-Z字母
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
        NSMutableArray *marr = [NSMutableArray array];
        [marr addObject:@""];
        [marr addObject:@""];
        for (int i = 0;i < self.data.count;i++) {
            cityModel *city = self.data[i];
            NSString *str = city.citys[0];
            [marr addObject:str];
        }
        return marr;
}

//更新定位信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //获取定位经纬度
    CLLocation *locain = [locations lastObject];
    
    
    //将经纬度返编码成地名
    [self reversegeocode:locain];
    
    [self.manager stopUpdatingLocation];
}

//反编码，将获取到的地理经纬度反编码成地名
-(void)reversegeocode:(CLLocation *)locain{
    CLGeocoder *geog = [[CLGeocoder alloc]init];
    [geog reverseGeocodeLocation:locain completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *pl in placemarks) {
            
            //将定位到的城市更新到当前城市上
            NSString *cityName = [pl.locality substringToIndex:pl.locality.length - 1];
            self.currentcell.currentCityLabel.text = cityName;
            [Sington sharSington].city = cityName;
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.manager stopUpdatingLocation];//停止定位
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    if (indexPath.section == 0) {
        return;
    }else if (indexPath.section == 1)
        return;
    
    //选中cell时将当前城市赋值
    cityModel *model = self.data[indexPath.section - 2];
    NSString *str = model.citys[indexPath.row + 1];
    
    NSInteger len = str.length;//最后一个为市字直接去掉
    if ([[str substringFromIndex:len-1] isEqualToString:@"市"]) {
        str = [str substringWithRange:(NSRange){0,len-1}];
    }
    
    self.currentcell.currentCityLabel.text = str;
    
    
}

@end
