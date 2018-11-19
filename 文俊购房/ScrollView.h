//
//  ScrollView.h
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sington.h"

//#import "JSDropDownMenu.h"

@interface ScrollView : UIView<UIScrollViewDelegate>

//广告图片数组
@property (nonatomic,strong)NSMutableArray *data;//广告图片数组

@property (nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UIPageControl *pageCtr;//面数控制器

@property (nonatomic,strong)UIButton *districBtn;//区域按钮
@property (nonatomic,strong)UIButton *priceBtn;//价格按钮

@property (nonatomic,strong)void(^btnBlock)();//点击功能按钮时

//获取广告数据
-(void)getData;

@end
