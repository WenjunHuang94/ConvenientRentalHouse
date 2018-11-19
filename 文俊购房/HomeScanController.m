//
//  HomeScanController.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/19.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeScanController.h"
#import "HomeImgCell.h"

#define k_w [UIScreen mainScreen].bounds.size.width
#define k_h [UIScreen mainScreen].bounds.size.height

@interface HomeScanController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIButton *bigImg;//放大的图片

@end

@implementation HomeScanController


-(void)viewDidLoad{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置标题
    [self setNavTitle:@"房屋相册" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    __weak HomeScanController *obj = self;
    self.btnClick = ^(UIButton *sender){
        //点击返回时事件
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    //tableView
    self.tableView = [[UITableView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.frame.size.height} style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    CGFloat imageBtnH = 200;
    CGFloat imageBtnY = (k_h - imageBtnH)/2;
    
    self.bigImg = [[UIButton alloc]initWithFrame:(CGRect){0,imageBtnY,k_w,200}];
    [self.bigImg setBackgroundColor:[UIColor purpleColor]];

    [self.bigImg addTarget:self action:@selector(bigImgEevent) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.bigImg];
    
    self.bigImg.alpha = 0;
}

//点击大图时，要其实现隐藏
-(void)bigImgEevent{
    if (_bigImg.alpha == 1) {
        _bigImg.alpha = 0;
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomeImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imgBlock = ^(UIImage *img){
        [self.bigImg setBackgroundImage:img forState:UIControlStateNormal];
        self.bigImg.alpha = 1;
    };

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20 + 125 * ([Sington sharSington].homeImgArr.count + 2) / 2;
}


@end
