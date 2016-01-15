//
//  ODMyOrderRecordController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODMyOrderRecordCell.h"
#import "ODAPIManager.h"
#import "ODMyOrderrecordModel.h"
#import "ODMyOrderDetailController.h"
#import "ODTabBarController.h"

#import "MJRefresh.h"
#import "AFNetworking.h"

@interface ODMyOrderRecordController : ODBaseViewController<UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@property (nonatomic, strong)UIView *headView;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong)NSMutableArray *orderArray;

@end
