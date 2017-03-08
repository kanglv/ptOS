//
//  QZ_SearchNavView.h
//  ptOS
//
//  Created by 周瑞 on 16/9/6.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"
#import "UITextField+LeftMargin.h"
@interface QZ_SearchNavView : BaseView

- (void)awakeFromNib;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *jobsBtn;

@property (weak, nonatomic) IBOutlet UIButton *companyBtn;


@end
