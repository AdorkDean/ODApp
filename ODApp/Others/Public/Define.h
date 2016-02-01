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
#define kBazaarRewardCellId @"ODBazaarRewardCollectionCell"
#define kBazaarDetailCellId @"ODBazaarDetailCollectionCell"
#define kCommunityCellId @"ODCommunityCollectionCell"
#define kCommunityDetailCellId @"ODCommunityDetailCell"
#define kMyApplyActivityCellId @"ONMyApplyActivityCell"
#define kMyOrderRecordCellId @"ODMyOrderRecordCell"

//屏幕尺寸
#define kScreenSize [UIScreen mainScreen].bounds.size

#define KScreenWidth kScreenSize.width

#define KScreenHeight kScreenSize.height

#define KControllerHeight KScreenHeight - ODTopY

#define kRGBAWithColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define iPhone4_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1920, 1080), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* Define_h */
