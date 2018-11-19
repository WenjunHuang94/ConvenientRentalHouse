//
//  renterReleaseController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "renterReleaseController.h"

#import "Cell.h"//城市、小区、详细地址等,在租房发布里
#import "SecondCell.h"//房型等，在租房发布里
#import "ThirdCell.h"

#import "DescriptionCell.h"//在房屋信息里的Cell

#import "SelectCityViewController.h"//选择城市
#import "HomeInfoController.h"//房屋信息

@interface renterReleaseController ()<UITableViewDelegate,UITableViewDataSource,SelectCityViewControllerDelegate,UITextViewDelegate>

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
@property (nonatomic,strong) Cell *timeCell;//租期
@property (nonatomic,strong) Cell *startTimeCell;//入住时间

@property (nonatomic,strong) Cell *homeUseTypeCell;//类型
@property (nonatomic,strong) DescriptionCell *requestCell;//要求

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation renterReleaseController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题
    [self setNavTitle:@"找房发布" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    [self createView];
    
    __weak renterReleaseController *obj = self;
    self.btnClick = ^(UIButton *btn){
        if (btn.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
   
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
    
    //tableFooterView
    UIView *nextView = [[UIView alloc]initWithFrame:(CGRect){0,0,k_w,50}];
    [self.view addSubview:nextView];
    nextView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = nextView;
    //滚动tableView收起键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //下一题
    UIButton *nextBtn = [UIButton new];
    [nextView addSubview:nextBtn];
    [nextBtn setBackgroundColor:RGB(255, 28, 86)];
    [nextBtn setTitle:@"发布" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nextView).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.bottom.mas_equalTo(nextView).offset(-10);
    }];
    
    [self selectUseTypeFun:@"全租" SetStr2:@"合租"];//跳出选项栏
    
}

