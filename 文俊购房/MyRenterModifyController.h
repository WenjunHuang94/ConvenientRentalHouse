//
//  MyRenterModifyController.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/29.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "NavgiationViewController.h"

@class  MyRenterModifyController;
@protocol  MyRenterModifyControllerDelegate<NSObject>

@optional
-(void)UpdateModify:(MyRenterModifyController *)vcr;//编辑提交后更新信息

@end

@interface MyRenterModifyController : NavgiationViewController

@property (nonatomic,strong)AVObject *object;
@property (nonatomic,weak)id<MyRenterModifyControllerDelegate>delegate;

@end
