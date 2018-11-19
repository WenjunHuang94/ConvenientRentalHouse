//
//  cityModel.h
//  文俊购房
//
//  Created by mac on 16/5/15.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityModel : NSObject


-(id)initWithArr:(NSArray *)arr;
+(NSArray *)arrWithArr;

@property (nonatomic,strong)NSArray *citys;

@property (nonatomic,strong)NSString *hot;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *pinyin;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