//点击下一步
-(void)finishBtnClick{
    
    if ([self check]) {//检查
        
        AVObject *home = [AVObject objectWithClassName:@"RenterHome"];
        
        AVUser *user = [AVUser currentUser];//获取当前用户
        
        //保存指针,必须先在云端数据库中自己新建pointer型列
        [home setObject:user forKey:@"owner"];//保存对应用户ID
        [home setObject:[user objectForKey:@"image"] forKey:@"image"];//头像,AVFile
        
        [home setObject:self.cityCell.tipField.text forKey:@"city"];//城市
        [home setObject:self.districtCell.tipField.text forKey:@"district"];//区域
        [home setObject:self.homeNameCell.tipField.text forKey:@"homeName"];//房名
        [home setObject:self.AreaDetailCell.tipField.text forKey:@"areaDetail"];//详细地址
        
        NSString *typeStr = [NSString stringWithFormat:@"%@房%@厅%@卫",self.HomeTypeCell.roomField.text,self.HomeTypeCell.hallField.text,self.HomeTypeCell.toiletField.text];
        [home setObject:typeStr forKey:@"homeType"];//房型
        NSNumber *area = @([self.areaCell.contentField.text integerValue]);
        [home setObject:area forKey:@"area"];//面积
        [home setObject:self.floorCell.tipField.text forKey:@"floor"];//楼层
        
        //转为NSNumber
        NSNumber *rentMoney = @([self.rentMoneyCell.contentField.text integerValue]);
        [home setObject:rentMoney forKey:@"rentMoney"];//租金
        [home setObject:self.timeCell.tipField.text forKey:@"time"];//租期
        [home setObject:self.startTimeCell.tipField.text forKey:@"startTime"];//入住时间
        
        [home setObject:self.homeUseTypeCell.tipField.text forKey:@"homeUseType"];//类型
        
        [home setObject:[Sington sharSington].tell forKey:@"phoneNumber"];//手机号码
        [home setObject:self.requestCell.inputView.text forKey:@"require"];//要求
        
        [self.activeView startAnimating];//开始动画
        [home saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [Tip myTip:@"发布成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Tip myTip:@"发布失败！"];
            }
            
            [self.activeView stopAnimating];
        }];

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
    else if ([self.timeCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请填写租期！"];
        return false;
    }
    else if ([self.startTimeCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请填写入住时间！"];
        return false;
    }
    else if ([self.homeUseTypeCell.tipField.text isEqualToString:@""]){
        [Tip myTip:@"请选择类型！"];
        return false;
    }
    
    else if ([self.requestCell.inputView.text isEqualToString:@""]){
        [Tip myTip:@"请输入您对房屋的需求！"];
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
        return 3;
    }
    else if (section == 3){
        return 1;
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
    return 15;
}

//Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //城市
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        self.cityCell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];//此句为复用代码
        
        if (!self.cityCell) {
            self.cityCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
            //设置标识符
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
        self.HomeTypeCell.roomField.placeholder = @"例：3房1厅1卫";
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
    //租期
    else if ((indexPath.section == 2) && (indexPath.row == 1)) {
        self.timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];//此句为复用代码
        if (!self.timeCell) {
            self.timeCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
        }
        
        
        self.timeCell.contntLabel.text = @"租期";
        self.timeCell.tipField.placeholder = @"例:一年";
        return self.timeCell;
    }
    
    //入住时间
    else if ((indexPath.section == 2) && (indexPath.row == 2)) {
        self.startTimeCell = [tableView dequeueReusableCellWithIdentifier:@"startTimeCell"];//此句为复用代码
        if (!self.startTimeCell) {
            self.startTimeCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startTimeCell"];
        }
        
        
        self.startTimeCell.contntLabel.text = @"入住时间";
        self.startTimeCell.tipField.placeholder = @"例:随时起住";
        return self.startTimeCell;
    }
    
    //类型
    else if ((indexPath.section == 3) && (indexPath.row == 0)) {
        self.homeUseTypeCell = [tableView dequeueReusableCellWithIdentifier:@"homeUseTypeCell"];//此句为复用代码
        if (!self.homeUseTypeCell) {
            self.homeUseTypeCell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeUseTypeCell"];
        }
        
        
        self.homeUseTypeCell.contntLabel.text = @"租赁类型";
        self.homeUseTypeCell.tipField.placeholder = @"选择租赁类型";
        self.homeUseTypeCell.tipField.enabled = NO;
        return self.homeUseTypeCell;
    }
    
    else if (indexPath.section == 4){
        self.requestCell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
        if (!self.requestCell) {
            self.requestCell = [[DescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestCell"];
        }
        
        self.requestCell.inputView.delegate = self;
        return self.requestCell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

//编辑时上移键盘
-(void)textViewDidBeginEditing:(UITextView *)textView{
   
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -216);//移动位置
    }];

}

//编辑结束时收回键盘
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    self.tableView.transform = CGAffineTransformIdentity;
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        return 150;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 0) && (indexPath.row == 0)) {//城市
        SelectCityViewController *str = [[SelectCityViewController alloc]init];
        str.delegate = self;
        
        [self.navigationController pushViewController:str animated:YES];
    }
    
    
    else  if ((indexPath.section == 3) && (indexPath.row == 0)) {
        self.useBottomView.hidden = NO;
    }
    
    [self.view endEditing:YES];//结束编辑，收起键盘
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return @"请描述您租房的需求:";
    }
    return @"";
}

//获取选取的城市名
-(void)selectCity:(SelectCityViewController *)vcr AndCityName:(NSString *)name{
    self.cityCell.tipField.text = name;
    
}


//类型选择
-(void)selectUseTypeFun:(NSString *)str1 SetStr2:(NSString *)str2{
    
    //底部view
    self.useBottomView = [UIView new];
    [self.view addSubview:self.useBottomView];
    self.useBottomView.hidden = YES;
    
    [self.useBottomView  setBackgroundColor:[UIColor grayColor]];
    
    [self.useBottomView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(50);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-50);
        make.bottom.mas_equalTo(self.view).with.offset(-49);
        make.height.mas_equalTo(140);
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
        make.left.mas_equalTo(self.useBottomView .mas_left).offset(10);
        make.right.mas_equalTo(self.useBottomView .mas_right).offset(-10);
        make.top.mas_equalTo(self.useBottomView .mas_top).offset(5);
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
        make.left.mas_equalTo(self.useBottomView .mas_left).offset(10);
        make.right.mas_equalTo(self.useBottomView .mas_right).offset(-10);
        make.top.mas_equalTo(phoneBtn.mas_bottom).offset(5);
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
        make.left.mas_equalTo(self.useBottomView .mas_left).offset(10);
        make.right.mas_equalTo(self.useBottomView .mas_right).offset(-10);
        make.top.mas_equalTo(emailBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];
}

//点击事件
-(void)BtnClick:(UIButton *)btn{
    
    
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