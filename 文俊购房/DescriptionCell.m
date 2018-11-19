//
//  DescriptionCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/11.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "DescriptionCell.h"

@implementation DescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

//设置控件
- (void)setup {
    
    //意见框多行输入，使用UITextView
    _inputView = [UITextView new];
    [self addSubview:_inputView];
    self.inputView.font = [UIFont systemFontOfSize:15];

    //self.inputView.delegate = self;
    self.inputView.layer.borderWidth = 1.0;//设置边框

    
    [self.inputView setBackgroundColor:[UIColor whiteColor]];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.bottom.mas_equalTo(0);
    }];
}

//开始编辑时，清空提示文字
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    
//    if(textView.tag == 0) {
//        textView.text = @"";
//        textView.textColor = [UIColor blackColor];
//        textView.tag = 1;
//    }
//    return YES;
//}

@end
