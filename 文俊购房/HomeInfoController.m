//
//  HomeInfoController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/10.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeInfoController.h"

#import "CameraCell.h"//选择照片
#import "DescriptionCell.h"//房屋描述

#import "SGImagePickerController.h" // 自定义照片控制器

@interface HomeInfoController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *imgArr;//相片数组

@property (nonatomic,strong)CameraCell *cameraCell;//相机cell
@property (nonatomic,strong)DescriptionCell *descripteCell;//房屋描述
@property (nonatomic,strong)DescriptionCell *requireCell;//租户要求

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation HomeInfoController

//相片数组构造
-(NSArray *)imgArr{
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题
    [self setNavTitle:@"房屋信息" AndImg:nil];
    
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    __weak HomeInfoController *obj = self;
    self.btnClick = ^(UIButton *btn){
        if (btn.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
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
    
    //滚动tableView收起键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //tableFooterView
    UIView *nextView = [[UIView alloc]initWithFrame:(CGRect){0,0,k_w,50}];
    [self.view addSubview:nextView];
    nextView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = nextView;
    
    //发布
    UIButton *finishBtn = [UIButton new];
    [nextView addSubview:finishBtn];
    [finishBtn setBackgroundColor:RGB(255, 28, 86)];
    [finishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nextView).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.bottom.mas_equalTo(nextView).offset(-10);
    }];
  
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
    
    //通知,用于监听键盘位置变化
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//编辑时上移键盘
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -180);//移动位置
    }];
    
}

//编辑结束时收回键盘
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    self.tableView.transform = CGAffineTransformIdentity;
}

//#pragma mark - 键盘Frame改变时调用
//-(void)keyboardFrameChange:(NSNotification *)note
//{
//    //频率
//    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘frame
//    
//    if (frame.origin.y == self.view.frame.size.height)//判断键盘的位置,若没有弹出键盘
//    {
//        // 没有弹出键盘
//        [UIView animateWithDuration:durtion animations:^{
//            self.tableView.transform = CGAffineTransformIdentity;
//        }];
//    }
//    else
//    {
//        // 弹出键盘
//        // 工具条向上移动键盘的高度
//        [UIView animateWithDuration:durtion animations:^{
//            
//            //移动位置
//            self.tableView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
//        }];
//    }
//}

//发布点击
-(void)finishBtnClick{
    
    if([self check]){
        
        AVObject *home = [AVObject objectWithClassName:@"Home"];
        
        AVUser *user = [AVUser currentUser];//获取当前用户
        [home setObject:user forKey:@"owner"];//保存对应用户ID,必须先提前设定owner字段为pointer,注意存的是user,而不是user.objectID,这是NSString
        
        [home setObject:self.city forKey:@"city"];//城市
        [home setObject:self.district forKey:@"district"];//区域
        [home setObject:self.homeName forKey:@"homeName"];//房名
        [home setObject:self.areaDetail forKey:@"areaDetail"];//详细地址
        [home setObject:self.homeType forKey:@"homeType"];//房型
        
        //转为NSNumber
        NSNumber *area = @([self.area integerValue]);
        [home setObject:area  forKey:@"area"];//面积
        
        [home setObject:self.floor forKey:@"floor"];//楼层
        
        //转为NSNumber
        NSNumber *rentMoney = @([self.rentMoney integerValue]);
        [home setObject:rentMoney forKey:@"rentMoney"];//租金
        
        [home setObject:self.homeEquipment forKey:@"homeEquipment"];//装修
        [home setObject:self.homeUseType forKey:@"homeUseType"];//类型
        
        //房屋配置
        [home setObject:self.airConditioner forKey:@"airConditioner"];//是否有空调
        [home setObject:self.parking forKey:@"parking"];//是否有空调
        [home setObject:self.wifi forKey:@"wifi"];//是否有空调
        [home setObject:self.wash forKey:@"wash"];//是否有空调

        //房屋图片
        NSMutableArray *homeImgArr = [NSMutableArray array];//注意先构造一个空数组,否则无法添加进去
        for (UIImage *img in self.imgArr) {
            NSData *data = UIImageJPEGRepresentation(img, 0.0);//压缩头像,0.0是最大压缩
            AVFile *file = [AVFile fileWithData:data];
            [homeImgArr addObject:file];
        }
        
        [home setObject:homeImgArr[0] forKey:@"mainImg"];//第一张图
        [home setObject:homeImgArr forKey:@"imgArr"];//所有图片
        
        [home setObject:self.descripteCell.inputView.text forKey:@"description"];//房屋描述
        [home setObject:self.requireCell.inputView.text forKey:@"require"];//租房要求
        [home setObject:user.mobilePhoneNumber forKey:@"phoneNumber"];//租户号码
        [home setObject:false forKey:@"homeVerify"];//房屋是否验证通过
        
        [self.activeView startAnimating];//开始动画
        [home saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [Tip myTip:@"发布成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Tip myTip:@"发布失败！"];
            }
            self.navigationController.navigationBar.barTintColor = RGB(0, 179, 90);
            [self.activeView stopAnimating];
        }];
        
        
    }
}

//检查是否有空
-(BOOL)check{
    //照片数组
    if(self.imgArr.count == 0){
        [Tip myTip:@"请选取房屋照片！"];
        return false;
    }
    
    else if([self.descripteCell.inputView.text isEqualToString:@""]){
        [Tip myTip:@"请输入房屋描述！"];
        return false;
    }
    
    else if ([self.requireCell.inputView.text isEqualToString:@""]){
        [Tip myTip:@"请填写租房要求！"];
        return false;
    }
    
    return true;
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//上传图片
        _cameraCell = [tableView dequeueReusableCellWithIdentifier:@"CameraCell"];
        if (!_cameraCell) {
            _cameraCell = [[CameraCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CameraCell"];
        }
        
        [_cameraCell.cameraBtn addTarget:self action:@selector(showSelect) forControlEvents:UIControlEventTouchDown];//添加选取照片事件
        return _cameraCell;
    }
    
    else if (indexPath.section == 1) {//房屋描述
        _descripteCell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
        if (!_descripteCell) {
            _descripteCell = [[DescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"];
        }
        
        
        return _descripteCell;
    }
    
    //租房要求
    else if (indexPath.section == 2) {
        _requireCell = [tableView dequeueReusableCellWithIdentifier:@"requireCell"];
        if (!_requireCell) {
            _requireCell = [[DescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requireCell"];
        }
        
        _requireCell.inputView.delegate = self;
        return _requireCell;
    }
    
   
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
    
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 230;
    }
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];//点击一个cell,结束编辑，收起键盘
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中状态
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"请输入房屋描述";
    }
    else if (section == 2) {
        return @"租房要求";
    }
    return @"";
}

//选取多张图片
-(void)showSelect{
    
    SGImagePickerController *picker = [[SGImagePickerController alloc] initWithRootViewController:nil];
    [self presentViewController:picker animated:YES completion:nil];
    
    [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {//返回选择的缩略图
        NSLog(@"缩略图%@",thumbnails);
        //self.imgArr = thumbnails;
        [Tip myTip:@"选取照片成功！"];
        self.navigationController.navigationBar.barTintColor = RGB(0, 179, 90);
    }];
    
    [picker setDidFinishSelectImages:^(NSArray *images) {//返回选中的原图
        self.imgArr = images;
        [self.cameraCell.photoImgView setImage:images[0]];
        NSLog(@"原图%@",images);//%@形式打印会显示出地址和别的信息
        self.navigationController.navigationBar.barTintColor = RGB(0, 179, 90);
    }];
    
}


@end
