//
//  DesignViewController.h
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "NavgiationViewController.h"

@class DesignViewController;
@protocol DesignViewControllerDelegate <NSObject>

@optional
//设置的代理方法，用于退出时清空界面用户数据
-(void)quitState:(DesignViewController *)vcr;

@end

@interface DesignViewController : NavgiationViewController

@property (nonatomic,strong)id<DesignViewControllerDelegate>delegate;

@end
