//
//  GlobalData.h
//  ptOS
//
//  Created by 周瑞 on 16/8/30.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
@interface GlobalData : NSObject

@property (nonatomic,strong)UserInfoModel *selfInfo;

@property (nonatomic,strong)NSString *coordinate;

@property (nonatomic,strong)NSString *location; //当前选择城市

@property (nonatomic, strong)NSString *minSalary; //最低薪资

@property (nonatomic, strong)NSString *maxSalary; //最大薪资

@property (nonatomic , strong) NSString *experience; //工作经验

@property (nonatomic , strong) NSString *educations; //学历

@property (nonatomic , strong)NSString *jobNatures; //工作性质


//简历
@property (nonatomic,copy)NSString *jl_name;
@property (nonatomic,copy)NSString *jl_sex;
@property (nonatomic,copy)NSString *jl_birth;
@property (nonatomic,copy)NSString *jl_education;
@property (nonatomic,copy)NSString *jl_phone;
@property (nonatomic,copy)NSString *jl_cardPicFont;
@property (nonatomic,copy)NSString *jl_cardPicBack;
@property (nonatomic,copy)NSString *jl_educationPiC;
@property (nonatomic,copy)NSString *jl_zs1;
@property (nonatomic,copy)NSString *jl_zs2;
@property (nonatomic,copy)NSString *jl_zs3;
@property (nonatomic,copy)NSString *jl_workExp;
@property (nonatomic,copy)NSString *jl_skills;

@property (nonatomic,strong)UIImage *cardPicFont;
@property (nonatomic,strong)UIImage *cardPicBack;
@property (nonatomic,strong)UIImage *educationPiC;
@property (nonatomic,strong)UIImage *zs1;
@property (nonatomic,strong)UIImage *zs2;
@property (nonatomic,strong)UIImage *zs3;


@property (nonatomic,strong)NSString *cardPicFontName;
@property (nonatomic,strong)NSString *cardPicBackName;
@property (nonatomic,strong)NSString *educationPiCName;

@property (nonatomic,copy)NSString *health1Url;
@property (nonatomic,copy)NSString *health1Ur2;
@property (nonatomic,copy)NSString *health1Ur3;
@property (nonatomic,copy)NSString *health1Ur4;
@property (nonatomic,copy)NSString *health1Ur5;
@property (nonatomic,copy)NSString *health1Ur6;
@property (nonatomic,copy)NSString *health1Ur7;
@property (nonatomic,copy)NSString *health1Ur8;


@property (nonatomic,strong)UIImage *health1;
@property (nonatomic,strong)UIImage *health2;
@property (nonatomic,strong)UIImage *health3;
@property (nonatomic,strong)UIImage *health4;
@property (nonatomic,strong)UIImage *health5;
@property (nonatomic,strong)UIImage *health6;
@property (nonatomic,strong)UIImage *health7;
@property (nonatomic,strong)UIImage *health8;

@property (nonatomic,strong)NSString *health1Name;
@property (nonatomic,strong)NSString *health2Name;
@property (nonatomic,strong)NSString *health3Name;
@property (nonatomic,strong)NSString *health4Name;
@property (nonatomic,strong)NSString *health5Name;
@property (nonatomic,strong)NSString *health6Name;
@property (nonatomic,strong)NSString *health7Name;
@property (nonatomic,strong)NSString *health8Name;


+ (GlobalData *)sharedInstance;

@end
