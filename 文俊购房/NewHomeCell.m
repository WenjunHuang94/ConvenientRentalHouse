//
//  NewClientCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "NewClientCell.h"

@implementation NewClientCell


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
    
    self.collectView = [[UICollectionView alloc] initWithFrame:(CGRect){0,0,k_w,_height} collectionViewLayout:flowlayout];
    [self addSubview:_collectView];
    
    self.collectView.dataSource=self;
    self.collectView.delegate=self;
    
    _collectView.backgroundColor = [UIColor whiteColor];
    
    //注册Cell，必须要有,而且类型和标识符必须都一致
    [_collectView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [self getData];
    
}

//更新数据
-(void)getData{
    
    AVQuery *query = [AVQuery queryWithClassName:@"Home"];
    [query orderByDescending:@"createdAt"];//按时间降序
    [query includeKey:@"mainImg"];
    
    query.limit = 6;//限定6个最新房客
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {//成功
            self.dataArr = objects;
            [self.collectView reloadData];
        }
        
    }];

}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CollectionCell";
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AVObject *object = self.dataArr[indexPath.row];
    //通告图片
    AVFile *file = [object objectForKey:@"mainImg"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (!error) {
            UIImage *img = [UIImage imageWithData:data];//NSData转化为图片
            [cell setMyImage:img];
        }

    }];
    
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //CollectionCell * cell = (CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
//    cell.backgroundColor = [UIColor greenColor];
//    NSLog(@"item======%d",indexPath.item);
//    NSLog(@"row=======%d",indexPath.row);
//    NSLog(@"section===%d",indexPath.section);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
