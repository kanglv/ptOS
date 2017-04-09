//
//  MY_PostReumeApi.h
//  ptOS
//
//  Created by 周瑞 on 16/9/23.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseNetApi.h"

@interface MY_PostReumeApi : BaseNetApi


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
            WithId:(NSString *)resumeId;



@end
