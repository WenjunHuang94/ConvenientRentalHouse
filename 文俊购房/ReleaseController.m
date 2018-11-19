//
//  ReleaseController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ReleaseController.h"

#import "Cell.h"//城市、小区、详细地址等
#import "SecondCell.h"//房型等
#import "ThirdCell.h"//面积等cell格式

#import "SelectCityViewController.h"//选择城市
#import "HomeInfoController.h"//房屋信息

#import "EquipmentCell.h"//房源配置

@interface ReleaseController ()<UITableViewDelegate,UITableViewDataSource,SelectCityViewControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *bottomview;//底部
@property (nonatomic,strong) UIView *useBottomView;//底部

@property (nonatomic,strong) Cell *cityCell;//城市
@property (nonatomic,strong) Cell *districtCell;//区域
@property (nonatomic,strong) Cell *homeNameCell;//房名
@property (nonatomic,strong) Cell *AreaDetailCell;//详细地址


@property (nonatomic,strong) SecondCell *HomeTypeCell;//房型
@property (nonatomic,strong) ThirdCell *areaCell;//面积
@property (nonatomic,strong) Cell *floorCell;//楼层

@property (nonatomic,strong) ThirdCell *rentMoneyCell;//租金
@property (nonatomic,strong) Cell *homeEquipmentCell;//装修
@property (nonatomic,strong) Cell *homeUseTypeCell;//类型

@property (nonatomic,strong) EquipmentCell *homeEquipCell;//房源描述

@end

@implementation ReleaseController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题
    [self setNavTitle:@"租房发布" AndImg:nil];
    
    [self createView];
    
    //HomeInfoController *str = [[HomeInfoController alloc]init];
    //[self.navigationController pushViewController:str animated:YES];
}

-(void)createView{
    
    //tableView
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
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//滚动tableView收起键盘
    
    //tableFooterView
    UIView *nextView = [[UIView alloc]initWithFrame:(CGRect){0,0,k_w,50}];
    [self.view addSubview:nextView];
    nextView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = nextView;
    
    //下一题
    UIButton *nextBtn = [UIButton new];
    [nextView addSubview:nextBtn];
    [nextBtn setBackgroundColor:RGB(255, 28, 86)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nextView).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.bottom.mas_equalTo(nextView).offset(-10);
    }];
    
    [self selectFun:@"毛坯" SetStr2:@"非毛坯"];//跳出选项栏
    [self selectUseTypeFun:@"全租" SetStr2:@"合租"];//跳出选项栏
  
}

//点击下一步
-(void)nextBtnClick{
    
    if ([self check]) {//检查
        HomeInfoController *str = [[HomeInfoController alloc]init];
        
        str.city = self.cityCell.tipField.text;//城市
        str.district = self.districtCell.tipField.text;//小区
        str.homeName = self.homeNameCell.tipField.text;//房名
        str.areaDetail = self.AreaDetailCell.tipField.text;//面积
        
        //房型
        NSString *homeType = [NSString stringWithFormat:@"%@房%@厅%@卫",self.HomeTypeCell.roomField.text,self.HomeTypeCell.hallField.text,self.HomeTypeCell.toiletField.text];
        str.homeType = homeType;
        
        str.area = self.areaCell.contentField.text;//面积
        str.floor = self.floorCell.tipField.text;//楼层
        
        str.rentMoney = self.rentMoneyCell.contentField.text;//租金
        
        str.homeEquipment = self.homeEquipmentCell.tipField.text;//装修
        str.homeUseType = self.homeUseTypeCell.tipField.text;//类型
        
        UIButton *airConditioner = [self.homeEquipCell viewWithTag:1];//空调
        if (airConditioner.selected) {
            str.airConditioner = @"1";
        }
        
        UIButton *parking = [self.homeEquipCell viewWithTag:2];//免费停车
        if (parking.selected) {
            str.parking = @"1";
        }
        
        UIButton *wifi = [self.homeEquipCell viewWithTag:3];//WIFI
        if (wifi.selected) {
            str.wifi = @"1";
        }
        
        UIButton *wash = [self.homeEquipCell viewWithTag:4];//洗浴
        if (wash.selected) {
            str.wash = @"1";
        }
        
        [self.navigationController pushViewController:str animated:YES];
    }
}

