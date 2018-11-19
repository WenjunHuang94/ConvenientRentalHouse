//
//  cityModel.m
//  文俊购房
//
//  Created by mac on 16/5/15.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "cityModel.h"

@implementation cityModel

-(id)initWithArr:(NSArray *)arr{
    if (self = [super init]) {
        _citys = arr;
    }
    return self;
}

//所取城市数组
+(NSArray *)arrWithArr{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *marr = [NSMutableArray array];
    
    for (NSArray *citys in arr) {
        cityModel *model = [[cityModel alloc]initWithArr:citys];
        [marr addObject:model];
    }
    return marr;
}

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _hot = dic[@"hot"];
        _id = dic[@"id"];
        _name = dic[@"name"];
        _pinyin = dic[@"pinyin"];
    }
    return self;
}

@end
