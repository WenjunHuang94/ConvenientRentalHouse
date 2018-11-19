//
//  NewClientCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionCell.h"

@interface NewClientCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectView;//最新房客

@property (nonatomic,assign)CGFloat height;//item高度
@property (nonatomic,strong)NSArray *dataArr;//热门房客数组

@end
