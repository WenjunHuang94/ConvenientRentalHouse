//
//  HomeImgCell.h
//  文俊购房
//
//  Created by 俊帅 on 17/4/22.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "Sington.h"

#import <UIKit/UIKit.h>

@interface HomeImgCell : UITableViewCell

@property (nonatomic,strong)void(^imgBlock)(UIImage *img);

@end
