//
//  HotTableViewCell.h
//  文俊购房
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cityModel.h"
#import "Sington.h"

@interface HotTableViewCell : UITableViewCell

@property (nonatomic,strong)void(^myblock)(UIButton *);

@end
