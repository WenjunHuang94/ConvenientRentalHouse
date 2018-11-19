//
//  PeopleSayCell.m
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "PeopleSayCell.h"

@implementation PeopleSayCell{
    UILabel *name;
    UILabel *time;
    UILabel *job;
    UILabel *from;
    UIButton *call;
    UIButton *informationBtn;
    UIView *commentView;
    UIButton *good;
    UILabel *goodText;
    UIButton *showAllBtn;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat peopleImageX = 20;
        CGFloat peopleImageY = 20;
        CGFloat peopleImageW = 40;
        CGFloat peopleImageH = 40;
        
        _peopleImage = [[UIImageView alloc]initWithFrame:(CGRect){peopleImageX,peopleImageY,peopleImageW,peopleImageH}];
        [self.contentView addSubview:_peopleImage];
        
        CGFloat nameX = CGRectGetMaxX(_peopleImage.frame) + 5;
        CGFloat nameY = peopleImageY;
        CGFloat nameW = 50;
        CGFloat nameH = 20;
        
        name = [[UILabel alloc]initWithFrame:(CGRect){nameX,nameY,nameW,nameH}];
        name.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:name];
        
        CGFloat jobX = CGRectGetMaxX(name.frame);
        CGFloat jobY = peopleImageY;
        CGFloat jobW = 50;
        CGFloat jobH = 20;
        
        job = [[UILabel alloc]initWithFrame:(CGRect){jobX,jobY,jobW,jobH}];
        job.font = [UIFont systemFontOfSize:12];
        job.alpha = 0.5;
        [self.contentView addSubview:job];
        
        CGFloat timeX = nameX;
        CGFloat timeY = CGRectGetMaxY(name.frame);
        CGFloat timeW = 80;
        CGFloat timeH = 20;
        
        time = [[UILabel alloc]initWithFrame:(CGRect){timeX,timeY,timeW,timeH}];
        time.font = [UIFont systemFontOfSize:12];
        time.alpha = 0.5;
        [self.contentView addSubview:time];
        
        CGFloat fromX = CGRectGetMaxX(time.frame);
        CGFloat fromY = time.frame.origin.y;
        CGFloat fromW = 120;
        CGFloat fromH = 20;
        
        from = [[UILabel alloc]initWithFrame:(CGRect){fromX,fromY,fromW,fromH}];
        from.font = [UIFont systemFontOfSize:12];
        from.alpha = 0.5;
        [self.contentView addSubview:from];
        
        CGFloat callX = self.frame.size.width;
        CGFloat callY = peopleImageY;
        CGFloat callW = 35;
        CGFloat callH = 35;
        
        call = [[UIButton alloc]initWithFrame:(CGRect){callX,callY,callW,callH}];
        [self.contentView addSubview:call];
        
        CGFloat informationBtnX = nameX;
        CGFloat informationBtnY = CGRectGetMaxY(time.frame) + 10;
        CGFloat informationBtnW = 300;
        CGFloat informationBtnH = 50;
        
        informationBtn = [[UIButton alloc]initWithFrame:(CGRect){informationBtnX,informationBtnY,informationBtnW,informationBtnH}];
        informationBtn.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:informationBtn];
        
        CGFloat commentViewW = 375;
        CGFloat commentViewH = 300;
        CGFloat commentViewX = 0;
        CGFloat commentViewY = CGRectGetMaxY(informationBtn.frame) + 10;
        
        commentView = [[UIView alloc]initWithFrame:(CGRect){commentViewX,commentViewY,commentViewW,commentViewH}];
        commentView.backgroundColor = [UIColor lightGrayColor];
        commentView.alpha = 0.2;
        [self.contentView addSubview:commentView];
        
        CGFloat goodW = 22;
        CGFloat goodH = 22;
        CGFloat goodX = 5;
        CGFloat goodY = commentView.frame.origin.y + 50;
        
        good = [[UIButton alloc]initWithFrame:(CGRect){goodX,goodY,goodW,goodH}];
        [self.contentView addSubview:good];
        
        CGFloat goodTextW = 330;
        CGFloat goodTextH = 40;
        CGFloat goodTextX = CGRectGetMaxX(good.frame) + 5;
        CGFloat goodTextY = goodY;
        
        goodText = [[UILabel alloc]initWithFrame:(CGRect){goodTextX,goodTextY,goodTextW,goodTextH}];
        goodText.numberOfLines = 2;
        goodText.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:goodText];
        
        CGFloat showAllBtnW = 120;
        CGFloat showAllBtnH = 25;
        CGFloat showAllBtnX = goodX;
        CGFloat showAllBtnY = CGRectGetMaxY(goodText.frame);
        
        showAllBtn = [[UIButton alloc]initWithFrame:(CGRect){showAllBtnX,showAllBtnY,showAllBtnW,showAllBtnH}];
        [showAllBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [showAllBtn addTarget:self action:@selector(showAllContent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:showAllBtn];
        
    }
    return self;
}

