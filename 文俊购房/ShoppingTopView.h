//
//  ShoppingTopView.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/17.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingTopView : UIView

@property (nonatomic,strong)UILabel *scoreLabel;//积分标签
@property (nonatomic,strong)UILabel *score;//积分

@property (nonatomic,strong)UIButton *registerBtn;//签到按钮

@property (nonatomic,strong)void(^registerBlock)();

@end
