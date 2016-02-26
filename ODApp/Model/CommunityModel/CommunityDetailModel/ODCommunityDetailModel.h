//
//  ODCommunityDetailModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/28.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODCommunityDetailModel : ODAppModel


@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *nick;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *avatar_url;
@property(nonatomic,copy)NSString *bbs_id;
@property(nonatomic,copy)NSString *parent_user_nick;
@property(nonatomic,strong)NSArray *bbs_imgs;
@property(nonatomic,strong)NSArray *imgs_big;
@property(nonatomic,strong)NSDictionary *user;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *open_id;
@property(nonatomic,copy)NSString *floor;
@property (nonatomic,strong) NSMutableDictionary *share;


/**
 *   "id": 816,
 "user_id": 973,
 "view_num": 1,
 "title": "美丽的2016还有一周就来了！",
 "content": "想求什么就带着祝福文字转走吧！心想事成！天天开心！",
 "created_at": "2015-12-25 11:18:07",
 "updated_at": "2015-12-28 10:21:07",
 "type": 1,
 "start_time": "0000-00-00 00:00:00",
 "end_time": "0000-00-00 00:00:00",
 "bbs_status": "1",
 "task_status": "1",
 "violation_reason": "",
 "bbs_reward_id": 0,
 "task_type": 1,
 "bbs_imgs": [
 "fab9d97f690f4ae91aed63dfdbb6c592",
 "df53adcccdbbac2d078455d709705f4a",
 "ca838ecda3ac9773c20f13fb89e53476",
 "57dee776df463ebcad85c1b1ffcdfcb2",
 "34fe87e22d229bfe16800c2042820b60",
 "83b1867d6d9b19e04116d094f641c968",
 "32dd280c6833f194b7d84ad0848e31ac",
 "ff8e9732ff81bdd60c612ec7c6f6478e",
 "e9f7697776ec109e6a988c1069bcd6fa"
 ],
 "tags": [],
 "user": {
 "id": 973,
 "nick": "り午夜↘清醒依旧、 ",
 "gender": 2,
 "avatar": "60339f72edfb8aaa76c4f0920bedfdb2",
 "sign": "宁可自己去原谅别人，莫等别人来原谅自己",
 "open_id": "58523135672693d233d7",
 "avatar_url": "http://odfile.ufile.ucloud.cn/img%2F60339f72edfb8aaa76c4f0920bedfdb2?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=mrE6d5ixd2tzDVNxg7Kc53rg/Rc=&iopcmd=thumbnail&type=4&width=300"
 }
 */

@end
