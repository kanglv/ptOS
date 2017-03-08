//
//  QZ_JobsDetailView.h
//  ptOS
//
//  Created by 周瑞 on 16/9/4.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

@interface QZ_JobsDetailView : BaseView
@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet UIView *bottomView2;
@property (weak, nonatomic) IBOutlet UIView *bottomView3;
@property (weak, nonatomic) IBOutlet UIView *bottomView4;
@property (weak, nonatomic) IBOutlet UIView *bottomView5;

@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xzrzImageView;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fuli1View;
@property (weak, nonatomic) IBOutlet UILabel *fuli1Label;
@property (weak, nonatomic) IBOutlet UIImageView *fuli2View;
@property (weak, nonatomic) IBOutlet UILabel *fuli2Label;
@property (weak, nonatomic) IBOutlet UIImageView *fuli3View;
@property (weak, nonatomic) IBOutlet UILabel *fuli3Label;
@property (weak, nonatomic) IBOutlet UIImageView *fuli4View;
@property (weak, nonatomic) IBOutlet UILabel *fuli4Label;
@property (weak, nonatomic) IBOutlet UIImageView *fuli5View;
@property (weak, nonatomic) IBOutlet UILabel *fuli5Label;
@property (weak, nonatomic) IBOutlet UIImageView *fuli6View;
@property (weak, nonatomic) IBOutlet UILabel *fuli6Label;

@property (weak, nonatomic) IBOutlet UIImageView *companyHeaderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImgView;
@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *gzxzLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *gzjyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyqLabel;
@property (weak, nonatomic) IBOutlet UILabel *zxsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *zprsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ybmLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeallBtn;

@property (weak, nonatomic) IBOutlet UILabel *zwmsLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miaoshuHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightCons;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;


@end
