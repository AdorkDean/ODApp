//
//  ODSkillDetailModel.m
//  ODApp
//
//  Created by Bracelet on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODSkillDetailModel.h"

@implementation ODSkillDetailUserModel

@end

@implementation ODSkillDetailImgBigModel

@end

@implementation ODSkillDetailLovesModel

@end

@implementation ODSkillDetailModel

+ (void)initialize
{
   [ODSkillDetailModel mj_setupObjectClassInArray:^NSDictionary *{
       return @{
//                @"数组名":@"数组里面的字典要转化成的模型类",
                @"imgs_big":@"ODSkillDetailImgBigModel",
                
                @"user":@"ODSkillDetailUserModel",
                
                @"loves":@"ODSkillDetailLovesModel"
                
                };
   }];
    
}

@end





