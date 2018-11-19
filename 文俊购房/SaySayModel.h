//
//  SaySayModel.h
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaySayModel : NSObject

//PeopleSay.plist每个dic数据属性
@property (nonatomic,strong)NSString *peopleImg;
@property (nonatomic,strong)NSString *peopleName;
@property (nonatomic,strong)NSString *job;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *from;
@property (nonatomic,strong)NSString *call;
@property (nonatomic,strong)NSString *messageImg;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSArray *btnArr;
@property (nonatomic,strong)NSString *goodImg;
@property (nonatomic,strong)NSArray *goodNameArr;
@property (nonatomic,strong)NSString *titleComment;
@property (nonatomic,strong)NSArray *commentArr;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSArray *messageImgArr;

-(id)initWithDic:(NSDictionary *)dic;
+(NSArray *)arrWithDic;

@end
