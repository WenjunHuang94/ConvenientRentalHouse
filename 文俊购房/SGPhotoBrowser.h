//
//  SGPhotoBrowser.h
//  YaKe
//
//  Created by liu chao on 15/9/16.
//  Copyright (c) 2015年 ssyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGPhotoBrowser : UICollectionView

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray  *assetModels;

- (void)show;


@end
