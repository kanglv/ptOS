//
//  QZ_ComCommentModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/22.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface QZ_ComCommentModel : BaseModel

@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *userImage;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *company;

@end
