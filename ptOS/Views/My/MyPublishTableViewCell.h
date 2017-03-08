//
//  MyPublishTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLUILabel.h"
@interface MyPublishTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SHLUILabel *conetentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
