//
//  ODMyOrderRecordController.h
//  ODApp
//
//  Created by Bracelet on 16/1/8.
//  Copyright © 2016年 Odong  Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODClassMethod.h"
#import "ODMyOrderRecordCell.h"
#import "ODMyOrderrecordModel.h"
#import "ODMyOrderDetailController.h"
#import "ODTabBarController.h"

#import "MJRefresh.h"

@interface ODMyOrderRecordController : ODBaseViewController <UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, copy) NSString *open_id;

/**
 *  是否刷新
 */
@property(nonatomic, assign) BOOL isRefresh;
/**
 *  标题
 */
@property(nonatomic, copy) NSString *centerTitle;

/**
 *  是否是他人个人中心
 */
@property(nonatomic, assign) BOOL isOther;

@end
