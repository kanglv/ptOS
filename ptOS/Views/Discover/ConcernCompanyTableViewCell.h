//
//  ConcernCompanyTableViewCell.h
//  ptOS
//
//  Created by 吕康 on 17/3/4.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConcernCompanyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

@end
