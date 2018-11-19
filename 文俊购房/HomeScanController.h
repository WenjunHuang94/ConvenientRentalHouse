//
//  HomeScanController.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/19.
//  Copyright © 2017年 wj. All rights reserved.
//

#pragma 房源详情界面中,点击顶部图片会跳出房屋所有图片控制器

#import "NavgiationViewController.h"

@interface HomeScanController : NavgiationViewController

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)AVObject *object;

@end
