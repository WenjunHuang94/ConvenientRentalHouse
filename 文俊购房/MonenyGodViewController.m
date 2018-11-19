//
//  MonenyGodViewController.m
//  文俊购房
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MonenyGodViewController.h"

@interface MonenyGodViewController ()
@property (nonatomic,strong)UIImageView *imgview;
@end

@implementation MonenyGodViewController

//将其设置为可以成为第一响应者
-(BOOL)canBecomeFirstResponder{
    return YES;
}

//摇动开始时
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //播放摇动动画
    NSArray *imgarr = @[@"摇-初始",@"摇-中",@"摇-后",@"摇-中",@"摇-初始"];
    NSMutableArray *marr = [NSMutableArray array];
    for (NSString *img in imgarr) {
        [marr addObject:[UIImage imageNamed:img]];
    }
    _imgview.animationImages = marr;
    _imgview.animationDuration = marr.count * 0.15;
    _imgview.animationRepeatCount = 1;
    [_imgview startAnimating];
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSArray *imgarr = @[@"上上签",@"上签",@"中签",@"下签"];
    int rand = random() % 4;//随机一张
    
    UIImage *img = [UIImage imageNamed:imgarr[rand]];
    _imgview.image = img;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController setHidesBottomBarWhenPushed:YES];//隐藏底部栏
    self.navigationController.navigationBarHidden = YES;//隐藏顶部栏
    
    self.view.backgroundColor = [UIColor colorWithRed:64 / 255.0 green:202 / 255.0 blue:238 / 255.0 alpha:1];
    
    
    __weak MonenyGodViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            //将底部tabbar不隐藏
            [obj.tabBarController setHidesBottomBarWhenPushed:NO];
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
}

-(void)createView{
    _imgview = [[UIImageView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.frame.size.height}];
    [self.view addSubview:_imgview];
    _imgview.image = [UIImage imageNamed:@"摇-初始"];
    
    UIButton *backbtn = [[UIButton alloc]initWithFrame:(CGRect){0,20,60,60}];
    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
}

-(void)back{
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController setHidesBottomBarWhenPushed:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
