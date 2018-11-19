//
//  MyPoint.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#pragma 定义一个大头针

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyPoint : NSObject <MKAnnotation>

//实现MKAnnotation协议必须要定义这个属性
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;

//标题
@property (nonatomic,copy) NSString *title;

//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString*)t;


@end
