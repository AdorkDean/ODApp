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
#define kCommunityCellId @"ODCommunityCollectionCell"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kRGBAWithColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define kBazaarUnlimitTaskUrl @"http://api.odong.com/1.0/task/list"
#define kBazaarLabelSearchUrl @"http://api.odong.com/1.0/task/tag/search"
#define kBazaarReleaseTaskUrl @"http://api.odong.com/1.0/task/task/add"
#define kBazaarTaskDetailUrl @"http://api.odong.com/1.0/task/detail"
#define kBazaarAcceptTaskUrl @"http://api.odong.com/1.0/task/apply"

#define kCommunityBbsListUrl @"http://api.odong.com/1.0/bbs/list/latest"
#define kCommunityReleaseBbsUrl @"http://api.odong.com/1.0/bbs/create"
#define kCommunityBbsDetailUrl @"http://api.odong.com/1.0/bbs/view"
#define kCommunityBbsSearchUrl @"http://api.odong.com/1.0/bbs/search"


#endif /* Define_h */
