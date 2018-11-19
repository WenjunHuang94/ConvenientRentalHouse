//
//  ModifyView.h
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyView : UIView<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *oldfield;
@property (nonatomic,strong)UITextField *passfield;
@property (nonatomic,strong)UITextField *againfield;

@end
