//
//  ODSkillDetailModel.h
//  ODApp
//
//  Created by Bracelet on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//


//loves
@interface ODSkillDetailLovesModel : NSObject

@property (nonatomic, copy) NSString *open_id;
@property (nonatomic, copy) NSString *avater;


@end



//user
@interface ODSkillDetailUserModel : NSObject

@property (nonatomic, copy) NSString *open_id;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *gender;

@end


//imgs_big
@interface ODSkillDetailImgBigModel : NSObject

@property (nonatomic, copy) NSString *img_url;

@end

//result
@interface ODSkillDetailModel : NSObject

@property (nonatomic, copy) NSString *swap_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *swap_type;
@property (nonatomic, copy) NSString *love_num;
@property (nonatomic, copy) NSString *share_num;
@property (nonatomic, copy) NSString *is_love;

@property (nonatomic, strong) NSArray *imgs_big;
@property (nonatomic, strong) ODSkillDetailUserModel *user;
@property (nonatomic, strong) NSArray *loves;


@end


