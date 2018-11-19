//
//  MyTabbarItem.h
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabbarItem : UIButton

//设置tabbar选项的大小
-(id)initWithFrame:(CGRect)frame AndTitels:(NSString *)title AndImage:(UIImage *)image AndTitleColor:(UIColor *)color AndTitleFont:(UIFont *)font;

@end
