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
//    NSString *_zs1;
//    NSString *_zs2;
//    NSString *_zs3;
    NSMutableArray *_workExp;
    NSString *_skills;
    NSString *_skillsVoice;
    NSString *_resumeId;
}



- (id)initWithName:(NSString *)name
           WithSex:(NSString *)sex
         WithBirth:(NSString *)birth
     WithEducation:(NSString *)education
         Withphone:(NSString *)phone
WithCardPicFrontUrl:(NSString *)cardPicFrontUrl
WithCardPicBackUrl:(NSString *)cardPicBackUrl
  WithEducationPic:(NSString *)educationPicUrl
       WithWorkExp:(NSMutableArray *)workExp
        WithSkills:(NSString *)skills
    WithSkillVoice:(NSString *)skillVoice
            WithId:(NSString *)resumeId{
    if (self == [super init]) {
        _resumeId = resumeId;
        _name = name;
        _sex = sex;
        _birth = birth;
        _education = education;
        _phone = phone;
        _cardPicFront = cardPicFrontUrl;
        _cardPicBack = cardPicBackUrl;
        _educationPic = educationPicUrl;
       
        _workExp = workExp;
        if (_workExp == nil) {
            _workExp = [NSMutableArray alloc];
        }
        _skills = skills;
        if (_skills == nil) {
            _skills = @" ";
        }
        _skillsVoice = skillVoice;
        
    }
    return self;
    
}

- (NSString *)requestUrl {
    return @"postResume";
}

- (NSDictionary *)requestHeaderFieldValueDictionary{
    NSMutableDictionary *argument = nil;
    if(self.sessionDelegate)
    {
        argument = [self getBaseArgument];
    }
    else
    {
        argument = [self getBaseArgument];
    }
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument{
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setCustomString:_resumeId forKey:@"id"];
    [argument setCustomString:_name forKey:@"name"];
    [argument setCustomString:_sex forKey:@"sex"];
    [argument setCustomString:_birth forKey:@"birth"];
    [argument setCustomString:_education forKey:@"education"];
    [argument setCustomString:_phone forKey:@"phone"];
    [argument setCustomString:_cardPicFront forKey:@"cardPicFront"];
    [argument setCustomString:_cardPicBack forKey:@"cardPicBack"];
    [argument setCustomString:_educationPic forKey:@"educationPic"];
    [argument setCustomString:_skills forKey:@"skills"];
    [argument setCustomString:_skillsVoice forKey:@"skillsvoice"];
    [argument setValue:_workExp forKey:@"expers"];
    
    return argument;
}



@end
