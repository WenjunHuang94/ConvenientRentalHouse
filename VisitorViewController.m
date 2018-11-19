//
//  VisitorViewController.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "VisitorViewController.h"

@interface VisitorViewController ()

@end

@implementation VisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"吉屋送客" AndImg:nil];
    [self setNavRightBtnWithTitle:@[@"管理"] OrImage:nil];
}

@end
