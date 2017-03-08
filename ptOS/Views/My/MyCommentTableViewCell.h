//
//  MyCommentTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/24.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MY_MyCommentModel.h"

@interface MyCommentTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UIView *shuView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setModel:(MY_MyCommentModel *)model;



@end
