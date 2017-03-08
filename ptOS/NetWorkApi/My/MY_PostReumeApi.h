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
                Withzs1PicUrl:(NSString *)zs1PicUrl
                Withzs2PicUrl:(NSString *)zs2PicUrl
                Withzs3PicUrl:(NSString *)zs3PicUrl
                WithWorkExp:(NSString *)workExp
                WithSkills:(NSString *)skills;


@end
