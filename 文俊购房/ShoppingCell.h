//
//  ShoppingCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/25.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgView;//图片
@property (nonatomic,strong)UILabel *shopingName;//商品名
@property (nonatomic,strong)UILabel *shopingScore;//兑换积分

@property (nonatomic,strong)UIButton *buyBtn;//况换按钮
@property (nonatomic,strong)void(^buy)();//兑换代理

@end
