//
//  Tip.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/4.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "Tip.h"

@implementation Tip

//提示信息
+(void)myTip:(NSString *)str{

    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    aler.alertViewStyle = UIAlertViewStyleDefault;
    [aler show];
}



@end
