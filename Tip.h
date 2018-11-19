//
//  Tip.h
//  文俊购房
//
//  Created by 俊帅 on 17/5/4.
//  Copyright © 2017年 wj. All rights reserved.
//


//注意:出现重复定义问题，是因为pch的预编译路径并没有设置为本程序的pch路径，在整个程序压缩后，拿到别的地方运行，一直记录着是别的路径，(在本机能运行是因为记录的别的路径,即源文件路径刚好有那个文件)需要修改即可

#pragma 用于提示

#import <Foundation/Foundation.h>

@interface Tip : NSObject

+(void)myTip:(NSString *)str;//提示信息

@end
