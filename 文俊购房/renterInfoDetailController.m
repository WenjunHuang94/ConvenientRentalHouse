//
//  renterInfoDetailController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/15.
//  Copyright © 2017年 wj. All rights reserved.
//
#import <MessageUI/MessageUI.h>//导入MessageUI.framework,发短信

#import "renterInfoDetailController.h"

#import "HomeTableViewCell.h"//HomeDetail--Cell

#import "HomeClientCell.h"//HomeDetail--Cell

#import "renterTimeCell.h"//time-cell
#import "renterShowCell.h"//租房描述

@interface renterInfoDetailController()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIView *tellView; //底部电话栏

@property (nonatomic,strong)UIButton *personBtn; //户主姓名按钮
@property (nonatomic,strong)UIButton *tellBtn; //户主电话按钮

@property (nonatomic,assign)CGRect oldFrame; //记录原始图片尺寸
@property (nonatomic,strong)UIButton *homeImgbtn;//房源图片

@property (nonatomic,strong)UIButton *cover; //用于放大图片时，把背景变黑
@property (nonatomic,strong)HomeClientCell *homeClientCell;//租房要求

@property (nonatomic,strong)UIView *topview;//顶部view
@property (nonatomic,strong)UIButton *mybtn;//头像

@property (nonatomic,strong)UIButton *nameBtn;//用户名按钮

@end

@implementation renterInfoDetailController


-(void)viewWillAppear:(BOOL)animated{
    
    //隐藏底部导航栏
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];//左部返回按钮
    [self setNavTitle:[self.object objectForKey:@"homeName"] AndImg:nil];
    
    __weak renterInfoDetailController *obj =  self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
            [obj.tabBarController setHidesBottomBarWhenPushed:NO];
        }
    };
    
    
    [self createView];//创建各个控件
    [self setTopViewData];
}

-(void)setTopViewData{
    
    // 获取图片 url
    AVFile *file = [self.object objectForKey:@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        [self.mybtn setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    AVUser *user = [self.object objectForKey:@"owner"];
    [self.nameBtn setTitle:user.username forState:UIControlStateNormal];
}

//创建视图
-(void)createView{
    
    //tableview
    UITableView *tableview = [[UITableView alloc]initWithFrame:(CGRect){0,0,k_w,k_h} style:UITableViewStylePlain];
    [self.view addSubview:tableview];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    //顶部topview
    self.topview = [[UIView alloc]initWithFrame:(CGRect){0,0,k_w,200}];
    self.topview.backgroundColor = [UIColor colorWithRed:62 / 255.0 green:90 / 255.0 blue:131  / 255.0 alpha:1];
    
    //将顶部topview设置为tableview的头
    tableview.tableHeaderView = self.topview;
    tableview.tableHeaderView.backgroundColor = [UIColor colorWithRed:62/255.0 green:90/255.0 blue:131/255.0 alpha:1];
    
    
    //头像按钮
    CGFloat mybtnW = 100;
    CGFloat mybtnH = 100;
    CGFloat mybtnX = (k_w - mybtnW) / 2;
    CGFloat mybtnY = 30;
    self.mybtn = [[UIButton alloc]initWithFrame:(CGRect){mybtnX,mybtnY,mybtnW,mybtnH}];
    
    self.mybtn.layer.cornerRadius = mybtnW / 2;
    self.mybtn.layer.masksToBounds = YES;
    self.mybtn.backgroundColor = [UIColor colorWithRed:62/255.0 green:90/255.0 blue:131/255.0 alpha:1];
    [self.topview addSubview:self.mybtn];
    
    //登录按钮
    self.nameBtn = [[UIButton alloc]initWithFrame:(CGRect){mybtnX,CGRectGetMaxY(self.mybtn.frame),mybtnW,30}];
    self.nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topview addSubview:self.nameBtn];
  
    
    //底部电话栏
    _tellView = [[UIView alloc]initWithFrame:(CGRect){0,k_h-50,k_w,50}];
    [self.view addSubview:_tellView];
    [_tellView setBackgroundColor:[UIColor yellowColor]];
    
    //底部户主姓名按钮
    _personBtn = [[UIButton alloc]initWithFrame:(CGRect){0,0,100,50}];
    [_tellView addSubview:_personBtn];
    [_personBtn setBackgroundColor:MainColor];
    [_personBtn setTitle:@"个人电话" forState:UIControlStateNormal];
    
    //底部户主电话按钮
    _tellBtn = [[UIButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(_personBtn.frame),0,k_w - 160,50}];
    [_tellView addSubview:_tellBtn];
    [_tellBtn setTitle:[self.object objectForKey:@"phoneNumber"] forState:UIControlStateNormal];
    [_tellBtn setBackgroundColor:MainColor];
    
    [_tellBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    [_tellBtn addTarget:self action:@selector(dialPhoneNumber:) forControlEvents:UIControlEventTouchDown];
    
    //底部短信按钮
    UIButton *smsBtn = [[UIButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(_tellBtn.frame),0,k_w - CGRectGetMaxX(_tellBtn.frame),50}];
    [_tellView addSubview:smsBtn];
    [smsBtn setBackgroundColor:[UIColor orangeColor]];
    [smsBtn addTarget:self action:@selector(sendSms) forControlEvents:UIControlEventTouchDown];
    
    [smsBtn setImage:[UIImage imageNamed:@"Sms"] forState:UIControlStateNormal];//setImage方法即可
    smsBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)sendSms{//发送短信
    if(![Sington sharSington].isLogin){
        [Tip myTip:@"请先登录!"];
        return ;
    }
    
    AVUser *currentUser = [AVUser currentUser];
    NSString *bodyStr = [NSString stringWithFormat:@"用户%@对您的求租发布(%@%@%@)进行反馈，请及时进行联系！",currentUser.mobilePhoneNumber,[self.object objectForKey:@"city"],[NSString stringWithFormat:@"%@区",[self.object objectForKey:@"district"]],[self.object objectForKey:@"homeName"]];
    
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


//返回铵钮事件
-(void)returnEvent{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    
    //显示底部导航栏
    [self.tabBarController setHidesBottomBarWhenPushed:NO];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//房源名称
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
        if (!cell) {
            cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeTableViewCell"];
        }
        [cell setObject:self.object];
        
        return cell;
    }
    
    else if (indexPath.row == 1){//房源信息
        renterShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeShowCell"];
        if (!cell) {
            cell = [[renterShowCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeShowCell"];
        }
        [cell setObject:self.object];
        
        return cell;
        
    }
    
    else if (indexPath.row == 2){ //客户要求
        _homeClientCell = [tableView dequeueReusableCellWithIdentifier:@"HomeClientCell"];
        if (!_homeClientCell) {
            _homeClientCell = [[HomeClientCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeClientCell"];
        }
        [_homeClientCell setObject:self.object];
        
        return _homeClientCell;
    }
    
    else if (indexPath.row == 3){ //租期
        renterTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"renterTimeCell"];
        if (!cell) {
            cell = [[renterTimeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"renterTimeCell"];
        }
        [cell setObject:self.object];
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 60;
    }
    
    else if (indexPath.row == 1){
        
        return 100;
    }
    
    else if (indexPath.row == 2){//租户要求
        return self.homeClientCell.cellHeight;
    }
    
    else if (indexPath.row == 3){//签约日期
        
        return 100;
    }
    
    return 100;
    
}

//估算高度,这样会先创cell,最后再确定cell高度的构建。这样就可以以计算的cell高度去返回
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

@end
