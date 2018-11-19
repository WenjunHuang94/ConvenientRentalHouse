//
//  HomeDetailViewController.m
//  文俊购房
//
//  Created by 俊帅 on 16/7/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <MessageUI/MessageUI.h>//发送短信

#import "HomeDetailViewController.h"
#import "HomeTableViewCell.h"

#import "HomeShowCell.h"
#import "HomeAreaCell.h"

#import "HomeDescriedCell.h"
#import "HomeEquipmentCell.h"

#import "HomeClientCell.h" //租户人群

#import "HomeMapController.h"   //房源地图

#import "HomeDetailModel.h" //房源详情模型
#import "HomeScanController.h"//房源图片浏览控制器

#import "HomeMessageController.h"//房屋留言

@interface HomeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIView *tellView; //底部电话栏

@property (nonatomic,strong)UIButton *personBtn; //户主姓名按钮
@property (nonatomic,strong)UIButton *tellBtn; //户主电话按钮

@property (nonatomic,strong)UIButton *homeImgbtn;//房源图片

@property (nonatomic,strong)UIButton *cover; //用于放大图片时，把背景变黑
@property (nonatomic,strong)HomeDetailModel *model; //房源详情模型

@property (nonatomic,assign)int collectFlag;

@property (nonatomic,strong)HomeClientCell *homeClientCell;//租户要求
@property (nonatomic,strong)HomeDescriedCell *homeDescriedCell;//房源描述

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation HomeDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [self.tabBarController setHidesBottomBarWhenPushed:YES];//隐藏底部导航栏
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];//左部返回按钮
    [self setNavTitle:[self.object objectForKey:@"homeName"] AndImg:nil];//房名
    
    //右部收藏按钮,判断是否已收藏
    AVUser *currentUser = [AVUser currentUser];
    if (![Sington sharSington].isLogin) {
        [self setNavRightBtnWithTitle:nil OrImage:@[@"heart_black"]];//未收藏
        _collectFlag = 0;
    }
    else if([currentUser objectForKey:@"collectHomeArr"] == nil){
        [self setNavRightBtnWithTitle:nil OrImage:@[@"heart_black"]];//未收藏
        _collectFlag = 0;
    }
    else if([[currentUser objectForKey:@"collectHomeArr"] indexOfObject:[self.object objectForKey:@"objectId"]]==NSNotFound){
        [self setNavRightBtnWithTitle:nil OrImage:@[@"heart_black"]];//未收藏
        _collectFlag = 0;
    }
    else{
        [self setNavRightBtnWithTitle:nil OrImage:@[@"heart_red"]];//已收藏
        _collectFlag = 1;
    }
    
    
    __weak HomeDetailViewController *obj =  self;
    self.btnClick = ^(UIButton *sender){
        
        if (sender.tag == 1) {//返回
            [obj.navigationController popViewControllerAnimated:YES];
            [obj.tabBarController setHidesBottomBarWhenPushed:NO];
        }
        
        else if (sender.tag == 11) {//收藏按钮
            if (![Sington sharSington].isLogin) {
                [Tip myTip:@"请先登录！"];
                return ;
            }
            
            else if (obj.collectFlag == 0) {//添加收藏
                AVUser *user = [AVUser currentUser];
                NSMutableArray *collectHomeArr = [user objectForKey:@"collectHomeArr"];
                
                if (collectHomeArr == nil) {//注意先构造一个空数组,否则无法添加进去
                    collectHomeArr = [NSMutableArray array];
                }
                
                [collectHomeArr insertObject:[obj.object objectForKey:@"objectId"] atIndex:0];
                [user setObject:collectHomeArr forKey:@"collectHomeArr"];
                
                [obj.activeView startAnimating];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        obj.collectFlag = 1;
                        [Tip myTip:@"收藏成功!"];
                        [obj setNavRightBtnWithTitle:nil OrImage:@[@"heart_red"]];
                    }
                    else{
                        [Tip myTip:@"收藏失败!"];
                    }
                    [obj.activeView stopAnimating];
                }];
            }
            else{//取消收藏
                obj.collectFlag = 0;
                AVUser *user = [AVUser currentUser];
                NSMutableArray *collectHomeArr = [user objectForKey:@"collectHomeArr"];
             
                for(int i = 0;i < collectHomeArr.count;i++){
                    if ([collectHomeArr[i] isEqualToString:[obj.object objectForKey:@"objectId"]]) {
                        [collectHomeArr removeObjectAtIndex:i];
                    }
                }
                
                [user setObject:collectHomeArr forKey:@"collectHomeArr"];
                [obj.activeView startAnimating];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        obj.collectFlag = 0;
                        [Tip myTip:@"取消收藏成功!"];
                        [obj setNavRightBtnWithTitle:nil OrImage:@[@"heart_black"]];
                    }
                    else{
                        [Tip myTip:@"取消收藏失败!"];
                    }
                    [obj.activeView stopAnimating];
                }];
            }
            
        }
    };
    [self createView];//创建各个控件
}

