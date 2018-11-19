//
//  ModifyNameController.m
//  文俊购房
//
//  Created by 俊帅 on 17/6/1.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ModifyNameController.h"

@interface ModifyNameController ()

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UITextField *nameField;

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载旋转动画

@end

@implementation ModifyNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavTitle:@"用户名" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    [self setNavRightBtnWithTitle:@[@"修改"] OrImage:nil];
    self.navigationController.navigationBarHidden = NO;
    
    __weak ModifyNameController *obj = self;
    self.btnClick = ^(UIButton *sender){
        
        if (sender.tag == 1) {//点击返回按钮时
            if([obj.delegate respondsToSelector:@selector(ModifyName:)]){
                [obj.delegate ModifyName:obj];
            }
            [obj.navigationController popViewControllerAnimated:YES];
        }
        else if (sender.tag == 11){
            [obj updateName];
        }
    };

    [self createView];
}

-(void)updateName{
    if ([_nameField.text isEqualToString:@""]) {
        [Tip myTip:@"请输入用户名!"];
        return;
    }
    AVUser *currentUser = [AVUser currentUser];
    [currentUser setObject:_nameField.text forKey:@"username"];
    
    [self.activeView startAnimating];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"修改成功!"];
            [Sington sharSington].name = currentUser.username;
        }
        else{
            [Tip myTip:@"修改失败!"];
        }
        [self.activeView stopAnimating];
    }];
    
}

-(void)createView{
    //姓名标签
    _nameLabel = [UILabel new];
    [self.view addSubview:_nameLabel];
    _nameLabel.text = @"用户名";
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(90);
        make.left.mas_equalTo(self.view.mas_left).with.offset(30);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    //姓名输入框
    _nameField = [UITextField new];
    [self.view addSubview:_nameField];
    [_nameField.layer setCornerRadius:5];
    _nameField.layer.borderWidth = 1;
    _nameField.layer.borderColor = [[UIColor grayColor]CGColor];
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_top);
        make.left.mas_equalTo(_nameLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(_nameLabel.mas_height);
    }];
    
    AVUser *currentUser = [AVUser currentUser];
    _nameField.text = currentUser.username;
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}

//点击空白处收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
