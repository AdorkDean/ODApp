//
//  ODHomeFoundModel.h
//  ODApp
//
//  Created by 代征钏 on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"



@interface ODHomeFoundModel : ODAppModel

- (instancetype)initWithDict:(NSDictionary *)dict;


@property (nonatomic, copy) NSString *banner_url;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *title;

@end


/*
 {
 "status": "success",
 "result": [
 {
 "banner_url": "http://ciicwxprd.chinacloudapp.cn/index.aspx?store_id=1&open_id=766148455eed214ed1f8",
 "img_url": "http://odfile.ufile.ucloud.cn/img%2F6f7b62d9891973bdff350b4365036ae5?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=wb6+NqNkM1maaPJQfe7i66OfqRc=&iopcmd=thumbnail&type=4&width=960",
 "title": "视频简历大赛"
 }
 ]
 }
 */