//创建视图
-(void)createView{

    //tableview
    UITableView *tableview = [[UITableView alloc]initWithFrame:(CGRect){0,0,k_w,k_h} style:UITableViewStylePlain];
    [self.view addSubview:tableview];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    //顶部图片
    _homeImgbtn = [[UIButton alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,150}];
    [_homeImgbtn addTarget:self action:@selector(HomeScan) forControlEvents:UIControlEventTouchDown];
    tableview.tableHeaderView = _homeImgbtn;
    
    // 获取图片 url
    AVFile *file = [self.object objectForKey:@"mainImg"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        //拉伸图片,并设为背景图
        [_homeImgbtn setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        
    }];
    

    
    //底部电话栏
    _tellView = [[UIView alloc]initWithFrame:(CGRect){0,self.view.frame.size.height-50,self.view.frame.size.width,50}];
    [self.view addSubview:_tellView];
    [_tellView setBackgroundColor:[UIColor yellowColor]];
    
    //底部户主姓名按钮
    _personBtn = [[UIButton alloc]initWithFrame:(CGRect){0,0,80,50}];
    [_tellView addSubview:_personBtn];
    [_personBtn setTitle:@"个人电话" forState:UIControlStateNormal];
    [_personBtn setBackgroundColor:MainColor];
    [_personBtn addTarget:self action:@selector(sendSms) forControlEvents:UIControlEventTouchDown];
    
    //底部户主电话按钮
    _tellBtn = [[UIButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(_personBtn.frame),0,130,50}];
    [_tellView addSubview:_tellBtn];
    [_tellBtn setTitle:[self.object objectForKey:@"phoneNumber"] forState:UIControlStateNormal];
    [_tellBtn setBackgroundColor:MainColor];
    [_tellBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    [_tellBtn addTarget:self action:@selector(dialPhoneNumber:) forControlEvents:UIControlEventTouchDown];
    
    //底部短信按钮
    UIButton *smsBtn = [[UIButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(_tellBtn.frame),0,60,50}];
    [_tellView addSubview:smsBtn];
    [smsBtn setBackgroundColor:[UIColor orangeColor]];
    [smsBtn addTarget:self action:@selector(sendSms) forControlEvents:UIControlEventTouchDown];
    
    [smsBtn setImage:[UIImage imageNamed:@"Sms"] forState:UIControlStateNormal];//setImage方法即可
    smsBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //底部短信按钮
    UIButton *messageBtn = [[UIButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(smsBtn.frame),0,k_w - CGRectGetMaxX(smsBtn.frame),50}];
    [_tellView addSubview:messageBtn];
    [messageBtn setBackgroundColor:[UIColor orangeColor]];
    [messageBtn addTarget:self action:@selector(scanMessage) forControlEvents:UIControlEventTouchDown];
    
    [messageBtn setImage:[UIImage imageNamed:@"留言"] forState:UIControlStateNormal];//setImage方法即可
}

//浏览图片
-(void)HomeScan{
    
    HomeScanController *vcr = [[HomeScanController alloc]init];
    vcr.object = self.object;
    [self.navigationController pushViewController:vcr animated:YES];
}

-(void)scanMessage{//查看留言
    HomeMessageController *vcr = [[HomeMessageController alloc]init];
    vcr.object = self.object;
    [self.navigationController pushViewController:vcr animated:YES];
}

-(void)sendSms{//发送短信
    if(![Sington sharSington].isLogin){
        [Tip myTip:@"请先登录!"];
        return ;
    }
    
    AVUser *currentUser = [AVUser currentUser];
    NSString *bodyStr = [NSString stringWithFormat:@"用户%@对您发布的房屋(%@%@%@)进行反馈，请及时进行联系！",currentUser.mobilePhoneNumber,[self.object objectForKey:@"city"],[NSString stringWithFormat:@"%@区",[self.object objectForKey:@"district"]],[self.object objectForKey:@"homeName"]];
    
    [self showMessageView:[NSArray arrayWithObjects:[self.object objectForKey:@"phoneNumber"], nil] title:@"便捷租房帮" body:bodyStr];
}
#pragma mark--发短信代理
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch(result){
            
        caseMessageComposeResultSent:
            
            //信息传送成功
            
            break;
            
        caseMessageComposeResultFailed:
            
            //信息传送失败
            
            break;
            
        caseMessageComposeResultCancelled:
            
            //信息被用户取消传送
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


//点击电话按钮时拨打电话
-(void)dialPhoneNumber:(UIButton *)sender{
    
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel://%@",[self.object objectForKey:@"phoneNumber"]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {//房源名称
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
        if (!cell) {
            cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeTableViewCell"];
        }
        
        [cell setObject:self.object];
        
        return cell;
     
    //房源信息
    }else if (indexPath.section == 1){
        HomeShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeShowCell"];
        if (!cell) {
            cell = [[HomeShowCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeShowCell"];
        }
        [cell setObject:self.object];
        
        return cell;
   
    }else if (indexPath.section == 2){//房源位置
        HomeAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeAreaCell"];
        if (!cell) {
            cell = [[HomeAreaCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeAreaCell"];
        }
        [cell setObject:self.object];
               
        //加向右的箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
    
    else if (indexPath.section == 3){//房源描述
        self.homeDescriedCell = [tableView dequeueReusableCellWithIdentifier:@"HomeDescriedCell"];
        if (!self.homeDescriedCell) {
            self.homeDescriedCell = [[HomeDescriedCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeDescriedCell"];
        }
        
        [self.homeDescriedCell setObject:self.object];
        
        return self.homeDescriedCell;
    }
    
    else if (indexPath.section == 4){ //房源配置
        HomeEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeEquipmentCell"];
        if (!cell) {
            cell = [[HomeEquipmentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeEquipmentCell"];
        }
        
        [cell setObject:self.object];
        return cell;
    }
    
    else if (indexPath.section == 5){ //客户要求
        _homeClientCell = [tableView dequeueReusableCellWithIdentifier:@"HomeClientCell"];
        if (!_homeClientCell) {
            _homeClientCell = [[HomeClientCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeClientCell"];
        }
        [_homeClientCell setObject:self.object];
        return _homeClientCell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
    
    else if (indexPath.section == 1){
        return 100;
    }
    
    else if (indexPath.section == 2){
        return 40;
    }
    
    else if (indexPath.section == 3){//房源描述
        return self.homeDescriedCell.cellHeight;
    }
    
    //租户要求
    else if (indexPath.section == 5){
        return _homeClientCell.cellHeight;
    }
    
    return 110;
    
}

//估算的高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


//点击房源位置一栏会跳入地图显示房源位置具体信息
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    if (indexPath.section == 2) {//点击房源位置
        HomeMapController *vcr = [[HomeMapController alloc]init];
        vcr.object = self.object;
        
        [self.navigationController pushViewController:vcr animated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
}


@end
