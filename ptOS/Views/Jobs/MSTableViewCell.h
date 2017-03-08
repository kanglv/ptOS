//
//  MSTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/10/17.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightCons;

@end
