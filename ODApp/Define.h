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

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kRGBAWithColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define kBazaarUnlimitTaskUrl @"http://woquapi.odong.com/1.0/task/list"
#define kBazaarLabelSearchUrl @"http://woquapi.odong.com/1.0/task/tag/search"
#define kBazaarReleaseTaskUrl @"http://woquapi.odong.com/1.0/task/task/add"
#define kBazaarTaskDetailUrl @"http://woquapi.odong.com/1.0/task/detail"
#define kBazaarAcceptTaskUrl @"http://woquapi.odong.com/1.0/task/apply"
#define kBazaarReleaseRewardUrl @"http://woquapi.odong.com/1.0/other/config/info"

#define kCommunityBbsListUrl @"http://woquapi.odong.com/1.0/bbs/list/latest"
#define kCommunityReleaseBbsUrl @"http://woquapi.odong.com/1.0/bbs/create"
#define kCommunityBbsDetailUrl @"http://woquapi.odong.com/1.0/bbs/view"
#define kCommunityBbsSearchUrl @"http://woquapi.odong.com/1.0/bbs/search"
#define kCommunityBbsReplyListUrl @"http://woquapi.odong.com/1.0/bbs/reply/list"
#define kCommunityBbsReplyUrl @"http://woquapi.odong.com/1.0/bbs/reply"
#define kPushImageUrl @"http://woquapi.odong.com/1.0/other/base64/upload"

#endif /* Define_h */
