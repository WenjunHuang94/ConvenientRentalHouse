//
//  ClientViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ClientViewController.h"
#import "LoginViewController.h"
#import "Sington.h"
#import "LoginViewController.h"

@interface ClientViewController ()
@property (nonatomic,strong)UIView *topview;
@property (nonatomic,strong)UITextField *search;
@property (nonatomic,strong)UIButton *searchbtn;
@property (nonatomic,strong)UIImageView *tipview;
@property (nonatomic,strong)UILabel *tiplabel;
@end

@implementation ClientViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    
    [self setNavTitle:@"所有" AndImg:[UIImage imageNamed:@"城市下拉1"]];
    [self setNavLeftBtnWithTitle:@[@"提醒"] OrImage:nil];
    [self setNavRightBtnWithTitle:nil OrImage:@[@"添加客户"]];
    [self createView];
}

-(void)createView{
    
    self.topview = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,120}];
    self.topview.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:179 / 255.0 blue:90 / 255.0 alpha:1];
    [self.view addSubview:self.topview];
    
    CGFloat searchW = self.view.frame.size.width - 100;
    CGFloat searchH = 40;
    CGFloat searchX = 10;
    CGFloat searchY = 70;
    
    self.search = [[UITextField alloc]initWithFrame:(CGRect){searchX,searchY,searchW,searchH}];
    self.search.borderStyle = UITextBorderStyleRoundedRect;
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,0,15,15}];
    btn.backgroundColor = [UIColor purpleColor];
    self.search.placeholder = @"搜索";
    self.search.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    self.search.leftViewMode = UITextFieldViewModeUnlessEditing;
    [self.view addSubview:self.search];
    
    self.searchbtn = [[UIButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(self.search.frame) + 5,searchY,80,searchH}];
    self.searchbtn.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:198 / 255.0 blue:240 / 255.0 alpha:1];
    self.searchbtn.layer.cornerRadius = 10;
    self.searchbtn.layer.masksToBounds = YES;
    [self.searchbtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:self.searchbtn];
    
    //没客户时的提示imgview
    CGFloat tipviewW = 150;
    CGFloat tipviewH = 150;
    CGFloat tipviewX = (self.view.frame.size.width - tipviewW) / 2;
    CGFloat tipviewY = (self.view.frame.size.height - tipviewH) / 2;
    self.tipview = [[UIImageView alloc]initWithFrame:(CGRect){tipviewX,tipviewY,tipviewW,tipviewH}];
    self.tipview.backgroundColor = [UIColor yellowColor];
    self.tipview.image = [UIImage imageNamed:@"暂无客户"];
    [self.view addSubview:self.tipview];
    
    self.tiplabel = [[UILabel alloc]initWithFrame:(CGRect){tipviewX,CGRectGetMaxY(self.tipview.frame),tipviewW,30}];
    self.tiplabel.textAlignment = NSTextAlignmentCenter;
    self.tiplabel.text = @"暂无客户";
    self.tiplabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tiplabel];
}

@end
