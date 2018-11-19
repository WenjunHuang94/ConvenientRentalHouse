//
//  HomeImgCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/22.
//  Copyright © 2017年 wj. All rights reserved.
//

#define k_w [UIScreen mainScreen].bounds.size.width
#define k_h [UIScreen mainScreen].bounds.size.height

#import "HomeImgCell.h"

@implementation HomeImgCell{
    CGRect oldFrame;
    UIButton *cover;//覆盖按钮
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //图片数量
        int count = [Sington sharSington].homeImgArr.count;
        
        CGFloat btnW = 100;
        CGFloat btnH = 100;
        CGFloat space = 50;
        CGFloat X = (self.bounds.size.width - 2 * btnW  - space) / 2;
        CGFloat Y = 20;

        for (int i = 0; i < count; i++) {
            
            int row = i / 2;//行
            int col = i % 2;//列
            CGFloat btnX =  X + (space + btnW) * col;
            CGFloat btnY =  Y + (space + btnH) * row;
            
            //图片按钮
            UIButton *imgBtn= [[UIButton alloc]initWithFrame:(CGRect){btnX,btnY,btnW,btnH}];
            //记录图片按钮的frame
            oldFrame = imgBtn.frame;
            //记录tag
            imgBtn.tag = i;
            [imgBtn addTarget:self action:@selector(bigimageClick:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:imgBtn];
            
            AVFile *file = [[Sington sharSington].homeImgArr objectAtIndex:i];//第i个图的file文件
            [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (error) {
                    if (i == count) {
                        [Tip myTip:@"加载图片失败！"];
                    }
                }
                else{
                    UIImage *img = [UIImage imageWithData:data];
                    [imgBtn setBackgroundImage:img forState:UIControlStateNormal];//设置背景图片
                    imgBtn.imageView.image = img;//按钮图片赋值
                }

            }];
            
        }
    }
    
    return self;
}

//放大图片
-(void)bigimageClick:(UIButton *)btn{
    self.imgBlock(btn.imageView.image);
  
    
}


@end
