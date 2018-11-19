//
//  mymodel.h
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mymodel : NSObject

@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *imgname;

-(id)initWithDic:(NSDictionary *)dic;
+(NSArray *)arrWithDic;

@end
