//
//  ScrollView.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

//
-(NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //创建图片轮播
        CGFloat scrollviewH = 170;
        _scrollview = [[UIScrollView alloc]initWithFrame:(CGRect){0,0,k_w,scrollviewH}];
  
        self.scrollview.delegate = self;
        [self addSubview:self.scrollview];
        
        //功能按钮
        int count = 4;
        CGFloat btnW = 45;
        CGFloat btnH = 45;
        CGFloat spaceX = 30;
        CGFloat X = (k_w - count * btnW  - (count - 1)* spaceX) / 2;
        CGFloat btnY = CGRectGetMaxY(self.scrollview.frame) + 10;
        
        NSArray *arrlabel = @[@"租房信息",@"求租信息",@"财神",@"扫一扫"];
        
        for (int i = 0; i < arrlabel.count; i++) {
            CGFloat btnX =  X + (spaceX + btnW) * i;
            UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){btnX,btnY,btnW,btnH}];
            NSString *imaname = [NSString stringWithFormat:@"首-%d",i];
            [btn setImage:[UIImage imageNamed:imaname] forState:UIControlStateNormal];
            [self addSubview:btn];
            
            
            btn.tag = i;//tag
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat labelY = CGRectGetMaxY(btn.frame) + 5;
            UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){btnX - 5,labelY,btnW + 10,25}];
            label.text = arrlabel[i];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
        
    }
    
    [self getData];//加载网络广告图片数据
    
    return self;
}

//点击功能按钮时
-(void)btnClick:(UIButton *)btn{
    self.btnBlock(btn);
}


//获取广告数据
-(void)getData{
    
    AVQuery *query = [AVQuery queryWithClassName:@"advertise"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {//获取成功
            
            //移附广告数据，重新赋值
            [self.data removeAllObjects];
            [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.pageCtr.currentPage = 0;
            self.scrollview.contentOffset = CGPointMake(0, 0);//从0作广告起点
            [self.timer invalidate];//停止时间轮播
            
            
            for (AVObject *object in objects) {
                //转为图片
                AVFile *file = [object objectForKey:@"image"];
                [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    UIImage *img = [UIImage imageWithData:data];
                    [self.data addObject:img];
                    
                    if (self.data.count == objects.count) {
                        [self createScrollImg];//创建滚动图片
                    }
      
                }];
            }
        }
    }];
    
}

//获取网络数据后建立滚动图片
-(void)createScrollImg{
    
    //ScrollView添加按钮图片
    for (int i = 0; i < self.data.count; i++) {
        CGFloat imageviewX = i * k_w;
        UIButton *imageview = [[UIButton alloc]initWithFrame:(CGRect){imageviewX,0,k_w,170}];
        imageview.tag = i + 1;
        [imageview setImage:self.data[i] forState:UIControlStateNormal];
        [_scrollview addSubview:imageview];
    }
    _scrollview.contentSize = CGSizeMake(self.data.count * k_w, 0);//广告内容长度
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;//禁上纵向移动
    
    //页数控件
    self.pageCtr = [[UIPageControl alloc]initWithFrame:(CGRect){0,140,k_w,30}];
    self.pageCtr.numberOfPages = self.data.count;
    
    self.pageCtr.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageCtr.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [self addSubview:self.pageCtr];
    
    //时钟，实现图片轮播
    [self addtimer];
}


//时间轮播
-(void)addtimer{
    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:_timer forMode:NSRunLoopCommonModes];
}

//播放下一个广告
-(void)nextImage{
    
    NSInteger page = self.pageCtr.currentPage;
    
    //判断当前所在页数，不是最后一则广告则往下移，是则移到第一张广告
    if (page == self.data.count - 1) {
        page = 0;
    }else{
        page++;
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.scrollview.contentOffset = CGPointMake(page * self.scrollview.frame.size.width, 0);
    }];
    
}

//广告开始拖动前，停止时间轮播
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}


//拖动广告时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = self.scrollview.contentOffset.x /  self.scrollview.frame.size.width;
    self.pageCtr.currentPage = page;
}

//广告将停止拖动后，开始时间轮播
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addtimer];
}

@end
