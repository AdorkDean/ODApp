//
//  ODCommunityDetailModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/28.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODCommunityDetailModel : NSObject


//@property(nonatomic, copy) NSString *title;
//@property(nonatomic, copy) NSString *content;
//@property(nonatomic, copy) NSString *created_at;
//@property(nonatomic, copy) NSString *user_id;
//@property(nonatomic, copy) NSString *nick;
//@property(nonatomic, copy) NSString *sign;
//@property(nonatomic, copy) NSString *avatar_url;
//@property(nonatomic, copy) NSString *bbs_id;
//@property(nonatomic, copy) NSString *parent_user_nick;
//@property(nonatomic, strong) NSArray *bbs_imgs;
//@property(nonatomic, strong) NSArray *imgs_big;
//@property(nonatomic, strong) NSDictionary *user;
//@property(nonatomic, copy) NSString *id;
//@property(nonatomic, copy) NSString *open_id;
//@property(nonatomic, copy) NSString *floor;
//@property(nonatomic, strong) NSMutableDictionary *share;


@property (nonatomic, assign) int bbs_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int status;

@property (nonatomic, assign) int id;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, assign) int floor;

@property (nonatomic, copy) NSString *parent_user_nick;

@property (nonatomic, assign) int parent_id;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, assign) int user_id;

@property (nonatomic, strong) NSDictionary *user;

@end

ODRequestResultIsArrayProperty(ODCommunityDetailModel)
