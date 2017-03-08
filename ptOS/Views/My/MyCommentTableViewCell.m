//
//  MyCommentTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/24.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MyCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommentLabel.h"


@implementation MyCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(MY_MyCommentModel *)model {
    self.contentLabel.text = model.content;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"moren_pt"]];
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.headerImageUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    ZRViewRadius(self.smallImageView, 12);
    self.nickNameLabel.text = model.nickName;
    self.companyNameLabel.text = model.companyName;
    self.timeLabel.text = model.time;
    
    if (model.imageUrl == nil || model.imageUrl.length < 6) {
        self.bigImageView.hidden = YES;
        self.contentLabel.width = FITWIDTH(322);
    }else {
        self.bigImageView.hidden = NO;
        self.contentLabel.width = FITWIDTH(267);
    }
    
    CGFloat width1 = [ControlUtil widthWithContent:model.nickName withFont:[UIFont systemFontOfSize:14] withHeight:21];
    if ([model.companyName isEqualToString:@""]) {
        self.shuView.hidden = YES;
    }else {
        self.shuView.hidden = NO;
    }
    self.nickNameLabel.width = width1;
    self.shuView.x = self.nickNameLabel.x + width1 + 3;
    self.companyNameLabel.x = self.shuView.x + 3;
    
    CommentLabel *view = [[CommentLabel alloc]initWithArray:model.replyList];
    CGFloat height = [view getHeightWithArray:model.replyList];
    view.frame = CGRectMake(8, 165, SCREEN_WIDTH - 16, height);
    [self.contentView addSubview:view];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 168 + [view getHeightWithArray:model.replyList] + 15, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = BackgroundColor;
    [self.contentView addSubview:lineView];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
