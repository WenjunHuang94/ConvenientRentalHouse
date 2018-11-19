//
//  CameraCell.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/11.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "CameraCell.h"

@implementation CameraCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

//设置控件
- (void)setup {
    
    //相机按钮
    _cameraBtn = [UIButton new];
    [self addSubview:_cameraBtn];
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"issue_camera"] forState:UIControlStateNormal];
    
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    
    _cameraLabel = [UILabel new];
    [self addSubview:_cameraLabel];
    _cameraLabel.textAlignment = NSTextAlignmentCenter;
    _cameraLabel.text = @"上传房屋照片";
    
    [_cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cameraBtn.mas_bottom).offset(0);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    //照片
    _photoImgView = [UIImageView new];
    [self addSubview:_photoImgView];
    _photoImgView.layer.borderWidth = 1;
    
    [_photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cameraLabel.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    UILabel *mainLabel = [UILabel new];
    [self addSubview:mainLabel];
    mainLabel.text = @"首照片";
    [mainLabel setTextColor:MainColor];
    
    [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_photoImgView.mas_top).with.offset(10);
        make.left.mas_equalTo(_photoImgView.mas_left).with.offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
}


@end
