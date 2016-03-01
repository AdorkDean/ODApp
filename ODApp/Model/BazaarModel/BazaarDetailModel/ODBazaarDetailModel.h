//
//  ODBazaarDetailModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODBazaarDetailModel : ODAppModel

@property(nonatomic, copy) NSString *task_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *task_type;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *user_nick;
@property(nonatomic, copy) NSString *user_sign;
@property(nonatomic, copy) NSString *task_created_at;
@property(nonatomic, copy) NSString *task_datetime;
@property(nonatomic, copy) NSString *reward_name;
@property(nonatomic, copy) NSString *task_status;
@property(nonatomic, copy) NSString *task_status_name;
@property(nonatomic, copy) NSString *apply_status;
@property(nonatomic, strong) NSMutableDictionary *share;


/**
 *   "task_id": 1,
 "title": "找人帮忙买车票",
 "content": "哪位同学有空帮我去买张 上海到盐城大丰的车票啊？ 小弟不胜感激，必当重谢！",
 "task_type": 1,
 "open_id": "920490656493c28aec27",
 "avatar": "http://odfile.ufile.ucloud.cn/img%2Fa2778a3235c96812bb34dccd3b995947?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=Sw5V5JSihmgnmD4u2etun/uZ8Tc=&iopcmd=thumbnail&type=4&width=300",
 "user_nick": "",
 "user_sign": "",
 "task_created_at": "2015/12/17 15:32:57",
 "tags": [
 {
 "tag_id": 1,
 "tag_name": "买车票"
 }
 ],
 "task_datetime": "2015/12/17 10:00 - 2015/12/30 20:30",
 "reward_name": "打一顿",
 "task_status": 1,
 "applys": [
 {
 "user_id": 2,
 "avatar": "http://odfile.ufile.ucloud.cn/img%2Fa2778a3235c96812bb34dccd3b995947?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=Sw5V5JSihmgnmD4u2etun/uZ8Tc=&iopcmd=thumbnail&type=4&width=300",
 "sign": "",
 "apply_status": 0
 },
 {
 "user_id": 11,
 "avatar": "http://odfile.ufile.ucloud.cn/img%2Fa2778a3235c96812bb34dccd3b995947?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=Sw5V5JSihmgnmD4u2etun/uZ8Tc=&iopcmd=thumbnail&type=4&width=300",
 "sign": "",
 "apply_status": 0
 */
@end
