//
//  SGPhotoBrowser.m
//  YaKe
//
//  Created by liu chao on 15/9/16.
//  Copyright (c) 2015年 ssyx. All rights reserved.
//

#import "SGPhotoBrowser.h"
#import "SGAssetModel.h"

#define SG_WIDTH [UIScreen mainScreen].bounds.size.width
#define SG_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MARGIN 10

static NSString * const reuseIdentifier = @"browserCell";

//collectionCell
@interface SGCollectionCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation SGCollectionCell
- (UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        //手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
        [imageView addGestureRecognizer:pinch];
    }
    return _imageView;
}
- (void)pinchScale:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}
@end
#pragma mark - -----------------SGCollectionDelegate-----------------
@interface SGCollectionDelegate :NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
//此处弱指针
@property (nonatomic,weak) SGPhotoBrowser *browser;
@property (nonatomic,assign) BOOL isRemoveAnimation;
@end

@implementation SGCollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.browser.assetModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SGCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    SGAssetModel *model = self.browser.assetModels[indexPath.item];
    [model originalImage:^(UIImage *image) {
        cell.imageView.image = image;
        CGFloat scale = image.size.height / image.size.width;
        cell.imageView.center = CGPointMake(SG_WIDTH*0.5, SG_HEIGHT *0.5);
        cell.imageView.bounds = CGRectMake(0, 0, SG_WIDTH, SG_WIDTH *scale);
    }];
    

    return cell;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    if (index < 0) return;
    
    self.browser.currentIndex = index;
    
    if (self.isRemoveAnimation == NO) {
        self.isRemoveAnimation = YES;
        //移除缩放效果
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        SGCollectionCell *cell = [self.browser dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [UIView animateWithDuration:0.25 animations:^{
            cell.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isRemoveAnimation = NO;
        }];
    }

    
}
@end

#pragma mark - -----------------SGPhotoBrowser -----------------
@interface SGPhotoBrowser()

@property (nonatomic,weak) UILabel *indexLabel;
//目的是用强指针指向代理,代理弱指针只想自己,这样自己销毁,代理销毁,跟常规不一样
@property (nonatomic,strong) id daili;

@end

@implementation SGPhotoBrowser


- (instancetype)init{
    
    //flowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(SG_WIDTH, SG_HEIGHT);
    self.collectionViewLayout = flowLayout;

    if (self = [super initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout]){
        //背景色
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        //注册cell
        [self registerClass:[SGCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.backgroundColor = [UIColor whiteColor];
        
        //代理和数据源
        SGCollectionDelegate *delegate = [[SGCollectionDelegate alloc]init];
        self.delegate = delegate;
        self.dataSource = delegate;
        self.daili = delegate;
        delegate.browser = self;
        
        //添加轻触事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window bringSubviewToFront:self.indexLabel];
    
    //显示当前图片,并滚动到当前位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)back:(UIGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.1;
        self.indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.indexLabel removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex + 1,self.assetModels.count];
}
- (UILabel *)indexLabel{
    if (_indexLabel == nil) {
        //添加index标签
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.0];
        label.textColor = [UIColor blackColor];
         _indexLabel = label;
        label.center = CGPointMake(SG_WIDTH*0.5, 30);
        label.bounds = CGRectMake(0, 0, 100, 30);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:label];
    }
    return _indexLabel;
}

@end

