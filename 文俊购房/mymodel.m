//
//  mymodel.m
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "mymodel.h"

@implementation mymodel

//"我"界面数据模型
-(id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _content = dic[@"content"];
        _imgname = dic[@"imgname"];
    }
    return self;
}

+(NSArray *)arrWithDic{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"my.plist" ofType:nil];
    NSArray *arrs = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray<NSArray *> *marr = [NSMutableArray array];
    for (NSArray *arr in arrs) {
        NSMutableArray<mymodel *> *mar = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            mymodel *model = [[mymodel alloc]initWithDic:dic];
            [mar addObject:model];
        }
        [marr addObject:mar];
    }
    return marr;
}

@end
