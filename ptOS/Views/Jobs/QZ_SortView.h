//
//  QZ_SortView.h
//  ptOS
//
//  Created by 周瑞 on 16/9/6.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

@interface QZ_SortView : BaseView

- (void)awakeFromNib;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImageView;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImageview;



@end
