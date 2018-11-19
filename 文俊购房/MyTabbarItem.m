//
//  MyTabbarItem.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MyTabbarItem.h"

@implementation MyTabbarItem

-(id)initWithFrame:(CGRect)frame AndTitels:(NSString *)title AndImage:(UIImage *)image AndTitleColor:(UIColor *)color AndTitleFont:(UIFont *)font{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = font;
        
        //默认图片在左，文字在右
        //对titleLabel和imageView设置偏移量，是针对它当前的位置起作用的，并不是针对它距离button边框的距离的
        CGSize imagesize = image.size;
  
        CGSize titlesize = [title sizeWithFont:font constrainedToSize:(CGSize){MAXFLOAT,49}];
        
        //设置内容格式为左对齐，置顶
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        
        //先设置文字，避免图片缩放时平移图片宽度时不对应
//        1.在UIButton中，titleLabel的初始x值是imageView的宽度
//        2.imageView可以被压缩
//        3.当imageView被压缩后，imageView的宽度会变小，此时就不可以再用imageView的宽度来代替titleLabel的初始x值来调整位置了
        //4.imageView不可以被放大
        [self setTitleEdgeInsets:(UIEdgeInsets){image.size.height,(self.bounds.size.width - titlesize.width) / 2 - imagesize.width,0,0}];
        [self setImageEdgeInsets:(UIEdgeInsets){0,(self.bounds.size.width - imagesize.width) / 2,0,0}];
        //当图片尺寸改变时
//        [self setTitleEdgeInsets:(UIEdgeInsets){image.size.height,(self.bounds.size.width - titlesize.width) / 2 - imagesize.width,0,0}];
//        [self setImageEdgeInsets:(UIEdgeInsets){0,(self.bounds.size.width - imagesize.width) / 2,self.bounds.size.height - imagesize.height,(self.bounds.size.width - imagesize.width) / 2}];
    }
    return self;
}

@end
