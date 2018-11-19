//
//  SGGroupCell.m
//  SGImagePickerController
//
//  Created by yyx on 15/9/20.
//  Copyright (c) 2015年 yyx. All rights reserved.
//

#import "SGGroupCell.h"
#define MARGIN 10

@implementation SGGroupCell

+ (instancetype)groupCell:(UITableView *)tableView{
    NSString *reusedId = @"groupCell";
    SGGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    return cell;
}
- (void)setGroup:(ALAssetsGroup *)group{
    //中文
    NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机";
    } else if ([groupName isEqualToString:@"My Photo Stream"]) {
        groupName = @"我的照片";
    }
    //设置属性
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger groupCount = [group numberOfAssets];
    self.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",groupName, groupCount];
    UIImage *image =[UIImage imageWithCGImage:group.posterImage] ;
    [self.imageView setImage:image];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cellHeight = self.frame.size.height - 2 *MARGIN;
    self.imageView.frame = CGRectMake(MARGIN, MARGIN, cellHeight, cellHeight);
}

@end