//重写setSaysaymodel加载数据
-(void)setSaysaymodel:(SaySayModel *)saysaymodel{
    _saysaymodel = saysaymodel;
    
    _peopleImage.image = [UIImage imageNamed:_saysaymodel.peopleImg];
    name.text = _saysaymodel.peopleName;
    job.text = _saysaymodel.job;
    time.text = _saysaymodel.time;
    from.text = [NSString stringWithFormat:@"来自%@",_saysaymodel.from];
    [call setBackgroundImage:[UIImage imageNamed:_saysaymodel.call] forState:UIControlStateNormal];
    
    informationBtn.imageEdgeInsets  = UIEdgeInsetsMake(5, 5, 5, informationBtn.frame.size.width - 45);
    informationBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -1870, 5, 5);
    informationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    informationBtn.titleLabel.numberOfLines = 2;
    [informationBtn setImage:[UIImage imageNamed:_saysaymodel.messageImg] forState:UIControlStateNormal];
    [informationBtn setTitle:_saysaymodel.message forState:UIControlStateNormal];
    
    NSInteger count = _saysaymodel.btnArr.count;
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    CGFloat space = 70;
    
    CGFloat X = (375 - count * btnW - (count - 1) * space) / 2;
    CGFloat btnY = commentView.frame.origin.y + 10;
    NSMutableArray *arrNumber = [NSMutableArray array];
    NSMutableArray *arrImgName = [NSMutableArray array];
    for (NSDictionary*dic in _saysaymodel.btnArr) {
        [arrNumber addObject:dic[@"number"]];
        [arrImgName addObject:dic[@"icon"]];
    }
    
    for (int i = 0; i < count; i++) {
        CGFloat btnX = X + (btnW + space) * i;
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){btnX,btnY,btnW,btnH}];
        [btn setImage:[UIImage imageNamed:arrImgName[i]] forState:UIControlStateNormal];
        [btn setTitle:arrNumber[i]forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        
        btn.tag = i;
        if (i == 0) {
            [btn addTarget:self action:@selector(goodBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 2)
            [btn addTarget:self action:@selector(goodBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [good setBackgroundImage:[UIImage imageNamed:_saysaymodel.goodImg] forState:UIControlStateNormal];
    
    NSMutableString *goodNameAll = [NSMutableString string];
    for (NSString *str in _saysaymodel.goodNameArr) {
        [goodNameAll insertString:[NSString stringWithFormat:@"%@、",str] atIndex:[goodNameAll length]];
    }
    goodText.text = goodNameAll;
    
    [showAllBtn setTitle:_saysaymodel.titleComment forState:UIControlStateNormal];
    
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *contentArr = [NSMutableArray array];
    for (NSDictionary *dic in _saysaymodel.commentArr) {
        [nameArr addObject:dic[@"name"]];
        NSString *content = [NSString stringWithFormat:@":%@",dic[@"content"]];
        [contentArr addObject:content];
    }
    CGFloat startY = CGRectGetMaxY(showAllBtn.frame);
    
    for (int i = 0; i < _saysaymodel.commentArr.count; i++) {
        CGFloat btnW = [nameArr[i] length] * 15;
        CGFloat btnH = 30;
        CGFloat btnX = good.frame.origin.x;
        CGFloat btnY = startY + (btnH + 5) * i;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){btnX,btnY,btnW,btnH}];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:btn];
        
        CGFloat labelW = [contentArr[i] length] * 15;
        CGFloat labelH = 30;
        CGFloat labelX = CGRectGetMaxX(btn.frame);
        CGFloat labelY = btnY;
        
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){labelX,labelY,labelW,labelH}];
        label.text = contentArr[i];
        label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
    }
}

//显示所有评论
-(void)showAllContent{
    self.update();//通过更新数据，实现新增评论时的所有内容显示
}

//点击点赞按钮时
-(void)goodBtnClick:(UIButton *)btn{
    NSString *str =  btn.titleLabel.text;
    NSInteger number = [str integerValue];
    number++;
    [btn setTitle:[NSString stringWithFormat:@"%ld",(long)number] forState:UIControlStateNormal];
    [self endEditing:YES];
    
}

@end
