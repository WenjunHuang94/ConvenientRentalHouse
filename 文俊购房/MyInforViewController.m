//
//  MyInforViewController.m
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MyInforViewController.h"
#import "Sington.h"

#import "ModifyNameController.h"

@interface MyInforViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ModifyNameControllerDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *bottonview;
@property (nonatomic,assign)int flag;//头像功能选择

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

//当登录后，若点击用户
@implementation MyInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flag = 0;
    
    //隐藏底部tabbar
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    
    [self setNavTitle:@"我的详情" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    self.navigationController.navigationBarHidden = NO;
    
    __weak MyInforViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        
        if (sender.tag == 1) {//点击返回按钮时
            //显示底部导航栏
            obj.navigationController.navigationBarHidden = YES;
            [obj.tabBarController setHidesBottomBarWhenPushed:NO];
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
}

-(void)createView{
    
    CGFloat tableviewX = 0;
    CGFloat tableviewY = 0;
    CGFloat tableviewW = self.view.frame.size.width;
    CGFloat tableviewH = self.view.frame.size.height;
    self.tableview = [[UITableView alloc]initWithFrame:(CGRect){tableviewX,tableviewY,tableviewW,tableviewH} style:UITableViewStylePlain];
    
    //将背景色彩设为灰色，为了显示出底部选则框的颜色
    self.tableview.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        CGFloat mybtnW = 80;
        _mybtn = [[UIButton alloc]initWithFrame:(CGRect){self.view.frame.size.width - mybtnW - 40,10,mybtnW,mybtnW}];
        [_mybtn setImage:[Sington sharSington].img forState:UIControlStateNormal];
        [_mybtn addTarget:self action:@selector(selectImg) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//加向右的箭头
        [cell addSubview:_mybtn];
        
    }
    else if(indexPath.row == 1){
        AVUser *currentUser = [AVUser currentUser];
        cell.textLabel.text = @"真实姓名";
        cell.detailTextLabel.text = currentUser.username;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//加向右的箭头
    }
    else if (indexPath.row == 2){
        AVUser *currentUser = [AVUser currentUser];
        cell.textLabel.text = @"手机号码";
        cell.detailTextLabel.text = currentUser.mobilePhoneNumber;
    }
    else if (indexPath.row == 3){
        AVUser *currentUser = [AVUser currentUser];
        cell.textLabel.text = @"所在城市";
        cell.detailTextLabel.text = [currentUser objectForKey:@"city"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
    
    if (indexPath.row == 1) {
        ModifyNameController *vcr = [[ModifyNameController alloc]init];
        vcr.delegate = self;
        [self.navigationController pushViewController:vcr animated:YES];
    }
}

//更新名字
-(void)ModifyName:(ModifyNameController *)vcr{
    [self.tableview reloadData];
}

//设置头像时操作选项,拍照、图片库、取消
-(void)selectImg{
    if (self.flag == 1) {//禁止出次出现选项框
        return;
    }
    self.flag = 1;
    
    CGFloat laW = 300;
    CGFloat laH = 170;
    CGFloat laX = (self.view.frame.size.width - laW) / 2;
    CGFloat laY = self.view.frame.size.height - laH;
    
    _bottonview = [[UIView alloc]initWithFrame:(CGRect){laX,self.view.frame.size.height,laW,laH}];
    [self.view addSubview:_bottonview];
    
    UIButton *camerabtn = [[UIButton alloc]initWithFrame:(CGRect){0,0,laW,50}];
    [camerabtn setTitle:@"拍照" forState:UIControlStateNormal];
    [camerabtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    camerabtn.backgroundColor = [UIColor whiteColor];
    [camerabtn addTarget:self action:@selector(caramaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottonview addSubview:camerabtn];
    
    UIButton *photobtn = [[UIButton alloc]initWithFrame:(CGRect){0,51,laW,50}];
    [photobtn setTitle:@"选择照片" forState:UIControlStateNormal];
    [photobtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    photobtn.backgroundColor = [UIColor whiteColor];
    [photobtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottonview addSubview:photobtn];
    
    UIButton *canclebtn = [[UIButton alloc]initWithFrame:(CGRect){0,110,laW,50}];
    [canclebtn setTitle:@"取消" forState:UIControlStateNormal];
    [canclebtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    canclebtn.backgroundColor = [UIColor whiteColor];
    [canclebtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottonview addSubview:canclebtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        _bottonview.frame = CGRectMake(laX,laY, laW, laH);
    }];

}

//点击相机按钮时
-(void)caramaBtnClick{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;//拍照
    [self presentViewController:imagePick animated:YES completion:nil];
    [self cancleBtnClick];
}

-(void)photoBtnClick{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//相册
    [self presentViewController:imagePick animated:YES completion:nil];
    [self cancleBtnClick];
}

-(void)cancleBtnClick{
    self.flag = 0;
    
    CGFloat laW = 300;
    CGFloat laX = (self.view.frame.size.width - laW) / 2;
    CGFloat laH = 170;
    [UIView animateWithDuration:0.5 animations:^{
        _bottonview.frame = CGRectMake(laX,self.view.frame.size.height, laW, laH);
    }];
}

//头像选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [_mybtn setImage:info[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    
    
    AVUser *currentUser = [AVUser currentUser];//获取当前用户信息
    
    NSData *data = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.0);//压缩头像,0.0是最大压缩
    
    AVFile *file = [AVFile fileWithData:data];
    [currentUser setObject:file forKey:@"image"];
    
    [self.activeView startAnimating];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"保存图片成功！"];
            [Sington sharSington].img = info[UIImagePickerControllerOriginalImage];
        }else{
            [Tip myTip:@"保存图片失败！"];
        }
        
        [self.activeView stopAnimating];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
