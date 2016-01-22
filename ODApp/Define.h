//
//  Define.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#ifndef Define_h
#define Define_h


#define kBazaarCellId @"ODBazaarCollectionCell"
#define kBazaaeSearchCellId @"ODBazaarSearchCell"
#define kBazaarDetailCellId @"ODBazaarDetailCollectionCell"
#define kCommunityCellId @"ODCommunityCollectionCell"
#define kCommunityDetailCellId @"ODCommunityDetailCell"
#define kMyApplyActivityCellId @"ONMyApplyActivityCell"
#define kMyOrderRecordCellId @"ODMyOrderRecordCell"

// 方法过期
#define ODExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
// 判断手机的系统版本
#define iOS(v) ([UIDevice currentDevice].systemVersion.doubleValue >= (v))

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kRGBAWithColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define iPhone4_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1920, 1080), [[UIScreen mainScreen] currentMode].size) : NO)

//#define

#define kBaseUrl @"http://woquapi.test.odong.com/"

#define kBazaarUnlimitTaskUrl @"http://woquapi.test.odong.com/1.0/task/list"
#define kBazaarLabelSearchUrl @"http://woquapi.test.odong.com/1.0/task/tag/search"
#define kBazaarReleaseTaskUrl @"http://woquapi.test.odong.com/1.0/task/task/add"
#define kBazaarTaskDetailUrl @"http://woquapi.test.odong.com/1.0/task/detail"
#define kBazaarTaskDelegateUrl @"http://woquapi.test.odong.com/1.0/task/accept"
#define kBazaarAcceptTaskUrl @"http://woquapi.test.odong.com/1.0/task/apply"
#define kBazaarReleaseRewardUrl @"http://woquapi.test.odong.com/1.0/other/config/info"

#define kCommunityBbsListUrl @"http://woquapi.test.odong.com/1.0/bbs/list/latest"
#define kCommunityReleaseBbsUrl @"http://woquapi.test.odong.com/1.0/bbs/create"
#define kCommunityBbsDetailUrl @"http://woquapi.test.odong.com/1.0/bbs/view"
#define kCommunityBbsSearchUrl @"http://woquapi.test.odong.com/1.0/bbs/search"
#define kCommunityBbsReplyListUrl @"http://woquapi.test.odong.com/1.0/bbs/reply/list"
#define kCommunityBbsReplyUrl @"http://woquapi.test.odong.com/1.0/bbs/reply"
#define kPushImageUrl @"http://woquapi.test.odong.com/1.0/other/base64/upload"
#define kDeleteReplyUrl @"http://woquapi.test.odong.com/1.0/bbs/del"

#define kHomeFoundListUrl @"http://woquapi.test.odong.com/1.0/bbs/list"
#define kHomeFoundPictureUrl @"http://woquapi.test.odong.com/1.0/other/banner"
#define kMyOrderRecordUrl @"http://woquapi.test.odong.com/1.0/store/orders"
#define kMyOrderDetailUrl @"http://woquapi.test.odong.com/1.0/store/info/order"
#define kMyApplyActivityUrl @"http://woquapi.test.odong.com/1.0/store/apply/my"
#define kCancelMyOrderUrl @"http://woquapi.test.odong.com/1.0/store/cancel/order"
#define kOthersInformationUrl @"http://woquapi.test.odong.com/1.0/user/info"

#endif /* Define_h */
