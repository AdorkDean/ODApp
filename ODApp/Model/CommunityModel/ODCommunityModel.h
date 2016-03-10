//
//  ODCommunityModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityModel.h"

@interface ODCommunityModel : ODAppModel

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *view_num;
@property(nonatomic, copy) NSString *created_at;
@property(nonatomic, strong) NSArray *imgs;
@property(nonatomic, strong) NSArray *imgs_big;

//user
@property(nonatomic, copy) NSString *nick;
@property(nonatomic, copy) NSString *gender;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, copy) NSString *avatar_url;
/**
 *   "id": 790,
 "title": "hdhdhdhdhdhdhddhdhhdhdhdhdhghd",
 "content": "hdhdhdhdhudhdhdhhd",
 "user_id": 2,
 "view_num": 0,
 "last_reply": {
 "reply_user_id": 0,
 "created_at": ""
 },
 "tags": []
 }
 */
@end
