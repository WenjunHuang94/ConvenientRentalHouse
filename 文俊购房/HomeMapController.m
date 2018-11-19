//
//  HomeMapController.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/12.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "HomeMapController.h"

//导入地图与定位
#import <MapKit/MapKit.h>

#import "MyPoint.h"

#import "Sington.h"


#import <CoreLocation/CoreLocation.h>

@interface HomeMapController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    
    CLGeocoder *geocoder;
}

//地图
@property (nonatomic,strong)MKMapView *mapView;

@property (nonatomic,strong)NSString *currentCity;

@property (nonatomic)MKCoordinateRegion region;

@end

@implementation HomeMapController


-(void)viewDidLoad{
    
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    [self setNavTitle:[NSString stringWithFormat:@"%@%@",[self.object objectForKey:@"city"],[self.object objectForKey:@"homeName"]] AndImg:nil];
    
    __weak HomeMapController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            [obj.tabBarController setHidesBottomBarWhenPushed:YES];
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    //构造地图
    [self createView];
    
}

//构造地图
-(void)createView{
    
    //构造地图
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    //标注用户位置,一定要加上才会显示定位到用户的位置
    //self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
    
    //设置地图类型
    self.mapView.mapType = MKMapTypeStandard;
    
    // 设置地图的显示项(注意::版本适配)
    // 显示建筑物
    self.mapView.showsBuildings = YES;
    // 指南针
    self.mapView.showsCompass = YES;
    // 兴趣点
    self.mapView.showsPointsOfInterest = YES;
    // 比例尺
    self.mapView.showsScale = YES;
    // 交通
    self.mapView.showsTraffic = YES;

    
    geocoder = [[CLGeocoder alloc]init];
    
    //取得当前地名，包含城市名小区名
    NSString *adr = [NSString stringWithFormat:@"%@%@",[self.object objectForKey:@"city"],[self.object objectForKey:@"homeName"]];
    
    
    //根据地名，求出其经纬度
    [geocoder geocodeAddressString:adr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error != nil || placemarks.count == 0) {
            
        }else{
            CLPlacemark *firstPlaceMark = [placemarks firstObject];
            
            NSLog(@"%@的经度:%f",adr,firstPlaceMark.location.coordinate.latitude);
            NSLog(@"%@的纬度:%f",adr,firstPlaceMark.location.coordinate.longitude);
            
            
            //CLLocationCoordinate2D 是一个 C 结构体，包含经度和纬度两个值
            CLLocationCoordinate2D loc;
            loc.latitude = firstPlaceMark.location.coordinate.latitude;
            loc.longitude = firstPlaceMark.location.coordinate.longitude;
            
            //放大地图到自身的经纬度位置
            self.region = MKCoordinateRegionMakeWithDistance(loc, 100, 100);
            
            //设置地图区域位置
            [self.mapView setRegion:self.region animated:YES];
            
            //大头针标题
            NSString *title = adr;
            
            MyPoint *point = [[MyPoint alloc]initWithCoordinate:loc andTitle:title];
            [self.mapView addAnnotation:point];
            
        }
    }];
    
    //构造按钮，回到定位点
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){(k_w - btnW) / 2,k_h - btnH,btnW,btnH}];
    [btn setBackgroundColor:MainColor];
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"定位点" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];

}

-(void)click{
    //设置地图区域位置
    [self.mapView setRegion:self.region animated:YES];
}


@end
