//
//  HomeCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCell : UITableViewCell

@property (strong, nonatomic) UILabel *cityLabel;//城市标签
@property (strong, nonatomic) UITextField *tipLabel;

//小区
@property (strong, nonatomic) UILabel *areaLabel;

//详细地址
@property (strong, nonatomic) UITextField *areaRemarks;
//楼号
@property (strong, nonatomic) UITextField *floorNumber;
//楼层
@property (strong, nonatomic) UITextField *houseFlow;
//几室
@property (strong, nonatomic) UITextField *houseNumber;
//几房
@property (strong, nonatomic) UITextField *roomNumber;
//几厅
@property (strong, nonatomic) UITextField *hallNumber;
//几卫
@property (strong, nonatomic) UITextField *toiletNumber;
//面积
@property (strong, nonatomic) UITextField *houseMeasure;
//租金
@property (strong, nonatomic) UITextField *housePrice;
//租金包含
@property (strong, nonatomic) UILabel *rentContain;
//支付佣金
@property (strong, nonatomic)

UILabel *paymentType;
//家具
@property (strong, nonatomic) UILabel *furniture;
//用途
@property (strong, nonatomic) UILabel *userLabel;
//入住时间
@property (strong, nonatomic) UITextField *moveIntoTime;
//时间选择器
@property (strong, nonatomic) UIPickerView *timePicker;
//列表数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
//标签列表
@property (strong, nonatomic) UICollectionView *collectionView;

@end
