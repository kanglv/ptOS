//
//  QZ_JobDetailModel.h
//  ptOS
//
//  Created by 周瑞 on 16/9/21.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "BaseModel.h"

@interface QZ_JobDetailModel : BaseModel

@property (nonatomic, strong)NSString *isYBM;/**< 是否报名 */
@property (nonatomic, strong)NSString *isCollect;/**< 是否已收藏 */
@property (nonatomic, strong)NSString *zwName;/**< 职位名 */
@property (nonatomic, strong)NSString *collectNum;/**< 关注人数 */
@property (nonatomic, strong)NSString *salary;/**< 工资 */
@property (nonatomic, strong)NSString *isXZRZ;/**< 是否薪资认证 */
@property (nonatomic, strong)NSString *fuli;/**< 福利 */
@property (nonatomic, strong)NSString *education;/**< 学历 */
@property (nonatomic, strong)NSString *gzxz;/**< 工作性质 */
@property (nonatomic, strong)NSString *sex;/**< 性别 */
@property (nonatomic, strong)NSString *gzjy;/**< 工作经验 */
@property (nonatomic, strong)NSString *age;/**< 年龄 */
@property (nonatomic, strong)NSString *qtyq;/**< 其他要求 */
@property (nonatomic, strong)NSString *zxsj;/**< 作息时间 */
@property (nonatomic, strong)NSString *companyName;/**< 公司名 */
@property (nonatomic, strong)NSString *companyId;/**< 公司id */
@property (nonatomic, strong)NSString *city;/**< 城市 */
@property (nonatomic, strong)NSString *zprs;/**< 招聘人数 */
@property (nonatomic, strong)NSString *ybm;/**< 已报名人数 */
@property (nonatomic, strong)NSString *zwms;/**< 职位描述 */
@property (nonatomic, strong)NSString *gsxz;/**< 公司性质 */
@property (nonatomic, strong)NSString *companyImage;/**< 公司图片 */
@property (nonatomic, strong)NSString *isZZ;/**< 是否直招 */
@property (nonatomic, strong)NSString *address;/**< 公司地址 */
@property (nonatomic, strong)NSString *coordinate;/**< 经纬度 */
@property (nonatomic, strong)NSString *isZP;

@end
