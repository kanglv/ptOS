//
//  FX_NoticeListModel.h
//  ptOS
//
//  Created by 吕康 on 17/3/12.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface FX_NoticeListModel : BaseModel

@property (nonatomic, copy)NSString *noticeId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *type;


@end
