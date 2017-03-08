//
//  QZ_CompanyDetailView1.h
//  ptOS
//
//  Created by 周瑞 on 16/9/8.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

@interface QZ_CompanyDetailView1 : BaseView

- (void)awakeFromNib;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet UIView *bottomView2;
@property (weak, nonatomic) IBOutlet UIView *bottomView3;
@property (weak, nonatomic) IBOutlet UIView *bottomView4;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;

@property (weak, nonatomic) IBOutlet UIImageView *isRZImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *comIntroduceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *comVideoImage;
@property (weak, nonatomic) IBOutlet UILabel *longTImeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miaoshuHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightCons;

@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;



@end
