//
//  ModifyNameController.h
//  文俊购房
//
//  Created by 俊帅 on 17/6/1.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "NavgiationViewController.h"

@class ModifyNameController;
@protocol ModifyNameControllerDelegate <NSObject>

@optional

-(void)ModifyName:(ModifyNameController *)vcr;//更新姓名

@end

@interface ModifyNameController : NavgiationViewController

@property (nonatomic,weak)id<ModifyNameControllerDelegate>delegate;

@end
