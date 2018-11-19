//
//  MyPoint.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/14.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
    }
    return self;
}

@end
