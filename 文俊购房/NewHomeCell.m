//
//  NewClientCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "NewHomeCell.h"

@implementation NewHomeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
        
    }
    return self;
}

-(void)setUp{
    
    self.dataArr = [NSArray array];
    self.height = 150;
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowlayout = [UICollectionViewFlowLayout alloc];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //房源滚动视图
    self.collectView = [[UICollectionView alloc] initWithFrame:(CGRect){0,0,k_w,_height} collectionViewLayout:flowlayout];
    [self addSubview:_collectView];
    
    self.collectView.dataSource=self;
    self.collectView.delegate=self;
    
    _collectView.backgroundColor = [UIColor whiteColor];
    
    //注册每一个Cell，必须要有,而且类型和标识符必须都一致
    [_collectView registerClass:[NewHomeCollectionCell class] forCellWithReuseIdentifier:@"NewHomeCollectionCell"];
    
    [self getData];
    
}

//获取最新房源数据
-(void)getData{
    
    AVQuery *query = [AVQuery queryWithClassName:@"Home"];
    [query orderByDescending:@"updatedAt"];//按时间降序
    [query whereKey:@"homeVerify" equalTo:@(YES)];
    
    [query includeKey:@"mainImg"];//包含图片
    [query includeKey:@"imgArr"];
    
    query.limit = 10;//限定10个最新房源
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {//成功
            self.dataArr = objects;
            [self.collectView reloadData];//更新图片
        }
        
    }];

}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;//返回的个数，最多自行限制是十
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"NewHomeCollectionCell";
    
    NewHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AVObject *object = self.dataArr[indexPath.row];
    [cell setObject:object];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_height, _height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);//设置每个UICollectionView边距
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.collectViewBlock(self.dataArr[indexPath.row]);

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