//检查是否有空
-(BOOL)check{
    
    
    if([self.cityCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请选择城市！"];
        return false;
    }
    else if ([self.districtCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请填写小区！"];
        return false;
    }
    else if ([self.homeNameCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请填写房名！"];
        return false;
    }
    else if ([self.AreaDetailCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请填写详细地址！"];
        return false;
    }
    else if ([self.HomeTypeCell.roomField.text isEqualToString:@""] || [self.HomeTypeCell.hallField.text isEqualToString:@""] || [self.HomeTypeCell.toiletField.text isEqualToString:@""]){
        [Tip myTip:@"请填写房型！"];
        return false;
    }
    else if ([self.areaCell.contentField.text isEqualToString:@""]){
        [Tip myTip:@"请填写面积！"];
        return false;
    }
    else if ([self.floorCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请填写楼层！"];
        return false;
    }
    else if ([self.rentMoneyCell.contentField.text isEqualToString:@""]){
        [Tip myTip:@"请填写租金！"];
        return false;
    }
    else if ([self.homeEquipmentCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请选择装修！"];
        return false;
    }
    else if ([self.homeUseTypeCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请选择类型！"];
        return false;
    }
    
    //判断是否登录
    if (![Sington sharSington].isLogin) {
        [Tip myTip:@"请先登录！"];
        return false;
    }
    
    return true;
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    if (section == 2) {
        return 1;
    }
    else if (section == 3){
        return 2;
    }

    else if (section == 4){
        return 1;
    }
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //城市
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        //复用
        self.cityCell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];//此句为复用代码
        
        if (!self.cityCell) {
            self.cityCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
        }
        
        self.cityCell.contntLabel.text = @"城市";
        self.cityCell.tipField.placeholder = @"请选择城市";
        self.cityCell.tipField.enabled = NO;
        self.cityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//加右箭头
        return self.cityCell;
    }
    
    //小区
    else if ((indexPath.section == 0) && (indexPath.row == 1)) {
        self.districtCell = [tableView dequeueReusableCellWithIdentifier:@"districtCell"];//此句为复用代码
        if (!self.districtCell) {
             self.districtCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"districtCell"];
        }
       
        
        self.districtCell.contntLabel.text = @"区域";
        self.districtCell.tipField.placeholder = @"例：雨花(区)";
        return self.districtCell;
    }
    
    //房名
    else if ((indexPath.section == 0) && (indexPath.row == 2)) {
        self.homeNameCell = [tableView dequeueReusableCellWithIdentifier:@"homeNameCell"];//此句为复用代码
        if (!self.homeNameCell) {
            self.homeNameCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeNameCell"];
        }
        
        
        self.homeNameCell.contntLabel.text = @"房名";
        self.homeNameCell.tipField.placeholder = @"例：南城印象";
        return self.homeNameCell;
    }
    
    //详细地址
    else if ((indexPath.section == 0) && (indexPath.row == 3)) {
        self.AreaDetailCell = [tableView dequeueReusableCellWithIdentifier:@"AreaDetailCell"];//此句为复用代码
        if (!self.AreaDetailCell) {
            self.AreaDetailCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AreaDetailCell"];
        }
        
        self.AreaDetailCell.contntLabel.text = @"详细地址";
        self.AreaDetailCell.tipField.placeholder = @"例：雨花路洞井路43号";
        return self.AreaDetailCell;
    }
    
    //房型
    else if ((indexPath.section == 1) && (indexPath.row == 0)) {
        self.HomeTypeCell = [tableView dequeueReusableCellWithIdentifier:@"HomeTypeCell"];//此句为复用代码
        if (!self.HomeTypeCell) {
            self.HomeTypeCell = [[SecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTypeCell"];
        }
        
        
        self.HomeTypeCell.contntLabel.text = @"房型";
        self.HomeTypeCell.roomLabel.text = @"房";
        self.HomeTypeCell.hallLabel.text = @"厅";
        self.HomeTypeCell.toiletLabel.text = @"卫";
        
        return self.HomeTypeCell;
    }
    
    //面积
    else if ((indexPath.section == 1) && (indexPath.row == 1)) {
        self.areaCell = [tableView dequeueReusableCellWithIdentifier:@"areaCell"];//此句为复用代码
        if (!self.areaCell) {
            self.areaCell = [[ThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"areaCell"];
        }
        
        self.areaCell.contntLabel.text = @"面积";
        self.areaCell.contentField.placeholder = @"例：110(㎡)";
        self.areaCell.identifyLabel.text = @"㎡";
        return self.areaCell;
    }
    
    //楼层
    else if ((indexPath.section == 1) && (indexPath.row == 2)) {
        self.floorCell = [tableView dequeueReusableCellWithIdentifier:@"floorCell"];//此句为复用代码
        if (!self.floorCell) {
            self.floorCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"floorCell"];
        }
        
        self.floorCell.tipField.keyboardType = UIKeyboardTypeNumberPad;
        self.floorCell.contntLabel.text = @"楼层";
        self.floorCell.tipField.placeholder = @"例：3(楼)";
        return self.floorCell;
    }
    
    //租金
    else if ((indexPath.section == 2) && (indexPath.row == 0)) {
        self.rentMoneyCell = [tableView dequeueReusableCellWithIdentifier:@"rentMoneyCell"];//此句为复用代码
        if (!self.rentMoneyCell) {
          self.rentMoneyCell = [[ThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rentMoneyCell"];
        }
        
        
        self.rentMoneyCell.contntLabel.text = @"租金";
        self.rentMoneyCell.contentField.placeholder = @"例：600元/月";
       
        self.rentMoneyCell.identifyLabel.text = @"元/月";
        
        return self.rentMoneyCell;
    }
    
    //装修
    else if ((indexPath.section == 3) && (indexPath.row == 0)) {
        self.homeEquipmentCell = [tableView dequeueReusableCellWithIdentifier:@"homeEquipmentCell"];//此句为复用代码
        if (!self.homeEquipmentCell) {
            self.homeEquipmentCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeEquipmentCell"];
        }
        
        
        self.homeEquipmentCell.contntLabel.text = @"装修";
        self.homeEquipmentCell.tipField.placeholder = @"选择装修情况";
    
        self.homeEquipmentCell.tipField.enabled = NO;
        
        return self.homeEquipmentCell;
    }
    
    //类型
    else if ((indexPath.section == 3) && (indexPath.row == 1)) {
        self.homeUseTypeCell = [tableView dequeueReusableCellWithIdentifier:@"homeUseTypeCell"];//此句为复用代码
        if (!self.homeUseTypeCell) {
            self.homeUseTypeCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeUseTypeCell"];
        }
        
        
        self.homeUseTypeCell.contntLabel.text = @"租赁类型";
        self.homeUseTypeCell.tipField.placeholder = @"选择租赁类型";
        self.homeUseTypeCell.tipField.enabled = NO;
        return self.homeUseTypeCell;
    }
    
    //类型
    else if ((indexPath.section == 4) && (indexPath.row == 0)) {
        self.homeEquipCell = [tableView dequeueReusableCellWithIdentifier:@"homeEquipCell"];//此句为复用代码
        if (!self.homeEquipCell) {
            self.homeEquipCell = [[EquipmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeEquipCell"];
        }
        

        return self.homeEquipCell;
    }
    
   UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
    
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        return 90;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        SelectCityViewController *str = [[SelectCityViewController alloc]init];
        str.delegate = self;
        
        [self.navigationController pushViewController:str animated:YES];
    }
    
    else  if ((indexPath.section == 3) && (indexPath.row == 0)) { //点击装修时
        self.bottomview.hidden = NO;
    }
    
    else  if ((indexPath.section == 3) && (indexPath.row == 1)) {
        self.useBottomView.hidden = NO;
    }
    
    [self.view endEditing:YES];//结束编辑，收起键盘
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}


//获取选取的城市名
-(void)selectCity:(SelectCityViewController *)vcr AndCityName:(NSString *)name{
    self.cityCell.tipField.text = name;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return @"配套选择";
    }
    return @"";
}

//装修选择
-(void)selectFun:(NSString *)str1 SetStr2:(NSString *)str2{
    
    //底部view
    self.bottomview = [UIView new];
    [self.view addSubview:self.bottomview];
    self.bottomview.hidden = YES;
    [self.bottomview  setBackgroundColor:[UIColor grayColor]];
    
    [self.bottomview  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.bottom.mas_equalTo(self.view).with.offset(-49);
        make.height.mas_equalTo(130);
    }];
    
    
    //短信找回密码
    UIButton *phoneBtn = [UIButton new];
    [phoneBtn setTitle:str1 forState:UIControlStateNormal];
    phoneBtn.titleLabel.text = str1;
    [phoneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneBtn.backgroundColor = [UIColor whiteColor];
    [self.bottomview  addSubview:phoneBtn];
    
    phoneBtn.tag = 4;
    [phoneBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchDown];
    
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomview .mas_left).offset(1);
        make.right.mas_equalTo(self.bottomview .mas_right).offset(-1);
        make.top.mas_equalTo(self.bottomview .mas_top).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    //邮箱找回密码
    UIButton *emailBtn = [UIButton new];
    [emailBtn setTitle:str2 forState:UIControlStateNormal];
    emailBtn.titleLabel.text = str2;
    [emailBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    emailBtn.backgroundColor = [UIColor whiteColor];
    
    emailBtn.tag = 5;
    [emailBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchDown];

    [self.bottomview  addSubview:emailBtn];
    
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomview .mas_left).offset(1);
        make.right.mas_equalTo(self.bottomview .mas_right).offset(-1);
        make.top.mas_equalTo(phoneBtn.mas_bottom).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    //取消按钮
    UIButton *canceBtn = [UIButton new];
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    canceBtn.backgroundColor = [UIColor whiteColor];
    
    canceBtn.tag = 6;
    [canceBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchDown];

    [self.bottomview  addSubview:canceBtn];
    
    [canceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomview .mas_left).offset(1);
        make.right.mas_equalTo(self.bottomview .mas_right).offset(-1);
        make.top.mas_equalTo(emailBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];
}

//类型选择
-(void)selectUseTypeFun:(NSString *)str1 SetStr2:(NSString *)str2{
    
    //底部view
    self.useBottomView = [UIView new];
    [self.view addSubview:self.useBottomView];
    self.useBottomView.hidden = YES;
    
    [self.useBottomView  setBackgroundColor:[UIColor grayColor]];
    
    [self.useBottomView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.bottom.mas_equalTo(self.view).with.offset(-49);
        make.height.mas_equalTo(130);
    }];
    
    
    //短信找回密码
    UIButton *phoneBtn = [UIButton new];
    [phoneBtn setTitle:str1 forState:UIControlStateNormal];
    phoneBtn.titleLabel.text = str1;
    [phoneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneBtn.backgroundColor = [UIColor whiteColor];
    [self.useBottomView  addSubview:phoneBtn];
    
    phoneBtn.tag = 7;
    [phoneBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchDown];
    
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.useBottomView .mas_left).offset(1);
        make.right.mas_equalTo(self.useBottomView .mas_right).offset(-1);
        make.top.mas_equalTo(self.useBottomView .mas_top).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    //邮箱找回密码
    UIButton *emailBtn = [UIButton new];
    [emailBtn setTitle:str2 forState:UIControlStateNormal];
    emailBtn.titleLabel.text = str2;
    [emailBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    emailBtn.backgroundColor = [UIColor whiteColor];
    
    emailBtn.tag = 8;
    [emailBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.useBottomView  addSubview:emailBtn];
    
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.useBottomView .mas_left).offset(1);
        make.right.mas_equalTo(self.useBottomView .mas_right).offset(-1);
        make.top.mas_equalTo(phoneBtn.mas_bottom).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    //取消按钮
    UIButton *canceBtn = [UIButton new];
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    canceBtn.backgroundColor = [UIColor whiteColor];
    
    canceBtn.tag = 9;
    [canceBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.useBottomView  addSubview:canceBtn];
    
    [canceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomview .mas_left).offset(1);
        make.right.mas_equalTo(self.bottomview .mas_right).offset(-1);
        make.top.mas_equalTo(emailBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];
}

//点击事件
-(void)BtnClick:(UIButton *)btn{
    
    if (btn.tag == 4) {
        self.homeEquipmentCell.tipField.text = btn.titleLabel.text;
    }
    else if (btn.tag == 5) {
        self.homeEquipmentCell.tipField.text = btn.titleLabel.text;
    }
    
    
    if (btn.tag == 7) {
        self.homeUseTypeCell.tipField.text = btn.titleLabel.text;
    }
    else if (btn.tag == 8) {
        self.homeUseTypeCell.tipField.text = btn.titleLabel.text;
    }
   
    self.bottomview.hidden = YES;
    self.useBottomView.hidden = YES;
    
}



@end
