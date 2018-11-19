//
//  SGImagesPickerController.m
//  SGImagePickerController
//
//  Created by yyx on 15/9/17.
//  Copyright (c) 2015年 yyx. All rights reserved.
//

#import "SGImagePickerController.h"
#import "SGAssetsGroupController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SGImagePickerController ()

@end

@implementation SGImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (instancetype)init{

    if (self = [super initWithRootViewController:self.assetsGroupVC]) {
        UINavigationBar *navBar = [UINavigationBar appearance];
        //导航条背景色
        navBar.barTintColor = [UIColor grayColor];
        //字体颜色
        navBar.tintColor = [UIColor whiteColor];
    }
    return self;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    return  [self init];
}
- (SGAssetsGroupController *)assetsGroupVC{
    SGAssetsGroupController *assetsGroupVC = [[SGAssetsGroupController alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择相册";
    [titleLabel sizeToFit];
    assetsGroupVC.navigationItem.titleView = titleLabel;
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    assetsGroupVC.navigationItem.leftBarButtonItem = cancelItem;
    return assetsGroupVC;
}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
