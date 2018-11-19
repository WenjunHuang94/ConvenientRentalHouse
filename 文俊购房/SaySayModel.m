//
//  SaySayModel.m
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "SaySayModel.h"

@implementation SaySayModel

-(id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(NSArray *)arrWithDic{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"PeopleSay.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *marr = [NSMutableArray array];
    for (NSDictionary * dic in arr) {
        SaySayModel *saysaymodel = [[SaySayModel alloc]initWithDic:dic];
        [marr addObject:saysaymodel];
    }
    return marr;
}

@end
