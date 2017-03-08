//
//  QZ_CompanyDetailView2.h
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

@interface QZ_CompanyDetailView2 : BaseView

- (void)awakeFromNib;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIImageView *isRZImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *xiangyingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *needNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *tianLabel;
@property (weak, nonatomic) IBOutlet UILabel *renLabel;


@end
