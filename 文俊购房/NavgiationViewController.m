//
//  NavgiationViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "NavgiationViewController.h"

@interface NavgiationViewController ()

@end

@implementation NavgiationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条颜色
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:0 / 255.0 green:179 / 255.0 blue:90 / 255.0 alpha:1];
}

//设置导航标题
-(void)setNavTitle:(NSString *)title AndImg:(UIImage *)image{
    if (title) {
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){100,100,120,44}];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        CGSize imagesize = image.size;
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        
        //获取标题尺寸
        CGSize titlesize = [title boundingRectWithSize:(CGSize){MAXFLOAT,44} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        [btn setTitleEdgeInsets:(UIEdgeInsets){0,(btn.frame.size.width - titlesize.width - imagesize.width) / 2 -imagesize.width,0,0}];
        [btn setImageEdgeInsets:(UIEdgeInsets){0,(btn.frame.size.width - titlesize.width - imagesize.width) / 2 + titlesize.width,0,0}];
        btn.tag = 0;
        [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.titleView = btn;
        
    }
}

//设置导航左标题
-(void)setNavLeftBtnWithTitle:(NSArray *)titles OrImage:(NSArray *)images{
    NSMutableArray *arr = [NSMutableArray array];
    
    if (titles) {
        int i = 0;
        for (NSString *title in titles) {
            CGSize titlesize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:(CGSize){MAXFLOAT,44}];
            UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,0,titlesize.width,titlesize.height}];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.tag = i + 1;
            i++;
            
            UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [arr addObject:barBtn];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
    }else if (images){
        int i = 0;
        for (NSString *imagename in images) {
            UIImage *image = [UIImage imageNamed:imagename];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [btn setImage:image forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 1;
            i++;
            UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [arr addObject:barBtn];
        }
    }
    
    self.navigationItem.leftBarButtonItems = arr;
}

-(void)setNavRightBtnWithTitle:(NSArray *)titles OrImage:(NSArray *)images{
    NSMutableArray *arr = [NSMutableArray array];
    
    if (titles) {
        int i = 10;
        for (NSString *title in titles) {
            CGSize titlesize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:(CGSize){MAXFLOAT,44}];
            UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,0,titlesize.width,titlesize.height}];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.tag = i + 1;
            i++;
            UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [arr addObject:barBtn];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
    }else if (images){
        int i = 10;
        for (NSString *imagename in images) {
            UIImage *image = [UIImage imageNamed:imagename];
            CGSize imagesize = image.size;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imagesize.width, 44)];
            [btn setImage:image forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 1;
            i++;
            UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [arr addObject:barBtn];
        }
    }
    
    self.navigationItem.rightBarButtonItems = arr;
}

-(void)barBtnClick:(UIButton *)sendr{
    if (self.btnClick) {
        self.btnClick(sendr);
    }   
}


@end
