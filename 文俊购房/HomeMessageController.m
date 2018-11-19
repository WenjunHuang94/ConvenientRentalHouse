//
//  HomeMessageController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/30.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeMessageController.h"

#import "HomeMessageCell.h"//房屋留言cell

@interface HomeMessageController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,strong)NSMutableArray *cellHeightArr;//cell高度arr

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画
@property (nonatomic,strong)UIView *tellView; //底部电话栏

@property (nonatomic,strong)UIButton *personBtn; //户主姓名按钮
@property (nonatomic,strong)UIButton *tellBtn; //户主电话按钮

@property (nonatomic,strong)UITextField *textField;//输入框

@end

@implementation HomeMessageController

-(NSMutableArray *)cellHeightArr{//记录cell的高度
    if (!_cellHeightArr) {
        _cellHeightArr = [NSMutableArray array];
    }
    return _cellHeightArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavTitle:@"留言" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    __weak HomeMessageController *obj = self;
    self.btnClick = ^(UIButton *sender){
        
        if (sender.tag == 1) {//点击返回
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];//创建View
    [self getData];
    
}

//构造控件
-(void)createView{
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
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
    
    //底部电话栏
    _tellView = [[UIView alloc]initWithFrame:(CGRect){0,self.view.frame.size.height - 50,self.view.frame.size.width,50}];
    [self.view addSubview:_tellView];
    [_tellView setBackgroundColor:MainColor];
    
    //输入框
    _textField = [UITextField new];
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [_tellView addSubview:_textField];
    [_textField.layer setCornerRadius:5];
    _textField.delegate = self;
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_tellView.mas_left).with.offset(20);
        make.top.mas_equalTo(_tellView.mas_top).with.offset(10);
        make.bottom.mas_equalTo(_tellView.mas_bottom).with.offset(-10);
    }];
    
    //发送按钮
    UIButton *sendBtn = [UIButton new];
    [sendBtn setBackgroundColor:[UIColor orangeColor]];
    [_tellView addSubview:sendBtn];
    [sendBtn.layer setCornerRadius:5];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textField.mas_right).with.offset(10);
        make.width.mas_equalTo(60);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-10);
        make.top.mas_equalTo(_tellView.mas_top).with.offset(10);
        make.bottom.mas_equalTo(_tellView.mas_bottom).with.offset(-10);
    }];
    
    //通知,用于监听键盘位置变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)getData{//获取房屋留言数据
    
    self.dataArr = [self.object objectForKey:@"MessageArr"];
    [self.tableView reloadData];//重新刷新
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
        [self deleteFun:indexPath];
    }];
    
    return @[deleteAction];
}

-(void)deleteFun:(NSIndexPath *)indexPath{
    NSMutableArray *messageArr = [self.object objectForKey:@"MessageArr"];
    [messageArr removeObjectAtIndex:indexPath.section];
    
    [self.object setObject:messageArr forKey:@"MessageArr"];
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"删除成功!"];
            [self.tableView reloadData];
        }
        else{
            [Tip myTip:@"删除失败!"];
        }
    }];
    
}


-(void)sendBtnClick{//点击发送
    if (![Sington sharSington].isLogin) {
        [Tip myTip:@"请先登录!"];
        return ;
    }
    
    else if ([_textField.text isEqualToString:@""]) {
        [Tip myTip:@"请输入内容!"];
        return ;
    }
    
    AVUser *currentUser = [AVUser currentUser];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:now];
    
    NSMutableArray *messageArr = [self.object objectForKey:@"MessageArr"];
    if (messageArr == nil) {//注意先构造一个空数组,否则无法添加进去
        messageArr = [NSMutableArray array];
    }
    
    //留言信息
    NSDictionary *messageDic = @{@"name":currentUser.username,@"mobilePhoneNumber":currentUser.mobilePhoneNumber,@"content":_textField.text,@"date":date};
    [messageArr insertObject:messageDic atIndex:0];
    [self.object setObject:messageArr forKey:@"MessageArr"];
    
    [self.activeView startAnimating];
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"留言成功!"];
            self.textField.text = @"";
            
            [self getData];
        }
        else{
            [Tip myTip:@"留言失败!"];
        }
        
        [self.activeView stopAnimating];
    }];
    
}

#pragma mark - 键盘Frame改变时调用
-(void)keyboardFrameChange:(NSNotification *)note
{
    //频率
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘frame
    
    if (frame.origin.y == self.view.frame.size.height)//判断键盘的位置,若没有弹出键盘
    {
        // 没有弹出键盘
        [UIView animateWithDuration:durtion animations:^{
            _tellView.transform = CGAffineTransformIdentity;
        }];
    }
    else
    {
        // 弹出键盘
        // 工具条向上移动键盘的高度
        [UIView animateWithDuration:durtion animations:^{
            
            //移动位置
            _tellView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }];
    }  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"cell";
    HomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HomeMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSDictionary *dic = self.dataArr[indexPath.section];
    [cell setDic:dic];
    
    [self.cellHeightArr addObject:@(cell.cellHeight)];//添加的是指针
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellHeightArr[indexPath.section] floatValue];//取出指针对应的值
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    [self.view endEditing:YES];//结束编辑状态,收起键盘
}

@end

