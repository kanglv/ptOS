//
//  QZ_JobsNavView.h
//  ptOS
//
//  Created by 周瑞 on 16/9/6.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseView.h"

@interface QZ_JobsNavView : BaseView

- (void)awakeFromNib;


@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

/**
 *  @author Coder.R, 16-09-07 22:09:05
 *
 *  job按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *jobsBtn;
/**
 *  @author Coder.R, 16-09-07 22:09:13
 *
 *  公司按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
/**
 *  @author Coder.R, 16-09-07 22:09:21
 *
 *  搜索按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
/**
 *  @author Coder.R, 16-09-07 22:09:28
 *
 *  扫码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *QRcodeBtn;


@end
