//
//  MY_PostReumeApi.m
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "MY_PostReumeApi.h"

@implementation MY_PostReumeApi
{
    NSString *_name;
    NSString *_sex;
    NSString *_birth;
    NSString *_education;
    NSString *_phone;
    NSString *_cardPicFront;
    NSString *_cardPicBack;
    NSString *_educationPic;
    NSString *_zs1;
    NSString *_zs2;
    NSString *_zs3;
    NSString *_workExp;
    NSString *_skills;
}

- (id)initWithName:(NSString *)name WithSex:(NSString *)sex WithBirth:(NSString *)birth WithEducation:(NSString *)education Withphone:(NSString *)phone WithCardPicFrontUrl:(NSString *)cardPicFrontUrl WithCardPicBackUrl:(NSString *)cardPicBackUrl WithEducationPic:(NSString *)educationPicUrl Withzs1PicUrl:(NSString *)zs1PicUrl Withzs2PicUrl:(NSString *)zs2PicUrl Withzs3PicUrl:(NSString *)zs3PicUrl WithWorkExp:(NSString *)workExp WithSkills:(NSString *)skills {
    if (self == [super init]) {
        _name = name;
        _sex = sex;
        _birth = birth;
        _education = education;
        _phone = phone;
        _cardPicFront = cardPicFrontUrl;
        _cardPicBack = cardPicBackUrl;
        _educationPic = educationPicUrl;
        _zs1 = zs1PicUrl;
        _zs2 = zs2PicUrl;
        _zs3 = zs3PicUrl;
        _workExp = workExp;
        if (_workExp == nil) {
            _workExp = @" ";
        }
        _skills = skills;
        if (_skills == nil) {
            _skills = @" ";
        }
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument{
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    [argument setCustomString:_name forKey:@"name"];
    [argument setCustomString:_sex forKey:@"sex"];
    [argument setCustomString:_birth forKey:@"birth"];
    [argument setCustomString:_education forKey:@"education"];
    [argument setCustomString:_phone forKey:@"phone"];
    [argument setCustomString:_cardPicFront forKey:@"cardPicFront"];
    [argument setCustomString:_cardPicBack forKey:@"cardPicBack"];
    [argument setCustomString:_educationPic forKey:@"educationPic"];
//    [argument setCustomString:_zs1 forKey:@"zs1"];
//    [argument setCustomString:_zs2 forKey:@"zs2"];
//    [argument setCustomString:_zs3 forKey:@"zs3"];
//    [argument setCustomString:_workExp forKey:@"workExp"];
//    [argument setCustomString:_skills forKey:@"skills"];
    [argument setValue:_workExp forKey:@"workExp"];
    [argument setValue:_skills forKey:@"skills"];
    return argument;
}


- (NSString *)requestUrl {
    return @"postResume";
}
@end
